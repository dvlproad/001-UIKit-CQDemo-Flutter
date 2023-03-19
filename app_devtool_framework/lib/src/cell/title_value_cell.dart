import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show ImageTitleTextValueCell, TableViewCellArrowImageType;
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class TitleValueCellFactory {
  static Widget rowCellWidget({
    required String title,
    String? textValue,
    double? textValueFontSize,
    int? textValueMaxLines,
  }) {
    if (textValue == null || textValue.isEmpty) {
      textValue = '未标明';
    }
    // return ImageTitleTextValueCell(
    //   title: title,
    //   textValue: textValue,
    //   textValueFontSize: textValueFontSize ?? 12,
    // );

    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _mainText(title),
          Expanded(child: _textValueWidget(textValue)),
        ],
      ),
    );
  }

  static Widget columnCellWidget({
    required String title,
    String? textValue,
    double? textValueFontSize,
    int? textValueMaxLines,
  }) {
    if (textValue == null || textValue.isEmpty) {
      textValue = '未标明';
    }

    return Container(
      width: double.infinity, // 设置撑满到最大
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _mainText(title),
          Container(
            color: Colors.transparent,
            alignment: Alignment.centerLeft,
            child: Text(
              textValue,
              textAlign: TextAlign.left,
              maxLines: textValueMaxLines,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.green,
                fontSize: textValueFontSize ?? 15,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 主文本
  static Widget mainText(String title) => _mainText(title);
  static Widget _mainText(String title) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Colors.black54,
          fontFamily: 'PingFang SC',
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  static Widget _textValueWidget(String textValue,
      {double? textValueFontSize}) {
    // // 自动缩小字体的组件
    // return FlutterAutoText(
    //   text: this.textValue ?? '',
    // );

    //创建随机颜色
    // Color randomColor = Color.fromARGB(255, Random.secure().nextInt(255), Random.secure().nextInt(255), Random.secure().nextInt(255));
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      constraints: const BoxConstraints(maxWidth: 180, minHeight: 30),
      color: Colors.transparent,
      alignment: Alignment.centerRight,
      child: Text(
        textValue,
        textAlign: TextAlign.right,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: const Color(0xff999999),
          fontSize: textValueFontSize ?? 15,
          fontFamily: 'PingFang SC',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  // 箭头
  static Widget arrowImage() => _arrowImage();
  static Widget _arrowImage() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: const Image(
        image:
            AssetImage('assets/arrow_right.png', package: 'flutter_baseui_kit'),
        width: 17,
        height: 32,
      ),
    );
  }
}
