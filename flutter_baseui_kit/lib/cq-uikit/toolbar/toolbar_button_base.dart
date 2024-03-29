/*
 * @Author: dvlproad
 * @Date: 2022-05-12 19:19:37
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 13:20:30
 * @Description: toolbar 上 的左右两侧按钮视图
 */
import '../../button/tap_view/tap_widget.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_button_base/flutter_button_base.dart';
import '../../button/flutter_button_base.dart';

import '../../flutter_baseui_kit_adapt.dart';

class ToolBarEnum {
  static double toolBarActionTextWidth = 67.w_pt_cj;
}

// tool图片按钮视图
class ToolBarImageActionWidget extends StatelessWidget {
  final double? width;
  final Color? color;
  final EdgeInsets? padding;

  final Image? image;
  final VoidCallback? onPressed;

  const ToolBarImageActionWidget({
    Key? key,
    this.width,
    this.padding,
    this.color,
    required this.image,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // [Flutter Image 参数详解](https://blog.csdn.net/chenlove1/article/details/84111554)
    //BoxFit.cover:以原图填满Image为目的，如果原图size大于Image的size，按比例缩小，居中显示在Image上。如果原图size小于Image的size，则按比例拉升原图的宽和高，填充Image居中显示。
    return DebounceTapWidget(
      onTap: this.onPressed,
      child: Container(
        width: width ?? 44.w_pt_cj,
        height: 44.h_pt_cj,
        color: color ?? Colors.white, /// 如果不给默认颜色，container的点击响应区域只有中间的图片
        padding: padding,
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
    // /*
    return ThemeBGButton(
      width: width,
      height: 32.h_pt_cj,
      // bgColorType: ThemeBGType.theme,
      bgColor: color,
      textColor: textColor,
      cornerRadius: 16,
      title: this.text,
      titleStyle: TextStyle(
        fontFamily: 'PingFang SC',
        color: textColor,
        fontSize: 13.f_pt_cj,
        fontWeight: FontWeight.w500,
        // height: 1,
      ),
      enable: true,
      onPressed: this.onPressed,
    );
    // */
    // ignore: dead_code
    return GestureDetector(
      onTap: this.onPressed,
      child: Container(
        color: color,
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'PingFang SC',
            color: const Color(0xff333333),
            fontSize: 13.w_pt_cj,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
