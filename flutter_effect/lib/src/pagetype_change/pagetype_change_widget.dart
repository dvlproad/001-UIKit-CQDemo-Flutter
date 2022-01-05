import 'package:flutter/material.dart';

//四种视图类型
enum WidgetType {
  Init, //初始视图
  SuccessWithData, //成功视图
  SuccessNoData, //空数据视图(网络请求成功，但数据为空)
  // ErrorBusiness, //服务器连接成功，但数据异常的错误视图(网络错误)
  ErrorNetwork, //服务器连接失败的错误视图(网络错误)
}

///根据不同类型来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final WidgetType widgetType; //页面类型
  final Widget initWidget; //初始视图(未设置时，将使用Container())
  final Widget successWidget; //成功视图
  final double
      successWidgetCustomAppBarHeight; // 成功视图上有自己添加上去的导航栏时候，其导航栏高度(默认0)
  final Widget errorWidget; //错误视图(网络错误)
  final Widget nodataWidget; //空数据视图(网络请求成功，但数据为空)

  LoadStateLayout({
    Key key,
    this.widgetType = WidgetType.Init, //默认为加载状态
    this.initWidget,
    // this.initWidget = const Container(), // 默认Container()
    this.successWidget,
    this.successWidgetCustomAppBarHeight = 0,
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
    double marginTop = widget.successWidgetCustomAppBarHeight;
    List<Widget> stackWidgets = [];

    if (widget.successWidget != null) {
      // 当状态是 SuccessWithData 或者 marginTop!=0要复用success上的导航栏时候,才显示success
      // bool shouldShowSuccess =
      //     widget.widgetType == WidgetType.SuccessWithData || marginTop != 0;
      bool shouldShowSuccess =
          true; // 临时修复外界请求成功时候,没有更新 updateWidgetType(WidgetType.SuccessWithData); 导致无法使用 widget.widgetType == WidgetType.SuccessWithData 来判断的问题. eg: 我的关注 my_follow_page
      stackWidgets.add(
        Visibility(
          visible: shouldShowSuccess,
          child: widget.successWidget,
        ),
      );
    }

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
  ///根据不同状态来显示不同的视图(旧方式：不能够复用 successWidget 上的导航栏)
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
