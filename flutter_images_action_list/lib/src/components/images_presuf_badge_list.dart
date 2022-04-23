/*
 * @Author: dvlproad
 * @Date: 2022-04-22 15:05:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-22 17:26:32
 * @Description: 列表 增加 maxAddCount 设置
 */
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import './fix_grid_view.dart';

class CQImagesPreSufBadgeList extends StatefulWidget {
  final double width;
  final double height;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex) dragCompleteBlock;

  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;
  final Widget Function({BuildContext context, int imageIndex})
      imageItemBuilder;

  final double columnSpacing;
  final double rowSpacing;

  /**< 通过每行可显示的最多列数来设置每个cell的宽度*/
  final int cellWidthFromPerRowMaxShowCount;

  /**< 宽高比（默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5） */
  final double widthHeightRatio;

  CQImagesPreSufBadgeList({
    Key key,
    this.width,
    this.height,
    this.dragEnable, // 是否可以拖动
    this.dragCompleteBlock,
    @required this.imageCount,
    this.maxAddCount = 100000,
    this.prefixWidget, // 可以为'添加'按钮
    this.suffixWidget, // 可以为'添加'按钮
    this.columnSpacing, //水平列间距
    this.rowSpacing, // 竖直行间距
    this.cellWidthFromPerRowMaxShowCount,
    this.widthHeightRatio,
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
    Widget prefixWidget = widget.prefixWidget;
    if (prefixWidget != null && itemCount >= maxShowCount) {
      prefixWidget = null;
    }

    Widget suffixWidget = widget.suffixWidget;
    if (suffixWidget != null && itemCount >= maxShowCount) {
      suffixWidget = null;
    }

    return FixGridView(
      width: widget.width,
      height: widget.height,
      dragEnable: widget.dragEnable,
      dragCompleteBlock: widget.dragCompleteBlock,
      itemCount: itemCount,
      itemBuilder: ({context, index}) {
        if (allowAddPrefixWidget == true && index == 0) {
          return widget.prefixWidget;
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
      suffixWidget: suffixWidget,
      columnSpacing: widget.columnSpacing,
      rowSpacing: widget.rowSpacing,
      cellWidthFromPerRowMaxShowCount: widget.cellWidthFromPerRowMaxShowCount,
    );

//
    // return Container(
    //   color: Colors.transparent,
    //   child: GridView.builder(
    //     shrinkWrap: true, //该属性表示是否根据子组件的总长度来设置ListView的长度，默认值为false
    //     physics: const NeverScrollableScrollPhysics(), // 不响应用户的滚动
    //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
    //     gridDelegate: widget.customGridDelegate ??
    //         SliverGridDelegateWithFixedCrossAxisCount(
    //           crossAxisCount: 3,
    //           mainAxisSpacing: 10,
    //           crossAxisSpacing: 10,
    //         ),
    //     itemCount: itemCount,
    //     itemBuilder: (context, index) {
    //       if (allowAddPrefixWidget == true && index == 0) {
    //         return widget.prefixWidget;
    //       }
    //       if (allowAddSuffixWidget == true && index == itemCount - 1) {
    //         return widget.suffixWidget;
    //       }

    //       int imageOrPhotoModelIndex = index;
    //       if (allowAddPrefixWidget == true) {
    //         imageOrPhotoModelIndex = index - 1;
    //       }

    //       return widget.imageItemBuilder(
    //         context: context,
    //         imageIndex: imageOrPhotoModelIndex,
    //       );
    //     },
    //   ),
    // );
  }
}
