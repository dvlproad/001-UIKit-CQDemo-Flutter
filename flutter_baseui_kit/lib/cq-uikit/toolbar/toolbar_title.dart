/*
 * @Author: dvlproad
 * @Date: 2022-04-13 19:32:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:20:38
 * @Description: 
 */
// appbar 上 左侧返回视图 + 中间标题视图 + 右侧按钮视图
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import './toolbar_enum.dart';
import '../../flutter_baseui_kit_adapt.dart';

// 左侧返回视图
class ToolBarTitleWidget extends StatelessWidget {
  final String? text;
  final AppBarTextColorType? textColorType;
  final double? width;

  final VoidCallback? onPressed;

  const ToolBarTitleWidget({
    Key? key,
    required this.text,
    this.textColorType = AppBarTextColorType.default_black,
    this.width,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color textColor = Color(0xFF222222);
    if (textColorType == AppBarTextColorType.white) {
      textColor = Colors.white;
    } else if (textColorType == AppBarTextColorType.theme) {
      textColor = Color(0xFFFF7F00);
    }

    return TextButton(
      child: Text(
        this.text ?? '',
        style: TextStyle(
          color: textColor,
          fontSize: 18.f_pt_cj,
          fontWeight: FontWeight.w500,
        ),
      ),
      onPressed: this.onPressed,
    );

    // return Center(
    //   // 保证文本的竖直居中
    //   child: Text(
    //     widget.titleText ?? '',
    //     textAlign: TextAlign.center, // 只会保证文本的水平居中
    //     style: TextStyle(
    //       color: const Color(0xFF222222),
    //       fontSize: 15,
    //       fontWeight: FontWeight.bold,
    //     ),
    //   ),
    // );
  }
}
