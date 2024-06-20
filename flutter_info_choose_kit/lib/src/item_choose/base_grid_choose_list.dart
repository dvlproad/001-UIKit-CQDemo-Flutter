// ignore_for_file: implementation_imports

/*
 * @Author: dvlproad
 * @Date: 2024-05-06 17:58:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-16 11:19:19
 * @Description: 
 */
import 'package:flutter/material.dart';
// import 'package:flutter_info_choose_kit/src/item_choose/base_grid_choose_list.dart';
import 'package:flutter_images_action_list/src/components/images_presuf_badge_list.dart';

import 'package:flutter_base_models/flutter_base_models.dart';

class BaseGridChooseList<T extends BaseChooseItemModel> extends StatefulWidget {
  final double width;
  final double? height;
  final EdgeInsets? padding;
  final Color? color;

  final Axis direction;
  final Axis scrollDirection;
  final ScrollPhysics? physics;

  final Widget Function({
    required BuildContext context,
    required int imageIndex,
    required double itemWidth,
    required double itemHeight,
    required bool isSelected,
  }) imageItemBuilder;

  final double columnSpacing;
  final double rowSpacing;

  final int cellWidthFromPerRowMaxShowCount;
  final double itemWidthHeightRatio;

  final List<T> itemModels;
  final List<T> selectedModels;
  final int maxChooseCount;
  final void Function(int count)? beyondMaxChooseCount;

  final void Function(List<T> selectedItemModels) onValueChange;

  const BaseGridChooseList({
    Key? key,
    required this.width,
    this.height,
    this.padding,
    this.color,
    this.direction = Axis.horizontal,
    this.scrollDirection = Axis.vertical,
    this.physics,
    required this.columnSpacing, //水平列间距
    required this.rowSpacing, // 竖直行间距
    // 通过每行可显示的最多列数来设置每个cell的宽度
    required this.cellWidthFromPerRowMaxShowCount,
    // 宽高比(默认1:1,即1/1.0，请确保除数有小数点，否则1/2会变成0，而不是0.5)
    required this.itemWidthHeightRatio,
    required this.imageItemBuilder,
    required this.itemModels,
    required this.selectedModels,
    required this.maxChooseCount, // 最大选择数量(1代表单选)
    this.beyondMaxChooseCount,
    required this.onValueChange,
  }) : super(key: key);

  @override
  State<BaseGridChooseList> createState() => _BaseGridChooseListState<T>();
}

class _BaseGridChooseListState<T extends BaseChooseItemModel>
    extends State<BaseGridChooseList<T>> {
  late List<T> _items;
  List<T> currentSelectedItems = [];
  late int _maxChooseCount;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _maxChooseCount = widget.maxChooseCount;
    _items = widget.itemModels;

    // 不能使用 currentSelectedItems = widget.selectedModels; 不然修改currentSelectedItems时会修改到 selectedModels
    currentSelectedItems.addAll(widget.selectedModels);
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesPreSufBadgeList(
      width: widget.width,
      color: widget.color,
      padding: widget.padding,
      // dragEnable: true,
      physics: const BouncingScrollPhysics(),
      columnSpacing: widget.columnSpacing,
      rowSpacing: widget.rowSpacing,
      imageCount: _items.length,
      cellWidthFromPerRowMaxShowCount: widget.cellWidthFromPerRowMaxShowCount,
      itemWidthHeightRatio: widget.itemWidthHeightRatio,
      imageItemBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
      }) {
        T item = _items[imageIndex];
        // 1、判断点击是之前选中的还是新选中的
        T? hasChoosedItem;
        try {
          hasChoosedItem = currentSelectedItems
              .firstWhere((element) => element.id == item.id);
        } catch (e) {
          hasChoosedItem = null;
        }
        bool isSelected = hasChoosedItem != null;
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                _clickItemIndex(imageIndex);
              },
              child: widget.imageItemBuilder(
                context: context,
                imageIndex: imageIndex,
                itemHeight: itemHeight,
                itemWidth: itemWidth,
                isSelected: isSelected,
              ),
            ),
            // Visibility(
            //   visible: isSelected,
            //   child: Positioned(
            //     right: 0,
            //     top: 0,
            //     child: _deleteIcon(imageIndex),
            //   ),
            // ),
          ],
        );
      },
    );
  }

  _clickItemIndex(int itemIndex) {
    BaseChooseItemUtil.clickItemIndex<T>(
      itemIndex,
      sourceItems: _items,
      currentSelectedItems: currentSelectedItems,
      maxChooseCount: _maxChooseCount,
      onValueChange: (selectedItemModels) {
        widget.onValueChange(selectedItemModels);
        setState(() {
          // 此处记得更新界面
          //
        });
      },
      beyondMaxChooseCount: widget.beyondMaxChooseCount,
    );
  }
}
