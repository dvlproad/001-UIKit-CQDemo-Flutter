/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 13:28:26
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSNetworkResultWidget extends StatefulWidget {
  final Color color;
  final double marginTop; // title离顶部的距离，为了防止有数据、无数据、无网络三种视图重叠，而导致看不出是否在显示
  final String title;
  final Function() getData_Success;
  final Function() getData_NoData;
  final Function() getData_Error;

  TSNetworkResultWidget({
    Key key,
    this.color,
    this.marginTop,
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
        Container(height: widget.marginTop),
        Text(widget.title ?? '我是等你传进来设置的标题'),
        TextButton(
          onPressed: widget.getData_Success,
          child: Text('重新加载(模拟网络请求：请求成功，且有数据)'),
        ),
        TextButton(
          onPressed: widget.getData_NoData,
          child: Text('重新加载(模拟网络请求结束：请求成功，但无数据)'),
        ),
        TextButton(
          onPressed: widget.getData_Error,
          child: Text('重新加载(模拟网络请求结束：请求失败)'),
        ),
      ],
    );
  }
}
