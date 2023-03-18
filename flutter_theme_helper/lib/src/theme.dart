import 'package:flutter/material.dart';
import 'dart:math';
// import 'dart:ui';
// 按钮主题使用 buttontheme

/*
在第六章进阶[Flutter控件的封装](../6进阶/Flutter控件的封装)一文中，我们已经知道**使用`继承父类式封装`这种方式，不管在封装时候，还是在使用时候，写的代码都是最简洁的。而且后期如果要直接使用系统样式，也只需要改回类名，其他结构和属性都不用动即可**。

所以，**即使是你所定义的类只有一个入参，也一定要遵守使用`继承父类式封装`的设计规范。**
*/

class ColorHelper {
  //随机颜色
  static Color randomColor() {
    return Color.fromARGB(255, Random.secure().nextInt(255),
        Random.secure().nextInt(255), Random.secure().nextInt(255));
  }
}

// Regular 的文本样式
class RegularTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;

  RegularTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: FontWeight.w400,
          color: color,
          height: height,
          // backgroundColor: Colors.red,
        );
}

// bold 的文本样式
class BoldTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final Color? decorationColor;
  final TextBaseline? textBaseline;

  BoldTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.decorationColor,
    this.textBaseline,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: FontWeight.bold,
          color: color,
          height: height,
          decorationColor: decorationColor,
          textBaseline: textBaseline,
        );
}

// medium 的文本样式
class MediumTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final Color? decorationColor;
  final TextBaseline? textBaseline;

  MediumTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.decorationColor,
    this.textBaseline,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: FontWeight.w500,
          color: color,
          height: height,
          decorationColor: decorationColor,
          textBaseline: textBaseline,
        );
}

// DDINPRO字体
class DDINPROBoldTextStyle extends TextStyle {
  final double fontSize;
  final Color? color;
  final double? height;
  final TextOverflow? overflow;
  final TextDecoration? decoration;
  final double? letterSpacing;
  final Color? decorationColor;
  final TextBaseline? textBaseline;

  DDINPROBoldTextStyle({
    required this.fontSize,
    this.color,
    this.height,
    this.overflow,
    this.decoration,
    this.letterSpacing,
    this.decorationColor,
    this.textBaseline,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'DDINPRO',
          overflow: overflow,
          decoration: decoration,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          fontWeight: FontWeight.w700,
          color: color,
          height: height,
          decorationColor: decorationColor,
          textBaseline: textBaseline,
        );
}
