// toolbar 上 左侧返回视图 + 中间标题视图 + 右侧按钮视图
import 'package:flutter/material.dart';

import './toolbar_title.dart';
export './toolbar_title.dart';
export './toolbar_button.dart';
import './toolbar_enum.dart';
export './toolbar_enum.dart';

class QuickToolBar extends CommonToolBar {
  QuickToolBar(
    BuildContext context, {
    Key? key,
    Color? backgroundColor, // 导航栏背景色
    String? title, // 中间导航栏标题文本
    double? leftMargin,
    EdgeInsetsGeometry? titleMargin,
    AppBarTextColorType? textColorType, // 左侧(返回)按钮视图的类型
    bool? automaticallyImplyLeading, // 是否显示左侧(返回)按钮视图(默认true显示)
    String? leadingText, // 左侧返回按钮不使用图片时候的文本(默认null时，使用图片)
    double? leadingPositionedLeft,
    void Function()? customOnPressedBack,
    List<Widget>? actions, // 右侧操作按钮视图
    double? actionsPositionedRight,
    bool? centerTitle,
  }) : super(
          key: key,
          backgroundColor: backgroundColor,
          title: Row(
            mainAxisAlignment: centerTitle == true ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: leftMargin ?? 0),
                child: ToolBarTitleWidget(
                  text: title,
                  textColorType: textColorType,
                ),
              )
            ],
          ),
          titleMargin: titleMargin,
          automaticallyImplyLeading: false,
          leadingPositionedLeft: leadingPositionedLeft,
          actions: actions,
          actionsPositionedRight: actionsPositionedRight,
        );
}

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
  // final ImageProvider navbackImage;
  // final String navbackTitle;
  // // navbackImage: AssetImage('assets/images/emptyview/pic_搜索为空页面.png'),
  // // navbackImage: NetworkImage('https://dss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3238317745,514710292&fm=26&gp=0.jpg'),
  // final VoidCallback
  //     onTapNavback; //导航栏返回按钮的点击事件(有设置此值的时候，才会有返回按钮.默认外部都要设置，因为要返回要填入context)

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
