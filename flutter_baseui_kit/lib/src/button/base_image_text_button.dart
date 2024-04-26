/*
 * @Author: dvlproad
 * @Date: 2024-04-24 17:07:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-24 17:22:09
 * @Description: 
 */
import 'package:flutter/material.dart';
import './basebutton.dart';
import './button_child_widget.dart';

/// 图片+文字 的底层按钮(和iOS原生一样可配置 Normal 和 Selected 风格的按钮)
class CJButton extends CJBaseButton {
  CJButton({
    Key? key,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,

    // child 内容的设置属性
    String? title,
    String? selectedTitle,
    TextStyle? titleStyle,
    Image? imageWidget, // 图片
    ButtonImagePosition? imagePosition,
    double? imageTitleGap, // 图片和文字之间的距离(imageWidget存在的时候才有效)

    MainAxisAlignment childMainAxisAlignment = MainAxisAlignment.center,
    VoidCallback? onPressed,
    VoidCallback? onPressedUnable,
    bool enable = true,
    bool selected = false,
    double cornerRadius = 5.0,
    required CJButtonConfigModel normalConfig,
    CJButtonConfigModel? normalDisableConfig,
    CJButtonConfigModel? selectedConfig,
    CJButtonConfigModel? selectedDisableConfig,
  }) : super(
          key: key,
          width: width,
          height: height,
          constraints: constraints,
          margin: margin,
          padding: padding,
          childBuider: (bSelected) {
            String? _currentTitle = selected == true ? selectedTitle : title;
            return ButtonChildWidget(
              title: _currentTitle,
              titleStyle: titleStyle,
              imageWidget: imageWidget,
              imagePosition: imagePosition,
              imageTitleGap: imageTitleGap,
            );
          },
          childMainAxisAlignment: childMainAxisAlignment,
          onPressed: onPressed,
          onPressedUnable: onPressedUnable,
          enable: enable,
          selected: selected,
          cornerRadius: cornerRadius,
          normalConfig: normalConfig,
          normalDisableConfig: normalDisableConfig,
          selectedConfig: selectedConfig,
          selectedDisableConfig: selectedDisableConfig,
        );
}
