import 'package:flutter/material.dart';
import './basebutton.dart';

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮，并且背景和边框文字的颜色互为反面)
class CJReverseThemeStateTextButton extends CJStateTextButton {
  const CJReverseThemeStateTextButton({
    Key? key,
    double? width,
    double? height,
    BoxConstraints? constraints,
    double cornerRadius = 5.0,
    required Color themeColor,
    required Color themeOppositeColor,
    double normalBorderWidth = 0.0,
    double selectedBorderWidth = 0.0,
    required Widget Function(bool bSelected) childBuider,
    bool enable = true,
    bool selected = false,
    Color? normalBackgroundHighlightColor,
    Color? selectedBackgroundHighlightColor,
    double? highlightOpacity, // 没有设置高亮 highlightColor 的时候，取原色的多少透明度值
    required VoidCallback onPressed,
  }) : super(
          key: key,
          width: width,
          height: height,
          constraints: constraints,
          childBuider: childBuider,
          enable: enable,
          selected: selected,
          onPressed: onPressed,
          cornerRadius: cornerRadius,
          normalBGColor: themeColor,
          normalTextColor: themeOppositeColor,
          normalBorderWidth: normalBorderWidth,
          normalBorderColor: themeColor,
          normalBackgroundHighlightColor: normalBackgroundHighlightColor,
          selectedBGColor: themeOppositeColor,
          selectedTextColor: themeColor,
          selectedBorderWidth: selectedBorderWidth,
          selectedBorderColor: themeColor,
          selectedBackgroundHighlightColor: selectedBackgroundHighlightColor,
          highlightOpacity: highlightOpacity,
        );
}

/// 文本按钮(已配置 Normal 和 Selected 风格的主题色按钮)
class CJStateTextButton extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget Function(bool bSelected) childBuider;
  final MainAxisAlignment childMainAxisAlignment;
  final VoidCallback? onPressed;
  final bool? enable;
  final double disableOpacity;
  final bool selected;
  final double cornerRadius;
  final Color normalBGColor;
  final Color normalTextColor;
  final Color? normalBorderColor;
  final double? normalBorderWidth;
  final Color? normalBackgroundHighlightColor;
  final Color? selectedBGColor;
  final Color? selectedTextColor;
  final Color? selectedBorderColor;
  final double? selectedBorderWidth;
  final Color? selectedBackgroundHighlightColor;
  final double? highlightOpacity; // 没有设置高亮 highlightColor 的时候，取原色的多少透明度值

  const CJStateTextButton({
    Key? key,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.padding,
    required this.childBuider,
    this.childMainAxisAlignment = MainAxisAlignment.center,
    this.onPressed, // null时候会自动透传事件
    this.enable = true,
    this.disableOpacity = 0.5, // disable 时候，颜色的透明度
    this.selected = false,
    this.cornerRadius = 5.0,
    required this.normalBGColor,
    required this.normalTextColor,
    this.normalBorderColor,
    this.normalBorderWidth = 0.0,
    this.normalBackgroundHighlightColor,
    this.selectedBGColor,
    this.selectedTextColor,
    this.selectedBorderColor,
    this.selectedBorderWidth = 0.0, // 按钮选中时候的边框宽度
    this.selectedBackgroundHighlightColor,
    this.highlightOpacity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CJStateButton(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      // ignore: sort_child_properties_last
      child: childBuider(selected),
      childMainAxisAlignment: childMainAxisAlignment,
      onPressed: onPressed,
      enable: enable,
      disableOpacity: disableOpacity,
      selected: selected,
      cornerRadius: cornerRadius,
      normalBGColor: normalBGColor,
      normalTextColor: normalTextColor,
      normalBorderColor: normalBorderColor,
      normalBorderWidth: normalBorderWidth ?? 0,
      normalBackgroundHighlightColor: normalBackgroundHighlightColor,
      selectedBGColor: selectedBGColor,
      selectedTextColor: selectedTextColor,
      selectedBorderColor: selectedBorderColor,
      selectedBorderWidth: selectedBorderWidth ?? 0,
      selectedBackgroundHighlightColor: selectedBackgroundHighlightColor,
      highlightOpacity: highlightOpacity,
    );
  }
}
