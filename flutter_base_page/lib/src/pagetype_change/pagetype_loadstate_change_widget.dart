import 'package:flutter/material.dart';

import './pagetype_change_widget.dart';

///根据不同状态来展示不同的视图
class PageTypeLoadStateWidget extends StatefulWidget {
  final WidgetType? widgetType; //页面类型

  final Widget? initWidget; //初始视图(未设置时，将使用Container())
  final Widget successWidget; //成功视图
  final Widget? nodataWidget; //空数据视图(网络请求成功，但数据为空):不同页面无数据视图可能不一样
  final Widget? errorWidget; //错误视图(网络错误)

  final Widget? selfLoadingWidget;
  final bool? showSelfLoading; // 是否显示loading

  PageTypeLoadStateWidget({
    Key? key,
    this.widgetType = WidgetType.Init, //默认为初始界面
    this.initWidget,
    // this.initWidget = const Container(), // 默认Container()
    required this.successWidget,
    this.nodataWidget,
    this.errorWidget,
    this.selfLoadingWidget,
    this.showSelfLoading,
  }) : super(key: key);

  @override
  _PageTypeLoadStateWidgetState createState() =>
      _PageTypeLoadStateWidgetState();
}

class _PageTypeLoadStateWidgetState extends State<PageTypeLoadStateWidget> {
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
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        _pageTypeWidget,
        Positioned(
          left: 40,
          right: 40,
          // 本来这里用的是 Offstage ，会引起频繁渲染，导致页面掉帧。
          // Offstage，隐藏时，其隐藏的子 Widget 不会进行绘制和事件处理，但它们仍然存在于树中，可以保持其内部状态。
          // Visibility，隐藏时，其隐藏的子 Widget 不会进行绘制、事件处理，并且不会占用布局空间。
          child: Visibility(
            visible: widget.showSelfLoading == true,
            child: widget.selfLoadingWidget ?? Container(),
          ),
        ),
      ],
    );
  }

  Widget get _pageTypeWidget {
    return LoadStateLayout(
      widgetType: widget.widgetType,
      initWidget: widget.initWidget,
      successWidget: widget.successWidget,
      nodataWidget: widget.nodataWidget,
      errorWidget: widget.errorWidget,
    );
  }
}
