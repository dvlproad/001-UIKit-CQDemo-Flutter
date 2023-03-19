/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-01-30 16:13:00
 * @Description: 愿望单标签视图
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './wish_tag_widget.dart';
import '../model/tag_model.dart';

class TagsWidget extends StatefulWidget {
  double width;
  double height;
  final Color color;

  List<TagModel> tagModels;
  void Function(
    List<TagModel> newTagModels, {
    @required int selectTagIndex,
  }) tagModelsChangeBlock;

  TagsWidget({
    Key key,
    this.width,
    this.height,
    this.color,
    @required this.tagModels,
    @required this.tagModelsChangeBlock,
  }) : super(key: key);

  @override
  State<TagsWidget> createState() => _TagsWidgetState();
}

class _TagsWidgetState extends State<TagsWidget> {
  List<TagModel> _tagModels;

  @override
  void initState() {
    super.initState();
  }

  int crossAxisCount = 3;
  double childAspectRatio = 105 / 30;
  double mainAxisSpacing = 3.5.w_pt_cj; // 竖直滚动，这是行距离
  double crossAxisSpacing = 15.h_pt_cj; // 竖直滚动，这是水平距离
  double itemWidth, itemHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double selfViewWidth = constraints.maxWidth;
        double selfViewHeight = constraints.maxHeight;

        itemWidth = (selfViewWidth - (crossAxisCount - 1) * crossAxisSpacing )/ crossAxisCount;
        itemHeight = itemWidth / childAspectRatio;
        print("itemWidth = $itemWidth, itemHeight = $itemHeight");

        return buildContent(context);
      },
    );
  }

  Widget buildContent(BuildContext context) {
    _tagModels = widget.tagModels ?? [];
    return Container(
      color: widget.color,
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: 0.5.h_pt_cj),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          childAspectRatio: childAspectRatio,
          mainAxisSpacing: mainAxisSpacing,
          crossAxisSpacing: crossAxisSpacing,
        ),
        itemCount: _tagModels.length,
        itemBuilder: (BuildContext context, int index) {
          TagModel tagModel = _tagModels[index];

          // 是否显示标签右侧的选择icon
          bool showRightIcon = false;
          if (index != 2) {
            if (_tagModels[index].isChoose != true) {
              showRightIcon = true;
            }
          }

          return WishTagView(
            width: itemWidth,
            height: itemHeight,
            imagePosition: showRightIcon == true
                ? ButtonImagePosition.right
                : ButtonImagePosition.none,
            tagModel: tagModel,
            tagModelChangeBlock: (TagModel newTagModel) {
              tagModel = newTagModel;

              // 清理其他tag的选中状态和之前的选中值
              int tagCount = _tagModels.length ?? 0;
              for (var i = 0; i < tagCount; i++) {
                var item = _tagModels[i];

                bool isNewSelectedTag = i == index;
                item.isChoose = isNewSelectedTag;
                if (isNewSelectedTag == false) {
                  item.selectedLeafTagInfo = null;
                }
              }

              if (widget.tagModelsChangeBlock != null) {
                widget.tagModelsChangeBlock(_tagModels, selectTagIndex: index);
              }
            },
            // selectedLeafTagChangeBlock:
            //     (SelectedTagInfo selectedLeafTagInfo) {
            //   int tagCount = _tagModels.length ?? 0;
            //   for (var i = 0; i < tagCount; i++) {
            //     var item = _tagModels[i];

            //     bool isNewSelectedTag = i == index;
            //     item.isChoose = isNewSelectedTag;
            //     // if (isNewSelectedTag == false) {
            //     //   item.realChooseDateString = null; // 确保清空之前可能已选择选择的数据
            //     //   item.selectedChildIndex = -1;
            //     // }
            //   }
            //   if (widget.tagModelsChangeBlock != null) {
            //     widget.tagModelsChangeBlock(_tagModels);
            //   }
            // },
          );
        },
      ),
    );
  }

  /*
  /// 单选标签
  _singleChooseTag(int index) {
    int tagCount = _tagModels.length;
    for (var i = 0; i < tagCount; i++) {
      TagModel tagModel = _tagModels[i];
      tagModel.isChoose = i == index;
    }
    if (widget.tagModelsChangeBlock != null) {
      widget.tagModelsChangeBlock(_tagModels);
    }
  }
  */
}
