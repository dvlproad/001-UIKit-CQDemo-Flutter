/*
 * @Author: dvlproad
 * @Date: 2024-04-26 17:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-27 20:45:30
 * @Description: 
 */
// toolbar 上 左侧返回视图 + 中间标题视图 + 右侧按钮视图
import 'package:flutter/material.dart';

// 一个可 任意设置 的导航栏视图
class CommonToolBar extends AppBar {
  final double height;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  final Widget? title; // 中间标题视图
  final EdgeInsetsGeometry? titleMargin;

  final Widget? leading; // 左侧(返回)按钮视图
  final double? leadingPositionedLeft; // 左侧(返回)按钮视图离边缘的距离(如取消按钮时有距离)
  final bool automaticallyImplyLeading; // 是否显示左侧(返回)按钮视图(默认true显示)

  final List<Widget>? actions; // 右侧操作按钮视图
  final double? actionsPositionedRight; // 右侧操作按钮视图离边缘的距离(如保存按钮时有距离)

  CommonToolBar({
    Key? key,
    this.height = 44,
    this.padding,
    this.backgroundColor,
    this.title, // 中间标题视图
    this.titleMargin,
    this.leading, // 左侧(返回)按钮视图
    this.leadingPositionedLeft,
    this.automaticallyImplyLeading = true, // 是否显示左侧(返回)按钮视图

    this.actions,
    this.actionsPositionedRight,
  }) : super(key: key);

  @override
  _CommonToolBarState createState() => _CommonToolBarState();
}

class _CommonToolBarState extends State<CommonToolBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    // 添加标题
    if (widget.title != null) {
      Widget stackTitleWidget = Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.transparent,
              width: double.infinity,
              height: double.infinity,
              margin: widget.titleMargin,
              child: widget.title,
            ),
          ),
        ],
      );
      widgets.add(stackTitleWidget);
    }

    // 根据情况，添加返回按钮
    bool _automaticallyImplyLeading = widget.automaticallyImplyLeading;
    if (_automaticallyImplyLeading && widget.leading != null) {
      Widget leftNavBarButton = Positioned(
        left: widget.leadingPositionedLeft ?? 0,
        child: widget.leading!,
      );
      widgets.add(leftNavBarButton);
    }

    if (widget.actions != null && widget.actions!.isNotEmpty) {
      Widget rightNavBarButton = Positioned(
        right: widget.actionsPositionedRight ?? 0,
        child: Container(
          padding: EdgeInsets.only(right: 0),
          // color: Colors.green,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.actions!,
          ),
        ),
      );
      widgets.add(rightNavBarButton);
    }

    return Container(
      color: widget.backgroundColor ?? Colors.transparent,
      width: double.infinity,
      height: widget.height,
      padding: widget.padding,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: widgets,
      ),
    );
  }
}
