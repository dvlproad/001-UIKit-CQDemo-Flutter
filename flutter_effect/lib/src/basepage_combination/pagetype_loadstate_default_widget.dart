import 'package:flutter/material.dart';

import '../pagetype_change/pagetype_loadstate_change_widget.dart';
import '../pagetype_change/pagetype_change_widget.dart'; // 为了引入WidgetType

import '../pagetype_error/state_error_widget.dart';
import '../pagetype_nodata/nodata_widget.dart';
import '../loading/state_loading_widget.dart';

///根据不同状态来展示不同的视图
class PageTypeLoadStateDefaultWidget extends StatefulWidget {
  final WidgetType widgetType; //页面类型
  final Widget initWidget; //初始视图(未设置时，将使用Container())
  final Widget successWidget; //成功视图
  final VoidCallback emptyRetry; //空数据事件处理
  final VoidCallback errorRetry; //错误视图(网络错误)错误事件处理

  final bool showSelfLoading; // 是否显示loading

  PageTypeLoadStateDefaultWidget({
    Key key,
    this.widgetType = WidgetType.Init, //默认为加载状态
    this.initWidget,
    this.successWidget,
    this.errorRetry,
    this.emptyRetry,
    this.showSelfLoading,
  }) : super(key: key);

  @override
  _PageTypeLoadStateDefaultWidgetState createState() =>
      _PageTypeLoadStateDefaultWidgetState();
}

class _PageTypeLoadStateDefaultWidgetState
    extends State<PageTypeLoadStateDefaultWidget> {
  @override
  Widget build(BuildContext context) {
    return PageTypeLoadStateWidget(
      widgetType: widget.widgetType,
      initWidget: widget.initWidget,
      successWidget: widget.successWidget,
      nodataWidget: StateNodataWidget(),
      errorWidget: StateErrorWidget(
        errorRetry: widget.errorRetry,
      ),
      showSelfLoading: widget.showSelfLoading,
      selfLoadingWidget: Container(
        height: 242,
        // color: Color.fromRGBO(22, 17, 175, 0.5),
        child: StateLoadingWidget(),
      ),
    );
  }
}
