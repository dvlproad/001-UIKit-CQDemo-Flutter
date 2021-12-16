import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import './pickercreater.dart';
import './showModal_util.dart';

class ItemPickerPickerUtil {
  ///事项选择器
  static void chooseItem(
    BuildContext context, {
    String title,
    @required List<String> itemTitles,
    int currentSelectedIndex = 0,
    @required void Function(int selectedIndex) onConfirm,
  }) async {
    Picker picker = getItemPicker(
      title: title,
      pickerdata: itemTitles,
      selectedIndex: currentSelectedIndex,
      onConfirm: onConfirm,
      onFooterCancel: () {
        Navigator.pop<List<int>>(context, null);
      },
    );

    final result = await ShowModalUtil.showInBottom(
      context: context, //state.context,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return getItemPickerWidget(picker);
      },
    );

    print("事项选择result: $result"); // ffoldKey.currentState);
  }

  static Widget getItemPickerWidget(Picker picker) {
    return picker.makePicker(null, true);
  }

  static Picker getItemPicker({
    String title,
    List pickerdata,
    int selectedIndex = 0,
    void Function() onFooterCancel,
    @required void Function(int selectedIndex) onConfirm,
  }) {
    PickerAdapter adapter = PickerDataAdapter<String>(pickerdata: pickerdata);

    Picker picker = PickerCreaterUtil.getPicker(
      title: title,
      adapter: adapter,
      selecteds: [selectedIndex ?? 0],
      onFooterCancel: () {
        if (onFooterCancel != null) {
          onFooterCancel();
        }
      },
      onConfirm: (Picker picker, List<int> selected) {
        if (onConfirm != null) {
          print('所选择的序号:${selected.toString()},且其内容为${picker.adapter.text}');
          var selectedIndex = selected[0];
          onConfirm(selectedIndex);
        }
      },
    );

    // Picker picker = Picker(
    //   adapter: adapter,
    //   changeToFirst: true,
    //   hideHeader: false,
    //   selectedTextStyle: TextStyle(color: Colors.blue),
    //   // builderHeader: (context) {
    //   //   final picker = PickerWidget.of(context);
    //   //   return picker?.data?.title ?? Text("xxx");
    //   // },
    //   onConfirm: (picker, value) {
    //     print(value.toString());
    //     print(picker.adapter.text);
    //   },
    // );

    return picker;
  }
}
