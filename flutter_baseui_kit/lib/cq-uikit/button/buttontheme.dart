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

// bold 的文本样式
class ButtonBoldTextStyle extends TextStyle {
  final double fontSize;
  // final Color color;

  ButtonBoldTextStyle({
    @required this.fontSize,
    // this.color,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
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
    @required this.fontSize,
    // this.color,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          // color: color,
        );
}
