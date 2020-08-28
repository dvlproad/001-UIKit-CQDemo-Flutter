import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 可定制背景色、圆角、弧度的 Widget
class CJBGBorderWidget extends StatelessWidget {
  final double height; // 文本框的高度
  final Color backgroundColor; // 文本框的背景颜色
  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color borderColor; // 边的颜色

  final Widget child; // 控件视图
  final VoidCallback onPressed; // 控件视图的点击事件

  CJBGBorderWidget({
    Key key,
    this.height = 44,
    this.backgroundColor,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
    @required this.child,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onPressed,
      child: _containerWidget(),
    );
  }

  Widget _containerWidget() {
    double height = this.height ?? 0;
    Color backgroundColor =
        this.backgroundColor != null ? this.backgroundColor : Colors.white;
    double cornerRadius = this.cornerRadius != null ? this.cornerRadius : 0;
    Color borderColor =
        this.borderColor != null ? this.borderColor : Color(0xffd2d2d2);
    double borderWidth = this.borderWidth != null ? this.borderWidth : 0;
    return Container(
      height: height,
      // color: backgroundColor, // color 和 decoration 不能同时存在，至少一个要为空
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
