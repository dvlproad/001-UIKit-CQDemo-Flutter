/*
 * @Author: dvlproad
 * @Date: 2022-04-22 15:05:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-07 18:20:50
 * @Description: 列表 增加 maxAddCount 设置
 */
import 'package:flutter/material.dart';
import './fix_grid_view.dart';

class CQImagesPreSufBadgeList extends StatefulWidget {
  final double width;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;

  final Axis direction;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final int imageCount; // 图片个数(不包括prefixWidget/suffixWidget)
  final int maxAddCount;
  final Widget? prefixWidget;
  final Widget? suffixWidget;

  final Widget Function({
    required BuildContext context,
    required int imageIndex,
    required double itemWidth,
    required double itemHeight,
  }) imageItemBuilder;

  final double columnSpacing;
  final double rowSpacing;
  final int cellWidthFromPerRowMaxShowCount;
  final double itemWidthHeightRatio;

  CQImagesPreSufBadgeList({
    Key? key,
    required this.width,
    this.height,
    this.padding,
    this.color,
    this.direction = Axis.horizontal,
    this.scrollDirection = Axis.vertical,
    this.physics,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    required this.imageCount,
    this.maxAddCount = 100000,
    this.prefixWidget, // 可以为'添加'按钮
    this.suffixWidget, // 可以为'添加'按钮
    required this.columnSpacing, //水平列间距
    required this.rowSpacing, // 竖直行间距
    // 通过每行可显示的最多列数来设置每个cell的宽度
    required this.cellWidthFromPerRowMaxShowCount,
    // 宽高比(默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5)
    required this.itemWidthHeightRatio,
    required this.imageItemBuilder,
  }) : super(key: key);

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
    // ignore: unused_local_variable
    bool allowAddSuffixWidget = false;

    int imageCount = widget.imageCount;

    // 计算 itemCount (包括 prefixWidget\suffixWidget\imageWidget)
    int itemCount = imageCount;
    Widget? prefixWidget = widget.prefixWidget;
    if (prefixWidget != null && itemCount >= maxShowCount) {
      prefixWidget = null;
    }

    Widget? suffixWidget = widget.suffixWidget;
    if (suffixWidget != null && itemCount >= maxShowCount) {
      suffixWidget = null;
    }

    return FixGridView(
      width: widget.width,
      height: widget.height,
      padding: widget.padding,
      color: widget.color,
      direction: widget.direction,
      scrollDirection: widget.scrollDirection,
      physics: widget.physics,
      dragEnable: widget.dragEnable,
      dragCompleteBlock: widget.dragCompleteBlock,
      itemCount: itemCount,
      itemWidthHeightRatio: widget.itemWidthHeightRatio,
      itemBuilder: ({
        required BuildContext context,
        required int index,
        required double itemHeight,
        required double itemWidth,
      }) {
        if (allowAddPrefixWidget == true && index == 0) {
          return widget.prefixWidget!;
        }

        int imageOrPhotoModelIndex = index;
        if (allowAddPrefixWidget == true) {
          imageOrPhotoModelIndex = index - 1;
        }

        return widget.imageItemBuilder(
          context: context,
          imageIndex: imageOrPhotoModelIndex,
          itemWidth: itemWidth,
          itemHeight: itemHeight,
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
