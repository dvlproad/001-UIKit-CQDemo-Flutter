import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSNetworkResultWidget extends StatefulWidget {
  final Color color;
  final String title;
  final Function() getData_Success;
  final Function() getData_NoData;
  final Function() getData_Error;

  TSNetworkResultWidget({
    Key key,
    this.color,
    this.title,
    this.getData_Success,
    this.getData_NoData,
    this.getData_Error,
  }) : super(key: key);

  @override
  _TSNetworkResultWidgetState createState() => _TSNetworkResultWidgetState();
}

class _TSNetworkResultWidgetState extends State<TSNetworkResultWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //宽高都充满屏幕剩余空间
      width: double.infinity,
      height: double.infinity,
      color: widget.color,
      child: _buildWidget(),
    );
  }

  Widget _buildWidget() {
    return Column(
      children: [
        Text(widget.title ?? '我是等你传进来设置的标题'),
        FlatButton(
          onPressed: widget.getData_Success,
          child: Text('重新加载(模拟网络请求：请求成功，且有数据)'),
          color: Colors.blue,
        ),
        FlatButton(
          onPressed: widget.getData_NoData,
          child: Text('重新加载(模拟网络请求结束：请求成功，但无数据)'),
          color: Colors.blue,
        ),
        FlatButton(
          onPressed: widget.getData_Error,
          child: Text('重新加载(模拟网络请求结束：请求失败)'),
          color: Colors.blue,
        ),
      ],
    );
  }
}
