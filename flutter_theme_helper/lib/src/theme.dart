/*
 * @Author: dvlproad
 * @Date: 2022-04-15 19:20:38
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-15 21:57:39
 * @Description: 主题
 */
import 'package:flutter/material.dart';

// import 'dart:ui';
// 按钮主题使用 buttontheme

/*
在第六章进阶[Flutter控件的封装](../6进阶/Flutter控件的封装)一文中，我们已经知道**使用`继承父类式封装`这种方式，不管在封装时候，还是在使用时候，写的代码都是最简洁的。而且后期如果要直接使用系统样式，也只需要改回类名，其他结构和属性都不用动即可**。

所以，**即使是你所定义的类只有一个入参，也一定要遵守使用`继承父类式封装`的设计规范。**
*/

// Regular 的文本样式
class RegularTextStyle extends TextStyle {
  final double fontSize;
  final Color color;
  final double height;

  RegularTextStyle({
    @required this.fontSize,
    this.color,
    this.height,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w400,
          color: color,
          height: height,
          // backgroundColor: Colors.red,
        );
}

// bold 的文本样式
class BoldTextStyle extends TextStyle {
  final double fontSize;
  final Color color;
  final double height;

  BoldTextStyle({
    @required this.fontSize,
    this.color,
    this.height,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
          height: height,
        );
}

// medium 的文本样式
class MediumTextStyle extends TextStyle {
  final double fontSize;
  final Color color;
  final double height;

  MediumTextStyle({
    @required this.fontSize,
    this.color,
    this.height,
  })  : assert(fontSize != null),
        // assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color,
          height: height,
        );
}
