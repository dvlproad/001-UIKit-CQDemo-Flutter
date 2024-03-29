/*
 * @Author: dvlproad
 * @Date: 2022-07-25 19:38:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:28:09
 * @Description: 
 */
import 'package:flutter/material.dart';
import './actionsheet.dart';
import './action/showModal_util.dart';

class ActionSheetUtil {
  ///事项选择器
  static void chooseItem(
    BuildContext context, {
    String? title,
    TextStyle? titleTextStyle,
    required List<String> itemTitles,
    int? currentSelectedIndex,
    required void Function(int selectedIndex) onConfirm,
  }) {
    ShowModalUtil.showInBottom(
      context: context, //state.context,
      builder: (BuildContext context) {
        return getActionSheetWidget(
          title: title,
          titleTextStyle: titleTextStyle,
          itemTitles: itemTitles,
          currentSelectedIndex: currentSelectedIndex,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: (int selectedIndex) {
            Navigator.of(context).pop();
            onConfirm(selectedIndex);
          },
        );
      },
    );
  }

  static Widget getActionSheetWidget({
    String? title,
    TextStyle? titleTextStyle,
    required List<String> itemTitles,
    int? currentSelectedIndex,
    void Function()? onCancel,
    required void Function(int selectedIndex) onConfirm,
  }) {
    //return picker.makePicker(null, true);
    return ActionSheetWidget(
      title: title,
      titleTextStyle: titleTextStyle,
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
