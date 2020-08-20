import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 可定制背景色、圆角、弧度的 Widget
class CJBGBorderWidget extends StatelessWidget {
  final Widget child;

  final double height; // 文本框的高度
  final Color backgroundColor; // 文本框的背景颜色
  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color borderColor; // 边的颜色

  CJBGBorderWidget({
    Key key,
    @required this.child,
    this.height = 44,
    this.backgroundColor,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = this.height ?? 0;
    Color backgroundColor =
        this.backgroundColor != null ? this.backgroundColor : Colors.white;
    double cornerRadius = this.cornerRadius != null ? this.cornerRadius : 0;
    Color borderColor =
        this.borderColor != null ? this.borderColor : Color(0xffd2d2d2);
    double borderWidth = this.borderWidth != null ? this.borderWidth : 0;
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
        border: Border.all(
          color: borderColor,
          width: borderWidth,
          style: BorderStyle.solid,
        ),
      ),
      child: this.child,
    );
  }
}
