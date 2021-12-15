import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class PickerCreaterUtil {
  static Picker getPicker({
    String title,
    @required PickerAdapter adapter,
    List<int> selecteds,
    @required PickerConfirmCallback onConfirm,
  }) {
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
      selecteds: selecteds,
      cancelText: '取消',
      confirmText: '确定',
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
      onConfirm: onConfirm,
    );

    return picker;
  }
}
