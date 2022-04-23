import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
export 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../../flutter_effect_adapt.dart';

// 一个可以快速设置 导航栏标题 和 导航栏返回按钮 的导航栏视图
class QuickAppBar extends CommonAppBar {
  QuickAppBar(
    BuildContext context, {
    Key key,
    Color backgroundColor, // 导航栏背景色
    String title, // 中间导航栏标题文本
    AppBarTextColorType textColorType, // 左侧(返回)按钮视图的类型
    bool automaticallyImplyLeading, // 是否显示左侧(返回)按钮视图(默认true显示)
    String leadingText, // 左侧返回按钮不使用图片时候的文本(默认null时，使用图片)
    double leadingTextWidth, // 左侧返回按钮为文字时候所占宽度(未设置会取内容所占的最小宽度，其他为图片时候宽度固定)
    void Function() customOnPressedBack,
    List<Widget> actions, // 右侧操作按钮视图
  }) : super(
          key: key,
          backgroundColor: backgroundColor,
          title: ToolBarTitleWidget(
            text: title,
            textColorType: textColorType,
          ),
          leading: ToolBarBackWidget(
            width: leadingTextWidth,
            text: leadingText,
            textColorType: textColorType,
            appbarBackgroundColor: backgroundColor,
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode()); // 默认返回时候,关闭键盘
              if (customOnPressedBack == null) {
                Navigator.pop(context);
              } else {
                customOnPressedBack();
              }
            },
          ),
          automaticallyImplyLeading: automaticallyImplyLeading,
          actions: actions,
        );
}

// 一个可 任意设置 的导航栏视图
class CommonAppBar extends AppBar {
  final Color backgroundColor;

  final Widget title; // 中间标题视图

  final Widget leading; // 左侧(返回)按钮视图
  final bool automaticallyImplyLeading; // 是否显示左侧(返回)按钮视图(默认true显示)
  // final ImageProvider navbackImage;
  // final String navbackTitle;
  // // navbackImage: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // // navbackImage: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  // final VoidCallback
  //     onTapNavback; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

  final List<Widget> actions; // 右侧操作按钮视图

  CommonAppBar({
    Key key,
    this.backgroundColor,
    this.title, // 中间标题视图
    // ToolBarTitleWidget(text: title)

    this.leading, // 左侧(返回)按钮视图
    // ToolBarBackWidget(
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    // )

    this.automaticallyImplyLeading = true, // 是否显示左侧(返回)按钮视图
    this.actions,
  }) : super(key: key);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return buildAppBarWidget(context);
    // return appBar();
  }

  // 使用自己的布局方式
  Widget buildAppBarWidget(BuildContext context) {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double stautsBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: widget.backgroundColor ?? Colors.white, // 导航栏+状态栏背景颜色
      child: Column(
        children: [
          Container(height: stautsBarHeight, color: Colors.transparent),
          CommonToolBar(
            backgroundColor: Colors.transparent,
            leading: widget.leading,
            automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
            title: widget.title,
            actions: widget.actions,
          ),
        ],
      ),
    );
  }

  // 使用系统的布局方式
  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: widget.backgroundColor ?? Colors.white, // 导航栏背景颜色
      elevation: 0, //隐藏底部阴影分割线
      centerTitle: true, // 标题统一居中(ios下默认居中对对齐,安卓下默认左对齐)
      // titleSpacing: 88, // 距离屏幕两边的距离默认16，当我们设置搜索的时候感觉两边距离太大太小可以调

      leading: Container(
        padding: EdgeInsets.only(left: 10),
        // color: Colors.green,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [widget.leading],
        ),
      ),
      automaticallyImplyLeading: widget.automaticallyImplyLeading ?? true,
      title: widget.title,
      actions: [
        Container(
          padding: EdgeInsets.only(right: 10),
          // color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.actions,
          ),
        ),
      ],
    );
  }
}
