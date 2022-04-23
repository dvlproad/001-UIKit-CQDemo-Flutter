/*
 * @Author: dvlproad
 * @Date: 2022-04-22 15:05:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-22 15:48:55
 * @Description: 可添加头尾的列表
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ImagesPreSufBadgeBaseList extends StatefulWidget {
  final double width;
  final double height;
  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final Widget prefixWidget;
  final Widget suffixWidget;
  final Widget Function({BuildContext context, int imageIndex})
      imageItemBuilder;
  final SliverGridDelegate customGridDelegate;

  ImagesPreSufBadgeBaseList({
    Key key,
    this.width,
    this.height,
    @required this.imageCount,
    this.prefixWidget, // 可以为'添加'按钮
    this.suffixWidget, // 可以为'添加'按钮
    this.customGridDelegate, // null时候,默认3列，间隔10

    @required this.imageItemBuilder,
  })  : assert(imageItemBuilder != null),
        super(key: key);

  @override
  _ImagesPreSufBadgeBaseListState createState() =>
      _ImagesPreSufBadgeBaseListState();
}

class _ImagesPreSufBadgeBaseListState extends State<ImagesPreSufBadgeBaseList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool allowAddPrefixWidget = false;
    bool allowAddSuffixWidget = false;

    int imageCount = widget.imageCount;

    // 计算 itemCount (包括 prefixWidget\suffixWidget\imageWidget)
    int itemCount = imageCount;
    if (widget.prefixWidget != null) {
      allowAddPrefixWidget = true;
      itemCount++;
    }

    if (widget.suffixWidget != null) {
      allowAddSuffixWidget = true;
      itemCount++;
    }

    return Container(
      color: Colors.transparent,
      child: GridView.builder(
        shrinkWrap: true, //该属性表示是否根据子组件的总长度来设置ListView的长度，默认值为false
        physics: const NeverScrollableScrollPhysics(), // 不响应用户的滚动
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        gridDelegate: widget.customGridDelegate ??
            SliverGridDelegateWithFixedCrossAxisCount(
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

          int imageIndex = index;
          if (allowAddPrefixWidget == true) {
            imageIndex = index - 1;
          }

          return widget.imageItemBuilder(
            context: context,
            imageIndex: imageIndex,
          );
        },
      ),
    );
  }
}
