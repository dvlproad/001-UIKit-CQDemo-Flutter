/*
 * @Author: dvlproad
 * @Date: 2024-04-26 22:51:45
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-27 20:08:05
 * @Description: 
 */
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;

import '../toolbar/base_toolbar.dart';

// 一个可 任意设置 的导航栏视图

// 使用自己的布局方式
class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  final Widget? title; // 中间标题视图
  final EdgeInsetsGeometry? titleMargin;

  final Widget? leading; // 左侧(返回)按钮视图
  final double? leadingPositionedLeft;
  final bool? automaticallyImplyLeading; // 是否显示左侧(返回)按钮视图(默认true显示)

  final List<Widget>? actions; // 右侧操作按钮视图
  final double? actionsPositionedRight;

  CommonAppBar({
    Key? key,
    this.backgroundColor,
    this.systemOverlayStyle,
    this.title, // 中间标题视图
    this.titleMargin,
    this.leading, // 左侧(返回)按钮视图
    this.leadingPositionedLeft,
    this.automaticallyImplyLeading = true, // 是否显示左侧(返回)按钮视图
    this.actions,
    this.actionsPositionedRight, // 右侧操作按钮视图离边缘的距离(如保存按钮时有距离)
  }) : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();

  @override
  Size get preferredSize =>
      Size(MediaQueryData.fromWindow(window).size.width, 44); // 高度44
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: widget.systemOverlayStyle ?? SystemUiOverlayStyle.dark,
      child: buildAppBarWidget(context),
    );
  }

  Widget buildAppBarWidget(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double stautsBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: widget.backgroundColor ?? Color(0xFFF7F7F7), // 导航栏+状态栏背景颜色
      child: Column(
        children: [
          Container(height: stautsBarHeight, color: Colors.transparent),
          CommonToolBar(
            backgroundColor: Colors.transparent,
            leading: widget.leading,
            leadingPositionedLeft: widget.leadingPositionedLeft,
            automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
            title: widget.title,
            titleMargin: widget.titleMargin,
            actions: widget.actions,
            actionsPositionedRight: widget.actionsPositionedRight,
          ),
        ],
      ),
    );
  }
}
/*
// 使用系统的布局方式
class CommonAppBar extends AppBar {
  CommonAppBar({
    Key key,
    Color backgroundColor,
    SystemUiOverlayStyle systemOverlayStyle,
    Widget title,
    Widget leading,
    double leadingPositionedLeft, // 左侧(返回)按钮视图离边缘的距离(如取消按钮时有距离)
    bool automaticallyImplyLeading,
    List<Widget> actions,
    double actionsPositionedRight, // 右侧操作按钮视图离边缘的距离(如保存按钮时有距离)
  }) : super(
          key: key,
          backgroundColor: backgroundColor ?? Color(0xFFF7F7F7), // 导航栏背景颜色
          elevation: 0, //隐藏底部阴影分割线
          centerTitle: true, // 标题统一居中(ios下默认居中对对齐,安卓下默认左对齐)
          // titleSpacing: 88, // 距离屏幕两边的距离默认16，当我们设置搜索的时候感觉两边距离太大太小可以调

          leading: Container(
            padding: EdgeInsets.only(left: leadingPositionedLeft ?? 0),
            // color: Colors.green,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [leading],
            ),
          ),
          automaticallyImplyLeading: automaticallyImplyLeading ?? true,
          title: title,
          actions: [
            Container(
              padding: EdgeInsets.only(right: actionsPositionedRight ?? 10),
              // color: Colors.green,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: actions ?? [],
              ),
            ),
          ],
          systemOverlayStyle: systemOverlayStyle ?? SystemUiOverlayStyle.dark,
        );
}
*/
