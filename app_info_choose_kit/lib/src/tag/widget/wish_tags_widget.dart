/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-02 14:29:43
 * @Description: 愿望单标签视图
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';
import './wish_tag_widget.dart';
import '../model/tag_model.dart';

class TagsWidget extends StatefulWidget {
  List<TagModel> tagModels;
  void Function(
    List<TagModel> newTagModels, {
    @required int selectTagIndex,
  }) tagModelsChangeBlock;

  TagsWidget({
    Key key,
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

  @override
  Widget build(BuildContext context) {
    _tagModels = widget.tagModels ?? [];
    return Container(
      child: GridView.builder(
        padding: EdgeInsets.only(bottom: 0.5.h_pt_cj),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 55 / 15,
          mainAxisSpacing: 3.5.w_pt_cj,
          crossAxisSpacing: 3.5.h_pt_cj,
        ),
        itemCount: _tagModels.length,
        itemBuilder: (BuildContext context, int index) {
          TagModel tagModel = _tagModels[index];

          return WishTagView(
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
