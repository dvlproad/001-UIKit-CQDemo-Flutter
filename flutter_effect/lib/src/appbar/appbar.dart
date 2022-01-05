import 'package:flutter/material.dart';
import 'dart:ui';

import './appbar_component.dart';
export './appbar_component.dart';
import '../../flutter_effect_adapt.dart';

class EasyAppBarWidget extends AppBar {
  final Color backgroundColor;

  final Widget title;

  final Widget leading;
  final bool automaticallyImplyLeading;
  // final ImageProvider navbackImage;
  // final String navbackTitle;
  // // navbackImage: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // // navbackImage: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  // final VoidCallback
  //     onTapNavback; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

  final List<Widget> actions;

  EasyAppBarWidget({
    Key key,
    this.backgroundColor,
    this.title,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.actions,
  }) : super(key: key);

  @override
  _EasyAppBarWidgetState createState() => _EasyAppBarWidgetState();
}

class _EasyAppBarWidgetState extends State<EasyAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    // return buildAppBarWidget(context);
    return appBar();
  }

  // 使用自己的布局方式
  Widget buildAppBarWidget(BuildContext context) {
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
    if (widget.leading != null) {
      Widget navBarButton = Positioned(
        left: 20,
        child: widget.leading,
      );
      widgets.add(navBarButton);
    }

    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double stautsBarHeight = MediaQuery.of(context).padding.top;

    return Column(
      children: [
        Container(height: stautsBarHeight, color: Colors.transparent),
        Container(
          color: Colors.transparent,
          width: double.infinity,
          height: 44,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: widgets,
          ),
        ),
      ],
    );
  }

  // 使用系统的布局方式
  PreferredSizeWidget appBar() {
    return AppBar(
      backgroundColor: widget.backgroundColor, // 导航栏背景颜色
      elevation: 0, //隐藏底部阴影分割线
      centerTitle: true, // 标题统一居中(ios下默认居中对对齐,安卓下默认左对齐)
      // titleSpacing: 88, // 距离屏幕两边的距离默认16，当我们设置搜索的时候感觉两边距离太大太小可以调

      leading: widget.leading,
      automaticallyImplyLeading: widget.automaticallyImplyLeading,
      title: widget.title,
      actions: widget.actions,
    );
  }
}
