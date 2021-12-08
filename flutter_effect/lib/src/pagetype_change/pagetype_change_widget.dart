import 'package:flutter/material.dart';

//四种视图类型
enum WidgetType {
  Init, //初始视图
  SuccessWithData, //成功视图
  SuccessNoData, //空数据视图(网络请求成功，但数据为空)
  ErrorBusiness, //服务器连接成功，但数据异常的错误视图(网络错误)
  ErrorNetwork, //服务器连接失败的错误视图(网络错误)
}

///根据不同类型来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final WidgetType widgetType; //页面类型
  final Widget initWidget; //初始视图(未设置时，将使用Container())
  final Widget successWidget; //成功视图
  final Widget errorWidget; //错误视图(网络错误)
  final Widget nodataWidget; //空数据视图(网络请求成功，但数据为空)

  LoadStateLayout({
    Key key,
    this.widgetType = WidgetType.Init, //默认为加载状态
    this.initWidget,
    // this.initWidget = const Container(), // 默认Container()
    this.successWidget,
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

  ///根据不同状态来显示不同的视图
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
}
