import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:dio/dio.dart';

import '../widget/test_network_widget.dart';

class TSPageTypeLoadStatePage extends StatefulWidget {
  TSPageTypeLoadStatePage({
    Key key,
  }) : super(key: key);

  @override
  _TSPageTypeLoadStatePageState createState() =>
      _TSPageTypeLoadStatePageState();
}

class _TSPageTypeLoadStatePageState extends State<TSPageTypeLoadStatePage> {
  WidgetType _widgetType;
  bool showSelfLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetType = WidgetType.Init;
    showSelfLoading = false;

    getData_Success();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoadState(加载各状态视图:加载中、成功、失败、无数据)"),
      ),
      body: Container(
        //宽高都充满屏幕剩余空间
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: _buildWidget(),
      ),
    );
  }

  Widget _buildWidget() {
    return PageTypeLoadStateWidget(
      widgetType: _widgetType,
      initWidget: _initWidget,
      successWidget: _successWidget,
      nodataWidget: _nodataWidget,
      errorWidget: _errorWidget,
      showSelfLoading: showSelfLoading,
      selfLoadingWidget: Container(
        height: 242,
        // color: Color.fromRGBO(22, 17, 175, 0.5),
        child: StateLoadingWidget(),
      ),
    );
  }

  Widget get _initWidget {
    return Container(
      color: Colors.green,
      height: 100,
      child: Text(
        '我是初始视图的底部视图...',
        style: TextStyle(color: Colors.blue, fontSize: 24),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget get _nodataWidget {
    return TSNetworkResultWidget(
      title: '我是【请求成功，但无数据】的界面',
      getData_Success: getData_Success,
      getData_NoData: getData_NoData,
      getData_Error: getData_Error,
    );
  }

  Widget get _successWidget {
    return TSNetworkResultWidget(
      title: '我是【请求成功，且有数据】的界面',
      getData_Success: getData_Success,
      getData_NoData: getData_NoData,
      getData_Error: getData_Error,
    );
  }

  Widget get _errorWidget {
    return TSNetworkResultWidget(
      title: '我是【请求失败】的界面',
      getData_Success: getData_Success,
      getData_NoData: getData_NoData,
      getData_Error: getData_Error,
    );
  }

  // 模拟网络请求：请求成功，且有数据
  void getData_Success() {
    showSelfLoading = true;
    setState(() {});

    Future.delayed(Duration(seconds: 1), () {
      print('模拟网络请求结束：请求成功，且有数据');
      showSelfLoading = false;
      _widgetType = WidgetType.Success;

      setState(() {});
    });
  }

  // 模拟网络请求：请求成功，但无数据
  void getData_NoData() {
    showSelfLoading = true;
    setState(() {});

    Future.delayed(Duration(seconds: 1), () {
      print('模拟网络请求结束：请求成功，但无数据');
      showSelfLoading = false;
      _widgetType = WidgetType.NoData;

      setState(() {});
    });
  }

  // 模拟网络请求：请求失败
  void getData_Error() {
    showSelfLoading = true;
    setState(() {});

    Future.delayed(Duration(seconds: 1), () {
      print('模拟网络请求结束：请求失败');
      showSelfLoading = false;
      _widgetType = WidgetType.Error;

      setState(() {});
    });
  }
}
