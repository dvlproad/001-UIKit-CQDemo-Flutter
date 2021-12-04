import 'package:flutter/material.dart';

import './state_loading_widget.dart';
import './state_error_widget.dart';
import './state_nodata_widget.dart';

//四种视图状态
enum LoadState {
  State_Success,
  State_Error,
  State_Loading,
  State_Empty, 
}

///根据不同状态来展示不同的视图
class LoadStateLayout extends StatefulWidget {
  final LoadState state; //页面状态
  final Widget successWidget; //成功视图
  final VoidCallback errorRetry; //错误事件处理
  final VoidCallback emptyRetry; //空数据事件处理

  LoadStateLayout(
      {Key key,
      this.state = LoadState.State_Loading, //默认为加载状态
      this.successWidget,
      this.errorRetry,
      this.emptyRetry})
      : super(key: key);

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
    switch (widget.state) {
      case LoadState.State_Success:
        return widget.successWidget;
        break;
      case LoadState.State_Error:
        return StateErrorWidget(errorRetry: widget.errorRetry);
        break;
      case LoadState.State_Loading:
        return StateLoadingWidget();
        break;
      case LoadState.State_Empty:
        return StateNodataWidget(emptyRetry: widget.emptyRetry);
        break;
      default:
        return null;
    }
  }
}
