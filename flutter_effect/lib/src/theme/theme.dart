import 'package:flutter/material.dart';

// bold 的文本样式
class BoldTextStyle extends TextStyle {
  final double fontSize;
  final Color color;

  BoldTextStyle({
    @required this.fontSize,
    this.color,
  })  : assert(fontSize != null),
        assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: color,
        );
}

// medium 的文本样式
class MediumTextStyle extends TextStyle {
  final double fontSize;
  final Color color;

  MediumTextStyle({
    @required this.fontSize,
    this.color,
  })  : assert(fontSize != null),
        assert(color != null),
        super(
          fontFamily: 'PingFang SC',
          fontSize: fontSize,
          fontWeight: FontWeight.w500,
          color: color,
        );
}
