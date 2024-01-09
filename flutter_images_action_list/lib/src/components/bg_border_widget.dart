import 'package:flutter/material.dart';

/// 可定制背景颜色、圆角、弧度的 Widget
class CJBGBorderWidget extends StatelessWidget {
  final double height; // 文本框的高度
  final Color? backgroundColor; // 文本框的背景颜色
  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color? borderColor; // 边的颜色

  final Widget child; // 控件视图
  final VoidCallback? onPressed; // 控件视图的点击事件

  CJBGBorderWidget({
    Key? key,
    this.height = 44,
    this.backgroundColor,
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
    double height = this.height;
    Color backgroundColor = this.backgroundColor ?? Colors.white;
    double cornerRadius = this.cornerRadius;
    double borderWidth = this.borderWidth;
    Color borderColor = this.borderColor ?? Colors.transparent;
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

/// 可定制背景图片、圆角、弧度的 Widget
class CJBGImageWidget extends StatelessWidget {
  final double height; // 文本框的高度
  final ImageProvider backgroundImage; // 背景图
  // image: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // image: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),

  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color? borderColor; // 边的颜色

  final Widget child; // 控件视图
  final void Function()? onTap; // 控件视图的点击事件
  final void Function()? onDoubleTap;
  final void Function()? onLongPress;

  CJBGImageWidget({
    Key? key,
    this.height = 44,
    required this.backgroundImage,
    this.cornerRadius = 0,
    this.borderWidth = 0,
    this.borderColor,
    required this.child,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: _containerWidget(),
    );
  }

  Widget _containerWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
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
