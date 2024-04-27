// 不存在复用 successWidget 上的导航栏
// appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)的原因是:
// 原因是在有背景图存在的情况下，其他buildErrorWidget(BuildContext context)返回的视图为了能够显示背景图会设置成透明色，
// 同样的因为设置了这个透明色，导致原本想的通过下移复用buildSuccessWidget(BuildContext context)中的导航栏，
// 虽然复用了，但是success视图也显示上去了，而你的buildErrorWidget(BuildContext context)确是透明的，那就变成了把原本要遮盖住的视图给显示出来了，
// 除非你能够把success中非appBar的部分给隐藏起来(可以，但代码操作不方便)
// 所以appBar不能设置在success中，只能设置在appBar()或此处appBarWidget(BuildContext context)

import 'package:flutter/material.dart';

//四种视图类型
enum WidgetType {
  Unknow, //未知类型
  Init, //初始视图
  SuccessWithData, //成功视图
  SuccessNoData, //空数据视图(网络请求成功，但数据为空)
  // ErrorBusiness, //服务器连接成功，但数据异常的错误视图(网络错误)
  ErrorNetwork, //服务器连接失败的错误视图(网络错误)
}

///根据不同类型来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final WidgetType? widgetType; //页面类型
  final Widget? initWidget; //初始视图(未设置时，将使用Container())
  final Widget successWidget; //成功视图
  final Widget? errorWidget; //错误视图(网络错误)
  final Widget? nodataWidget; //空数据视图(网络请求成功，但数据为空)

  LoadStateLayout({
    Key? key,
    this.widgetType = WidgetType.Init, //默认为加载状态
    this.initWidget,
    // this.initWidget = const Container(), // 默认Container()
    required this.successWidget,
    this.errorWidget,
    this.nodataWidget,
  }) : super(key: key);

  @override
  _LoadStateLayoutState createState() => _LoadStateLayoutState();
}

class _LoadStateLayoutState extends State<LoadStateLayout> {
  @override
  Widget build(BuildContext context) {
    return Container(
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      child: _buildWidget,
    );
  }

  ///根据不同状态来显示不同的视图(新方式：使用 stack 隐藏方式，使其能够复用 successWidget 上的导航栏)
  Widget get _buildWidget {
    double marginTop = 0;
    List<Widget> stackWidgets = [];

    bool shouldShowSuccess = widget.widgetType == WidgetType.SuccessWithData;
    // bool shouldShowSuccess =
    //     true; // 临时修复外界请求成功时候,没有更新 updateWidgetType(WidgetType.SuccessWithData); 导致无法使用 widget.widgetType == WidgetType.SuccessWithData 来判断的问题. eg: 我的关注 my_follow_page
    stackWidgets.add(
      Visibility(
        visible: shouldShowSuccess,
        child: widget.successWidget,
      ),
    );

    if (widget.initWidget != null) {
      stackWidgets.add(
        Visibility(
          visible: widget.widgetType == WidgetType.Init,
          child: Container(
            color: Colors.transparent,
            child: widget.initWidget,
            margin: EdgeInsets.only(top: marginTop),
          ),
        ),
      );
    }

    if (widget.nodataWidget != null) {
      stackWidgets.add(
        Visibility(
          visible: widget.widgetType == WidgetType.SuccessNoData,
          child: Container(
            color: Colors.transparent,
            child: widget.nodataWidget,
            margin: EdgeInsets.only(top: marginTop),
          ),
        ),
      );
    }
    if (widget.errorWidget != null) {
      stackWidgets.add(
        Visibility(
          visible: widget.widgetType == WidgetType.ErrorNetwork,
          child: Container(
            color: Colors.transparent,
            child: widget.errorWidget,
            margin: EdgeInsets.only(top: marginTop),
          ),
        ),
      );
    }
    return Stack(
      children: stackWidgets,
    );
  }

  /*
  ///根据不同状态来显示不同的视图(旧方式)
  Widget get _buildWidget {
    switch (widget.widgetType) {
      case WidgetType.Init:
        return widget.initWidget;
        break;
      case WidgetType.SuccessWithData:
        return widget.successWidget;
        break;
      case WidgetType.SuccessNoData:
        return widget.nodataWidget;
        break;
      case WidgetType.ErrorBusiness:
        return widget.errorWidget;
        break;
      case WidgetType.ErrorNetwork:
        return widget.errorWidget;
        break;
      default:
        return null;
    }
  }
  */
}
