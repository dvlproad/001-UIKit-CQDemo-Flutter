/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 13:19:34
 * @Description: 
 */
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

import 'package:dio/dio.dart';
import 'dart:ui';

class TSPageTypeAppBarPage extends StatefulWidget {
  final WidgetType widgetType;
  final bool
      successHasCustomAppBar; // success 是否有自己添加上去的导航栏(默认没有，即默认都是在appBar中设置的)
  TSPageTypeAppBarPage({
    Key key,
    this.widgetType = WidgetType.Init,
    this.successHasCustomAppBar = false,
  }) : super(key: key);

  @override
  _TSPageTypeAppBarPageState createState() => _TSPageTypeAppBarPageState();
}

class _TSPageTypeAppBarPageState extends State<TSPageTypeAppBarPage> {
  WidgetType _widgetType;
  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetType = widget.widgetType;
    showLoading = false;

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.successHasCustomAppBar
          ? null
          : AppBar(
              title: Text("LoadState(加载各状态视图:加载中、成功、失败、无数据)"),
            ),
      body: Center(
        child: _pageTypeWidget,
      ),
    );
  }

  /// 成功视图
  Widget get _successWidget {
    List<Widget> columnWidgets = [];

    if (widget.successHasCustomAppBar) {
      Widget appBar = CommonAppBar(
        title: ToolBarTitleWidget(text: '我是成功页面的标题'),
        leading: QuickToolBarImageActionWidget(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
      columnWidgets.add(appBar);
    }
    columnWidgets.add(
      Expanded(
        child: Center(child: Text('成功')),
      ),
    );

    return Column(
      children: columnWidgets,
    );
  }

  Widget get _pageTypeWidget {
    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    double stautsBarHeight = mediaQuery.padding.top; //这个就是状态栏的高度
    //或者 double stautsBarHeight = MediaQuery.of(context).padding.top;
    double hasAppBarWidget =
        widget.successHasCustomAppBar ? stautsBarHeight + 44 : 0;

    return LoadStateLayout(
      widgetType: _widgetType,
      // initWidget: widget.initWidget;
      initWidget: Container(
        color: Colors.green,
        height: 100,
        child: Text(
          '我是底部视图222...',
          style: TextStyle(color: Colors.blue, fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
      successWidget: _successWidget,

      //错误按钮点击过后进行重新加载
      errorWidget: StateErrorWidget(
        errorRetry: () {
          setState(() {
            //_layoutState = ; // 不变
          });
          getData();
        },
      ),
      // nodataWidget: StateNodataWidget(
      //   emptyRetry: (){
      //     setState(() {
      //     // _layoutState = WidgetType.State_Loading; // 不变
      //   });
      //   getData();
      //   }),
      // ),
    );
  }

  void getData() {
    Future.delayed(Duration(seconds: 1), () {
      print('延时1s执行');
      getRequest().then((value) {
        showLoading = false;

        String bean = value;
        if (bean == null) {
          _widgetType = WidgetType.SuccessNoData;
        } else {
          _widgetType = WidgetType.SuccessWithData;
        }
        _widgetType = WidgetType.ErrorNetwork;
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  // 获取排行榜列表
  Future<dynamic> getRequest() async {
    var url = "https://www.baidu.com";
    try {
      Dio dio = new Dio();
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('后端接口出现异常');
      }
    } catch (e) {
      throw Exception('网络错误:======>url:$url \nbody:${e.toString()}');
    }
  }
}
