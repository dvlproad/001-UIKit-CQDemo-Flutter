// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
// import 'dart:ui';

final Color appThemeColor = Color(0xFFE67D4F);

final Map theme = {
  "theme": {
    "themeColor": appThemeColor, // 金黄色golden
    "themeOppositeColor": Colors.white,
  },
  "pink": {
    "themeColor": Color(0xFFFFC5BF), // 粉红色pink
    "themeOppositeColor": Colors.black,
  },
  "purple": {
    "themeColor": Colors.purple, // 紫色 purple
    "themeOppositeColor": Colors.white,
  },
  "blue": {
    "themeColor": Colors.blue, // 蓝色 blue
    "themeOppositeColor": Colors.white,
  },
  "grey": {
    "themeColor": Color(0xff8b8b8b),
    "themeOppositeColor": Colors.white,
  },
  "black": {
    "themeColor": Colors.black,
    "themeOppositeColor": Colors.white,
  },
};

// 颜色分类
enum ThemeBGType {
  theme,
  pink,
  purple,
  blue,
  grey, //灰色背景白色字
  black,
}

Color themeColor(ThemeBGType? type) {
  type = type ?? ThemeBGType.theme;
  return theme[type.toString().split('.').last]['themeColor'];
}

Color themeOppositeColor(ThemeBGType? type) {
  type = type ?? ThemeBGType.theme;
  return theme[type.toString().split('.').last]['themeOppositeColor'];
}

// 状态颜色分类
enum ThemeStateBGType {
  theme_white,
  theme_gray,
  orange_orange,
  white_black,
  black_white,
  transparent_whiteText, //透明背景，白色字的按钮
  gary_white,
}

final Map stateTheme = {
  "theme_white": {
    "themeColor": appThemeColor, // 金黄色golden
    "themeOppositeColor": Colors.white,
  },
  "theme_gray": {
    "themeColor": Color(0xFFB8B8B8),
    "textColor": Color(0xFF8b8b8b),
    "themeOppositeColor": Colors.white,
  },
  "orange_orange": {
    "themeColor": Color(0xFFF7956A),
    "textColor": Color(0xFFE67D4F),
    "themeOppositeColor": Colors.white,
  },
  "white_black": {
    "themeColor": Colors.white, // 白色 white,
    "themeOppositeColor": Color(0xFF222222),
  },
  "black_white": {
    "themeColor": Color(0xFF222222), // 黑色 black,
    "themeOppositeColor": Colors.white,
  },
  "transparent_whiteText": {
    "themeColor": Colors.transparent, // 透明色 transparent,
    "themeOppositeColor": Color(0xFF222222),
  },
  "gary_white": {
    "themeColor": Color(0xFF8b8b8b), // 白色 white,
    "themeOppositeColor": Colors.white,
  },
};

Color stateThemeColor(ThemeStateBGType? type) {
  type = type ?? ThemeStateBGType.theme_white;
  return stateTheme[type.toString().split('.').last]['themeColor'];
}

Color stateTextColor(ThemeStateBGType? type) {
  type = type ?? ThemeStateBGType.theme_white;
  return stateTheme[type.toString().split('.').last]['textColor'] ??
      stateThemeColor(type);
}

Color stateThemeOppositeColor(ThemeStateBGType? type) {
  type = type ?? ThemeStateBGType.theme_white;
  return stateTheme[type.toString().split('.').last]['themeOppositeColor'];
}

// 状态颜色分类
enum RichThemeStateBGType {
  grey_theme,
  grey_theme_mine_tag_home, //个人主页标签
  grey_theme_mine_tag_dialog, //个人主页标签-弹出的dialog
}

final Map richStateTheme = {
  "grey_theme": {
    "normalBGColor": Color(0xFFF0F0F0),
    "normalTextColor": Color(0xFF404040),
    "normalBorderWidth": 0.0,
    "normalBorderColor": Color(0xFFF0F0F0),
    // "normalBackgroundHighlightColor": normalBackgroundHighlightColor,

    "selectedBGColor": Color(0xFFFFF0EA),
    "selectedTextColor": appThemeColor, // 金黄色golden,
    "selectedBorderWidth": 1.0,
    "selectedBorderColor": appThemeColor, // 金黄色golden,
    // "selectedBackgroundHighlightColor": selectedBackgroundHighlightColor,
  },
  "grey_theme_mine_tag_home": {
    "normalBGColor": Color(0xff494B4E),
    "normalTextColor": Color(0xFFB8B8B8),
    "normalBorderWidth": 0.0,
    "normalBorderColor": Color(0xFFB8B8B8),
    // "normalBackgroundHighlightColor": normalBackgroundHighlightColor,

    "selectedBGColor": Colors.white,
    "selectedTextColor": appThemeColor, // 金黄色golden,
    "selectedBorderWidth": 1.0,
    "selectedBorderColor": appThemeColor, // 金黄色golden,
    // "selectedBackgroundHighlightColor": selectedBackgroundHighlightColor,
  },
  "grey_theme_mine_tag_dialog": {
    "normalBGColor": Colors.white,
    "normalTextColor": Color(0xFF333333),
    "normalBorderWidth": 0.0,
    "normalBorderColor": Color(0xFFB8B8B8),
    // "normalBackgroundHighlightColor": normalBackgroundHighlightColor,

    "selectedBGColor": Colors.white,
    "selectedTextColor": appThemeColor, // 金黄色golden,
    "selectedBorderWidth": 1.0,
    "selectedBorderColor": appThemeColor, // 金黄色golden,
    // "selectedBackgroundHighlightColor": selectedBackgroundHighlightColor,
  },
};

Color richStateTheme_normalBGColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['normalBGColor'];
}

Color richStateTheme_normalTextColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['normalTextColor'];
}

double richStateTheme_normalBorderWidth(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['normalBorderWidth'];
}

Color richStateTheme_normalBorderColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['normalBorderColor'];
}

Color? richStateTheme_normalBackgroundHighlightColor(
    RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['normalBackgroundHighlightColor'];
}

Color richStateTheme_selectedBGColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['selectedBGColor'];
}

Color richStateTheme_selectedTextColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['selectedTextColor'];
}

double richStateTheme_selectedBorderWidth(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['selectedBorderWidth'];
}

Color richStateTheme_selectedBorderColor(RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['selectedBorderColor'];
}

Color? richStateTheme_selectedBackgroundHighlightColor(
    RichThemeStateBGType type) {
  Map<String, dynamic> richStateThemeMap =
      richStateTheme[type.toString().split('.').last];
  return richStateThemeMap['selectedBackgroundHighlightColor'];
}

/*
在第六章进阶[Flutter控件的封装](../6进阶/Flutter控件的封装)一文中，我们已经知道**使用`继承父类式封装`这种方式，不管在封装时候，还是在使用时候，写的代码都是最简洁的。而且后期如果要直接使用系统样式，也只需要改回类名，其他结构和属性都不用动即可**。

所以，**即使是你所定义的类只有一个入参，也一定要遵守使用`继承父类式封装`的设计规范。**
*/
// 按钮上的文本样式(按钮上的文字颜色，已通过其他属性设置；不需要 TextStyle 中设置;其他类的文本需要在 TextStyle 设置文本颜色，所以此类最多只提供给按钮使用)
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

// Regular 的文本样式
class ButtonRegularTextStyle extends TextStyle {
  final double fontSize;
  // final Color color;
  final double? height;

  ButtonRegularTextStyle({
    required this.fontSize,
    // this.color,
    this.height,
  }) : super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          // color: color,
          height: height,
        );
}

// bold 的文本样式
class ButtonBoldTextStyle extends TextStyle {
  final double fontSize;
  // final Color color;

  ButtonBoldTextStyle({
    required this.fontSize,
    // this.color,
  }) : super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          // color: color,
        );
}

// medium 的文本样式
class ButtonMediumTextStyle extends TextStyle {
  final double fontSize;
  // final Color color;

  ButtonMediumTextStyle({
    required this.fontSize,
    // this.color,
  }) : super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          // color: color,
        );
}
