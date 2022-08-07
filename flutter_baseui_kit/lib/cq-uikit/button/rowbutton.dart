/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:18:47
 * @Description: 
 */
import 'package:flutter/material.dart';
import '../../base-uikit/button/textbutton.dart';
import './button_child_widget.dart';
import './buttontheme.dart';

/// 以主题色为背景的按钮
class ThemeBGButton extends CJStateTextButton {
  ThemeBGButton({
    Key? key,
    double? width,
    double? height,
    required ThemeBGType bgColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
    Image? imageWidget, // 图片
    double? imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    double? cornerRadius = 5.0,
    bool enable = true,
    required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          childBuider: (bSelected) {
            return ButtonChildWidget(
              title: title,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor(bgColorType),
          normalTextColor: themeOppositeColor(bgColorType),
          normalBorderWidth: 0.0,
          normalBorderColor: themeOppositeColor(bgColorType),
          // normalHighlightColor: Colors.yellow,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}

/// 以主题色为边框的按钮(①红色边框和文字，白色背景、②黑色边框和文字，白色背景)
class ThemeBorderButton extends CJStateTextButton {
  ThemeBorderButton({
    Key? key,
    double? width,
    double? height,
    required ThemeBGType borderColorType,
    bool needHighlight = false, // 是否需要高亮样式(默认false)
    required String title,
    TextStyle? titleStyle,
    Image? imageWidget, // 图片
    double? imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)
    double cornerRadius = 5.0,
    bool enable = true,
    required VoidCallback onPressed,
  })  : assert(title != null),
        assert(onPressed != null),
        super(
          key: key,
          width: width,
          height: height,
          childBuider: (bSelected) {
            return ButtonChildWidget(
              title: title,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imageTitleGap: imageTitleGap,
            );
          },
          enable: enable,
          selected: false,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeOppositeColor(borderColorType),
          normalTextColor: themeColor(borderColorType),
          normalBorderWidth: 1.0,
          normalBorderColor: themeColor(borderColorType),
          // normalHighlightColor: Colors.pink,
          highlightOpacity: needHighlight ? 0.7 : 1.0,
        );
}
