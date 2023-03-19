import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemUiOverlayStyle;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
export 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

import '../../flutter_effect_adapt.dart';

// 一个可以快速设置 导航栏标题 和 导航栏返回按钮 的导航栏视图
class QuickAppBar extends CommonAppBar {
  QuickAppBar(
    BuildContext context, {
    Key? key,
    Color? backgroundColor, // 导航栏背景色

    SystemUiOverlayStyle? systemOverlayStyle,
    dynamic title, // 中间导航栏标题文本或文本视图
    final EdgeInsetsGeometry? titleMargin,
    AppBarTextColorType? textColorType, // 左侧(返回)按钮视图的类型
    bool automaticallyImplyLeading = true, // 是否显示左侧(返回)按钮视图(默认true显示)

    QuickToolBarImageType?
        leadingImageType, // 返回按钮的样式(未设置的话，会自动根据标题颜色和导航栏背景色设置)
    String? leadingText, // 左侧返回按钮不使用图片时候的文本(默认null时，使用图片)
    double? leadingTextWidth, // 左侧返回按钮为文字时候所占宽度(未设置会取内容所占的最小宽度，其他为图片时候宽度固定)
    void Function()? customOnPressedBack,
    List<Widget>? actions, // 右侧操作按钮视图
    double actionsPositionedRight = 10, // 右侧操作按钮视图离边缘的距离(如保存按钮时有距离)
  })  : assert(title == null || (title is String) || (title is Widget)),
        super(
          key: key,
          backgroundColor: backgroundColor,
          systemOverlayStyle: systemOverlayStyle,
          title: (title is String)
              ? ToolBarTitleWidget(
                  text: title,
                  textColorType: textColorType,
                )
              : title,
          titleMargin: titleMargin,
          leading: leadingText != null
              ? ToolBarTextActionWidget(
                  width: leadingTextWidth,
                  color: Colors.transparent,
                  text: leadingText,
                  textColor: textColorType == AppBarTextColorType.white
                      ? Colors.white
                      : Color(0xFF222222),
                  onPressed: () {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // 默认返回时候,关闭键盘
                    if (customOnPressedBack == null) {
                      Navigator.pop(context);
                    } else {
                      customOnPressedBack();
                    }
                  },
                )
              : QuickToolBarImageActionWidget(
                  imageType: leadingImageType != null
                      ? leadingImageType
                      : textColorType == AppBarTextColorType.white
                          ? (backgroundColor == Colors.transparent
                              ? QuickToolBarImageType.white_bgClear
                              : QuickToolBarImageType.white)
                          : (backgroundColor == Colors.transparent
                              ? QuickToolBarImageType.black_bgClear
                              : QuickToolBarImageType.black),
                  onPressed: () {
                    FocusScope.of(context)
                        .requestFocus(FocusNode()); // 默认返回时候,关闭键盘
                    if (customOnPressedBack == null) {
                      Navigator.pop(context);
                    } else {
                      customOnPressedBack();
                    }
                  },
                ),
          leadingPositionedLeft: leadingText != null ? 10 : 0,
          automaticallyImplyLeading: automaticallyImplyLeading,
          actions: actions,
          actionsPositionedRight: actionsPositionedRight,
        );
}

// 一个可 任意设置 的导航栏视图

// 使用自己的布局方式
class CommonAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color? backgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;

  final Widget? title; // 中间标题视图
  final EdgeInsetsGeometry? titleMargin;

  final Widget? leading; // 左侧(返回)按钮视图
  final double? leadingPositionedLeft;
  final bool automaticallyImplyLeading; // 是否显示左侧(返回)按钮视图(默认true显示)
  // final ImageProvider navbackImage;
  // final String navbackTitle;
  // // navbackImage: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // // navbackImage: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  // final VoidCallback
  //     onTapNavback; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

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
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
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