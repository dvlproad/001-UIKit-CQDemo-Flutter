/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-06-20 18:27:51
 * @Description: 
 */
import 'package:flutter/material.dart';
import './itempicker.dart';
import 'show_modal_util.dart';

class ItemPickerUtil {
  ///事项选择器
  static void chooseItem(
    BuildContext context, {
    String? title,
    required List<String> itemTitles,
    int? currentSelectedIndex,
    required void Function(int selectedIndex) onConfirm,
  }) {
    ShowModalUtil.showInBottom(
      context: context, //state.context,
      builder: (BuildContext context) {
        return getItemPickerWidget(
          title: title,
          itemTitles: itemTitles,
          currentSelectedIndex: currentSelectedIndex,
          onCancel: () {
            Navigator.pop(context);
          },
          onConfirm: (int selectedIndex) {
            Navigator.pop(context);
            onConfirm(selectedIndex);
          },
        );
      },
    );
  }

  static Widget getItemPickerWidget({
    String? title,
    required List<String> itemTitles,
    int? currentSelectedIndex,
    void Function()? onCancel,
    required void Function(int selectedIndex) onConfirm,
  }) {
    //return picker.makePicker(null, true);
    return ItemPickerWidget(
      title: title,
      itemTitles: itemTitles,
      onItemTap: (selectedIndex) {
        onConfirm(selectedIndex);
      },
      currentSelectedIndex: currentSelectedIndex,
      onCancel: onCancel,
      onConfirm: (selectedIndex) async {
        onConfirm(selectedIndex);
      },
    );
  }
}
