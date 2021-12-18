import 'package:flutter/material.dart';
// import 'dart:ui';

final Map theme = {
  "pink": {
    "themeColor": Color(0xFFCD3F49), // 粉红色 pink
    "themeOppositeColor": Colors.white,
  },
  "purple": {
    "themeColor": Colors.purple, // 紫色 purple
    "themeOppositeColor": Colors.white,
  },
  "blue": {
    "themeColor": Colors.blue, // 蓝色 blue
    "themeOppositeColor": Colors.white,
  },
  "black": {
    "themeColor": Color(0xFF222222), // 黑色 black,
    "themeOppositeColor": Colors.white,
  },
};

// 颜色分类
enum ThemeBGType {
  pink,
  purple,
  blue,
  black,
}

Color themeColor(ThemeBGType type) {
  type = type ?? ThemeBGType.pink;
  return theme[type.toString().split('.').last]['themeColor'];
}

Color themeOppositeColor(ThemeBGType type) {
  type = type ?? ThemeBGType.pink;
  return theme[type.toString().split('.').last]['themeOppositeColor'];
}

// 按钮上的文本样式(按钮上的文字颜色，已通过其他属性设置；不需要 TextStyle 中设置;其他类的文本需要在 TextStyle 设置文本颜色，所以不用此类)
class ButtonThemeUtil {
  // 类命名注意：系统有 ButtonTheme 类，别取重名，否则外部取不到

  static TextStyle PingFang_FontSize_Bold(double fontSize) {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle PingFang_FontSize_Medium(double fontSize) {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontSize: fontSize,
      fontWeight: FontWeight.w500,
    );
  }
}
