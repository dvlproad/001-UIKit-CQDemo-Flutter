import 'package:flutter/material.dart';

/// 可定制背景颜色、圆角、弧度的 Widget
class CJBGBorderWidget extends StatelessWidget {
  final double? width;
  final double? height; // 文本框的高度
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor; // 文本框的背景颜色
  final double? cornerRadius; // 边的圆角
  final double? borderWidth; // 边宽
  final Color? borderColor; // 边的颜色

  final Widget child; // 控件视图
  final VoidCallback? onPressed; // 控件视图的点击事件
  final HitTestBehavior? behavior;

  CJBGBorderWidget({
    Key? key,
    this.width,
    this.height = 44,
    this.constraints,
    this.margin,
    this.padding,
    this.backgroundColor,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
    required this.child,
    this.onPressed,
    this.behavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: behavior == HitTestBehavior.translucent ? null : this.onPressed,
      behavior: behavior,
      child: _containerWidget(),
    );
  }

  Widget _containerWidget() {
    Color backgroundColor =
        this.backgroundColor != null ? this.backgroundColor! : Colors.white;
    double cornerRadius = this.cornerRadius != null ? this.cornerRadius! : 0;
    double borderWidth = this.borderWidth != null ? this.borderWidth! : 0;
    Color borderColor =
        this.borderColor != null ? this.borderColor! : Colors.transparent;
    return Container(
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      padding: padding,
      // color: backgroundColor, // color 和 decoration 不能同时存在，至少一个要为空
      decoration: BoxDecoration(
        color: backgroundColor,
        /* //TODO:
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            const Color(0xFFAB92FD).withOpacity(0.7),
            const Color(0xFFFD84AE).withOpacity(0.7),
            const Color(0xFFF6800B).withOpacity(0.7),
          ],
        ),
        */
        borderRadius: BorderRadius.circular(cornerRadius),
        border: borderWidth == 0
            ? null
            : Border.all(
                color: borderColor,
                width: borderWidth,
                style: BorderStyle.solid,
              ),
      ),
      child: this.child,
    );
  }
}

/// 可定制背景图片、圆角、弧度的 Widget
class CJBGImageWidget extends StatelessWidget {
  final double? height; // 文本框的高度
  final ImageProvider backgroundImage; // 背景图
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),

  final double? cornerRadius; // 边的圆角
  final double? borderWidth; // 边宽
  final Color? borderColor; // 边的颜色

  final Widget child; // 控件视图
  final VoidCallback? onPressed; // 控件视图的点击事件

  CJBGImageWidget({
    Key? key,
    this.height = 44,
    required this.backgroundImage,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
    required this.child,
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius ?? 0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        // child: Container(
        //   alignment: Alignment.center,
        //   decoration: ShapeDecoration(
        //     shape: RoundedRectangleBorder(),
        //     image: DecorationImage(
        //       image: this.backgroundImage,
        //       fit: BoxFit.cover,
        //     ),
        //   ),
        //   child: child,
        // ),
        child: Container(
          // color: Colors.red,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: this.backgroundImage,
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints(
            minWidth: double.infinity,
            minHeight: double.infinity,
          ),
          child: child,
        ),
      ),
    );
  }
}
