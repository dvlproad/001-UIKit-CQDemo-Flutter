import 'package:flutter/material.dart';
import './itempicker.dart';
import './showModal_util.dart';

class ItemPickerUtil {
  ///事项选择器
  static void chooseItem(
    BuildContext context, {
    String title,
    @required List<String> itemTitles,
    int currentSelectedIndex,
    @required void Function(int selectedIndex) onConfirm,
  }) {
    ShowModalUtil.showInBottom(
      context: context, //state.context,
      builder: (BuildContext context) {
        return getItemPickerWidget(
          title: title,
          itemTitles: itemTitles,
          currentSelectedIndex: currentSelectedIndex,
          onCancel: () {
            Navigator.of(context).pop();
          },
          onConfirm: (int selectedIndex) {
            if (onConfirm != null) {
              Navigator.of(context).pop();
              onConfirm(selectedIndex);
            }
          },
        );
      },
    );
  }

  static Widget getItemPickerWidget({
    String title,
    @required List<String> itemTitles,
    int currentSelectedIndex,
    void Function() onCancel,
    @required void Function(int selectedIndex) onConfirm,
  }) {
    //return picker.makePicker(null, true);
    return ItemPickerWidget(
      title: title,
      itemTitles: itemTitles,
      currentSelectedIndex: currentSelectedIndex,
      onCancel: onCancel,
      onConfirm: (selectedIndex) async {
        if (onConfirm != null) {
          onConfirm(selectedIndex);
        }
      },
    );
  }
}
