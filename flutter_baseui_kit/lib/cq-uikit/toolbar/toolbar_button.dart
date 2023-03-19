/*
 * @Author: dvlproad
 * @Date: 2022-04-13 19:32:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 18:56:53
 * @Description: toolbar上的左侧返回视图(如果返回视图是图片，则会根据title颜色和导航栏背景色来共同决定是什么图片)
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import './toolbar_button_base.dart';

import '../../flutter_baseui_kit_adapt.dart';

enum QuickToolBarImageType {
  white,
  white_bgClear,
  black,
  black_bgClear,
}

class QuickToolBarImageActionWidget extends StatelessWidget {
  final double? width;
  final QuickToolBarImageType? imageType;
  final VoidCallback? onPressed;

  const QuickToolBarImageActionWidget({
    Key? key,
    this.width,
    this.imageType,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageName;
    Color? imageColor;
    if (imageType == QuickToolBarImageType.white_bgClear) {
      imageName = 'assets/appbar/nav_back_white_clear.png';
    } else if (imageType == QuickToolBarImageType.white) {
      imageName = 'assets/appbar/nav_back_white.png';
    } else if (imageType == QuickToolBarImageType.black_bgClear) {
      imageName = 'assets/appbar/nav_back_black_clear.png';
    } else {
      imageName = 'assets/appbar/nav_back_black.png';
    }

    return ToolBarImageActionWidget(
      width: width,
      color: Colors.transparent,
      image: Image(
        image: AssetImage(
          imageName,
          package: 'flutter_baseui_kit',
        ),
        fit: BoxFit.cover,
        color: imageColor,
        width: 22.w_pt_cj,
        height: 22.h_pt_cj,
      ),
      onPressed: this.onPressed,
    );
  }
}
