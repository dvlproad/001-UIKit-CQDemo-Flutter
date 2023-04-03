/*
 * @Author: dvlproad
 * @Date: 2022-05-09 14:13:56
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-03 16:06:13
 * @Description: 显示json内容的视图
 */

import 'package:flutter/material.dart';

class JSONText extends StatelessWidget {
  static void Function(dynamic value) onTap = (dynamic value) {};
  static void Function(dynamic value) onDoubleTap = (dynamic value) {};
  static void Function(dynamic value) onLongPress = (dynamic value) {};

  final String data;
  final TextStyle? style;
  final dynamic value;

  const JSONText(
    this.data, {
    Key? key,
    this.style,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        data,
        style: style,
      ),
      onTap: () => JSONText.onTap(value),
      onLongPress: () => JSONText.onLongPress(value),
      onDoubleTap: () => JSONText.onDoubleTap(value),
    );
  }
}
