/*
 * @Author: dvlproad
 * @Date: 2022-05-12 19:19:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:53:53
 * @Description: toolbar 上 的左右两侧按钮视图
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../../flutter_baseui_kit_adapt.dart';

// tool图片按钮视图
class ToolBarImageActionWidget extends StatelessWidget {
  final double? width;
  final Color? color;

  final Image? image;
  final VoidCallback? onPressed;

  const ToolBarImageActionWidget({
    Key? key,
    this.width,
    this.color,
    @required this.image,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // [Flutter Image 参数详解](https://blog.csdn.net/chenlove1/article/details/84111554)
    //BoxFit.cover:以原图填满Image为目的，如果原图size大于Image的size，按比例缩小，居中显示在Image上。如果原图size小于Image的size，则按比例拉升原图的宽和高，填充Image居中显示。
    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
        width: width ?? 44.w_pt_cj,
        height: 44.h_pt_cj,
        color: color,
        alignment: Alignment.center,
        child: image,
      ),
    );
  }
}

// tool文本按钮视图
class ToolBarTextActionWidget extends StatelessWidget {
  final double? width;

  final Color? color;

  final String text;
  final Color? textColor;

  final VoidCallback? onPressed;

  const ToolBarTextActionWidget({
    Key? key,
    this.width, // 宽度(高度固定32)
    this.color,
    required this.text,
    this.textColor,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ThemeBGButton(
      width: width ?? 67.w_pt_cj,
      height: 32.h_pt_cj,
      // bgColorType: ThemeBGType.theme,
      bgColor: color,
      textColor: textColor,

      cornerRadius: 16,
      title: this.text,
      titleStyle: TextStyle(
        color: textColor,
        fontSize: 14.f_pt_cj,
        fontWeight: FontWeight.w500,
        // height: 1,
      ),
      enable: true,
      onPressed: this.onPressed,
    );
  }
}
