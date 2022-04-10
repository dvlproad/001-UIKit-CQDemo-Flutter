import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CQImagesPreSufBadgeList extends StatefulWidget {
  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;
  final Widget Function({BuildContext context, int imageIndex})
      imageItemBuilder;

  CQImagesPreSufBadgeList({
    Key key,
    @required this.imageCount,
    this.maxAddCount = 100000,
    this.prefixWidget, // 可以为'添加'按钮
    this.suffixWidget, // 可以为'添加'按钮

    @required this.imageItemBuilder,
  })  : assert(imageItemBuilder != null),
        super(key: key);

  @override
  _CQImagesPreSufBadgeListState createState() =>
      _CQImagesPreSufBadgeListState();
}

class _CQImagesPreSufBadgeListState extends State<CQImagesPreSufBadgeList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxShowCount = widget.maxAddCount;
    bool allowAddPrefixWidget = false;
    bool allowAddSuffixWidget = false;

    int imageCount = widget.imageCount;

    // 计算 itemCount (包括 prefixWidget\suffixWidget\imageWidget)
    int itemCount = imageCount;
    if (widget.prefixWidget != null && itemCount < maxShowCount) {
      allowAddPrefixWidget = true;
      itemCount++;
    }
    if (widget.suffixWidget != null && itemCount < maxShowCount) {
      allowAddSuffixWidget = true;
      itemCount++;
    }

    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        shrinkWrap: true, //该属性表示是否根据子组件的总长度来设置ListView的长度，默认值为false
        physics: const NeverScrollableScrollPhysics(), // 不响应用户的滚动
        padding: EdgeInsets.fromLTRB(10, 10, 80, 10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (allowAddPrefixWidget == true && index == 0) {
            return widget.prefixWidget;
          }
          if (allowAddSuffixWidget == true && index == itemCount - 1) {
            return widget.suffixWidget;
          }

          int imageOrPhotoModelIndex = index;
          if (allowAddPrefixWidget == true) {
            imageOrPhotoModelIndex = index - 1;
          }

          return widget.imageItemBuilder(
            context: context,
            imageIndex: imageOrPhotoModelIndex,
          );
        },
      ),
    );
  }
}
