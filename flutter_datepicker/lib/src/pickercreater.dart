import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import './pickerheader.dart';
import './pickerfooter.dart';

class PickerCreaterUtil {
  static Picker getPicker({
    String title,
    @required PickerAdapter adapter,
    List<int> selecteds,
    VoidCallback onCancel,
    VoidCallback
        onFooterCancel, // 需要自己关闭弹窗 Navigator.pop<List<int>>(context, null);
    @required PickerConfirmCallback onConfirm,
    bool needConfirmAction = true, // 需要确认操作(需要时候，取消按钮和确认按钮都在顶部；不需要时候，取消按钮在底部)
  }) {
    double headerHeight = 60;

    needConfirmAction = false; // 测试代码
    needConfirmAction == null ? true : false;

    // 底部视图
    Widget footer = null;
    if (needConfirmAction == false) {
      footer = PickerFooter(
        cancelText: '取消',
        onCancel: () {
          if (onFooterCancel != null) {
            onFooterCancel();
          }
        },
      );
    }

    Picker picker = new Picker(
      adapter: adapter,
      title: new Text(
        title ?? "",
        style: TextStyle(
          color: Color(0xFF222222),
          fontFamily: 'PingFang SC',
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      /*
      builderHeader: (context) {
        return PickerHeader(
          height: headerHeight,
          title: 'title',
          onCancel: () {
            final PickerWidget picker22 = PickerWidget.of(context);
            //   return picker?.data?.title ?? Text("xxx");
            picker22
            if (picker22.onCancel != null) {
              picker22.onCancel();
            }
            // Navigator.pop<List<int>>(context, null);
            // if (widget.onCancel != null) {
            //   widget.onCancel();
            // }
          },
          onConfirm: () {
            final Picker picker22 = PickerWidget.of(context);
            //   return picker?.data?.title ?? Text("xxx");
            if (picker22.onConfirm != null) {
              print(picker22.getSelectedValues());
              picker22.onConfirm(picker22, picker.getSelectedValues());
            }

            // if (widget.onConfirm != null) {
            //   widget.onConfirm(_selectedIndex);
            // }
          },
        );
      },
    */
      selecteds: selecteds,
      onSelect: (picker, index, selected) {
        print(
            '所选择的序号:当前操作的是第${index}列，最后选中的项分别为${selected.toString()},且其内容为${picker.adapter.text}');
      },
      cancelText: needConfirmAction ? '取消' : '',
      confirmText: needConfirmAction ? '确定' : '',
      cancelTextStyle: TextStyle(
        color: Color(0xFF999999),
        fontFamily: 'PingFang SC',
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
      confirmTextStyle: TextStyle(
        color: Color(0xFFCD3F49),
        fontFamily: 'PingFang SC',
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.right,
      itemExtent: 40,
      height: 260, // 216
      backgroundColor: Colors.transparent,
      selectionOverlay: Container(
        color: Color(0xFFCD3F49).withOpacity(0.12),
        margin: EdgeInsets.only(left: 0, right: 0),
      ),
      selectedTextStyle: TextStyle(
        color: Color(0xFF222222),
        fontFamily: 'PingFang SC',
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
      onCancel: onCancel,
      onConfirm: onConfirm,
      footer: footer,
    );

    return picker;
  }
}
