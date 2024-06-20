/*
 * @Author: dvlproad
 * @Date: 2024-05-06 17:58:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-06-20 19:37:51
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_base_models/flutter_base_models.dart';
// import 'package:flutter_info_choose_kit/src/item_choose/base_grid_choose_list.dart';
// import 'package:flutter_images_action_list/src/components/images_presuf_badge_list.dart';

import './base_choose_item_view.dart';
import './base_grid_choose_list.dart';

import '../../flutter_info_choose_kit_adapt.dart';

class TSChooseGridView<T extends BaseChooseItemModel> extends StatelessWidget {
  final List<T> itemModels;
  final List<T> selectedModels;
  final int maxChooseCount;
  final void Function(int count)? beyondMaxChooseCount;
  final void Function(List<T> selectedItemModels) onValueChange;

  const TSChooseGridView({
    Key? key,
    required this.itemModels,
    required this.selectedModels,
    required this.maxChooseCount, // 最大选择数量(1代表单选)
    this.beyondMaxChooseCount,
    required this.onValueChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseGridChooseList<T>(
      width: 375.w_pt_cj,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 16.w_pt_cj, right: 16.w_pt_cj),
      // dragEnable: true,
      physics: const BouncingScrollPhysics(),
      columnSpacing: 10.w_pt_cj,
      rowSpacing: 12.h_pt_cj,
      itemModels: itemModels,
      selectedModels: selectedModels,
      cellWidthFromPerRowMaxShowCount: 2,
      itemWidthHeightRatio: 167.0 / 38.0,
      maxChooseCount: maxChooseCount,
      onValueChange: (List<T> selectedItemModels) {
        onValueChange(selectedItemModels);
      },
      beyondMaxChooseCount: beyondMaxChooseCount,
      imageItemBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
        required bool isSelected,
      }) {
        T item = itemModels[imageIndex];
        return BaseChooseItemView(
          height: itemHeight,
          item: item,
          isSelected: isSelected,
        );
      },
    );
  }
}

class TSChooseTableView<T extends BaseChooseItemModel> extends StatelessWidget {
  final List<T> itemModels;
  final List<T> selectedModels;
  final int maxChooseCount;
  final void Function(int count)? beyondMaxChooseCount;
  final void Function(List<T> selectedItemModels) onValueChange;

  const TSChooseTableView({
    Key? key,
    required this.itemModels,
    required this.selectedModels,
    required this.maxChooseCount, // 最大选择数量(1代表单选)
    this.beyondMaxChooseCount,
    required this.onValueChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseGridChooseList<T>(
      width: 375.w_pt_cj,
      // color: Colors.red,
      padding: EdgeInsets.only(left: 16.w_pt_cj, right: 16.w_pt_cj),
      // dragEnable: true,
      physics: const BouncingScrollPhysics(),
      columnSpacing: 13.w_pt_cj,
      rowSpacing: 0.h_pt_cj,
      itemModels: itemModels,
      selectedModels: selectedModels,
      cellWidthFromPerRowMaxShowCount: 1,
      itemWidthHeightRatio: 343.0 / 38.0,
      maxChooseCount: maxChooseCount,
      onValueChange: (List<T> selectedItemModels) {
        onValueChange(selectedItemModels);
      },
      beyondMaxChooseCount: beyondMaxChooseCount,
      imageItemBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
        required bool isSelected,
      }) {
        T item = itemModels[imageIndex];
        return BaseChooseItemView(
          height: itemHeight,
          item: item,
          isSelected: isSelected,
        );
      },
    );
  }
}
