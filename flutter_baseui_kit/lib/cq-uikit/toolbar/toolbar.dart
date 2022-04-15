// toolbar 上 左侧返回视图 + 中间标题视图 + 右侧按钮视图
import 'dart:ui';
import 'package:flutter/material.dart';

import './toolbar_title.dart';
export './toolbar_title.dart';
import './toolbar_button_base.dart';
import './toolbar_button.dart';
export './toolbar_button.dart';
import './toolbar_enum.dart';
export './toolbar_enum.dart';
import '../../flutter_baseui_kit_adapt.dart';

class QuickToolBar extends CommonToolBar {
  QuickToolBar(
    BuildContext context, {
    Key key,
    Color backgroundColor, // 导航栏背景色
    String title, // 中间导航栏标题文本
    AppBarTextColorType textColorType, // 左侧(返回)按钮视图的类型
    bool automaticallyImplyLeading, // 是否显示左侧(返回)按钮视图(默认true显示)
    String leadingText, // 左侧返回按钮不使用图片时候的文本(默认null时，使用图片)
    void Function() customOnPressedBack,
    List<Widget> actions, // 右侧操作按钮视图
  }) : super(
          key: key,
          backgroundColor: backgroundColor,
          title: ToolBarTitleWidget(text: title, textColorType: textColorType),
          automaticallyImplyLeading: false,
          actions: [
            ToolBarActionWidget(
              image: AssetImage(
                'assets/appbar/icon_close.png',
                package: 'flutter_effect',
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
}

// 一个可 任意设置 的导航栏视图
class CommonToolBar extends AppBar {
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

  CommonToolBar({
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
  _CommonToolBarState createState() => _CommonToolBarState();
}

class _CommonToolBarState extends State<CommonToolBar> {
  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = [];

    // 添加标题
    Widget stackTitleWidget = Row(
      children: [
        Expanded(
          child: Container(
            color: Colors.transparent,
            width: double.infinity,
            height: double.infinity,
            margin: EdgeInsets.only(left: 80, right: 80),
            child: widget.title,
          ),
        ),
      ],
    );
    widgets.add(stackTitleWidget);

    // 根据情况，添加返回按钮
    bool _automaticallyImplyLeading = widget.automaticallyImplyLeading ?? true;
    if (_automaticallyImplyLeading && widget.leading != null) {
      Widget leftNavBarButton = Positioned(
        left: 10,
        child: widget.leading,
      );
      widgets.add(leftNavBarButton);
    }

    if (widget.actions != null && widget.actions?.length > 0) {
      Widget rightNavBarButton = Positioned(
        right: 10,
        child: Container(
          padding: EdgeInsets.only(right: 0),
          // color: Colors.green,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.actions,
          ),
        ),
      );
      widgets.add(rightNavBarButton);
    }

    return Container(
      color: widget.backgroundColor ?? Colors.transparent,
      width: double.infinity,
      height: 44,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: widgets,
      ),
    );
  }
}
