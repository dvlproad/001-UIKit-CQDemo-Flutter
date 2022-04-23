/*
 * @Author: dvlproad
 * @Date: 2022-04-13 19:32:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-19 21:55:04
 * @Description: toolbar上的左侧返回视图(如果返回视图是图片，则会根据title颜色和导航栏背景色来共同决定是什么图片)
 */
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import './toolbar_button_base.dart';
import './toolbar_enum.dart';

import '../../flutter_baseui_kit_adapt.dart';

class ToolBarBackWidget extends StatelessWidget {
  final double width;
  final String text;
  final AppBarTextColorType textColorType; // 导航栏标题颜色能影响到返回按钮的颜色
  final Color appbarBackgroundColor;
  final VoidCallback
      onPressed; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

  const ToolBarBackWidget({
    Key key,
    this.width,
    this.text,
    this.textColorType = AppBarTextColorType.default_black,
    this.appbarBackgroundColor,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider image = null;
    Color textColor;
    if (this.text == null) {
      if (textColorType == AppBarTextColorType.white) {
        if (appbarBackgroundColor == Colors.transparent) {
          image = AssetImage(
            'assets/appbar/nav_back_black_clear.png',
            package: 'flutter_baseui_kit',
          );
        } else {
          image = AssetImage(
            'assets/appbar/nav_back_white.png',
            package: 'flutter_baseui_kit',
          );
        }
      } else {
        if (appbarBackgroundColor == Colors.transparent) {
          image = AssetImage(
            'assets/appbar/nav_back_black_clear.png',
            package: 'flutter_baseui_kit',
          );
        } else {
          image = AssetImage(
            'assets/appbar/nav_back_black.png',
            package: 'flutter_baseui_kit',
          );
        }
      }
      // lastWidth = 10;
    } else {
      if (textColorType == AppBarTextColorType.white) {
        textColor = Colors.white;
      } else {
        textColor = Color(0xFF222222);
      }
    }

    return ToolBarActionWidget(
      width: width,
      text: this.text,
      textColor: textColor,
      bgColor: Colors.transparent,
      image: image,
      needUpdateImageColor: false,
      onPressed: this.onPressed,
    );
  }
}
