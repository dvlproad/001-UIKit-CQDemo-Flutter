import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:dio/dio.dart';

import './widget/test_network_widget.dart';

class TSPageTypeLoadStateDefaultPage extends BJHBasePage {
  TSPageTypeLoadStateDefaultPage({
    Key key,
  }) : super(key: key);

  @override
  _TSPageTypeLoadStateDefaultPageState createState() =>
      _TSPageTypeLoadStateDefaultPageState();
}

class _TSPageTypeLoadStateDefaultPageState
    extends BJHBasePageState<TSPageTypeLoadStateDefaultPage> {
  WidgetType _widgetType;
  bool showSelfLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetType = WidgetType.Init;
    showSelfLoading = false;

    getData();
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
    return PageTypeLoadStateDefaultWidget(
      showSelfLoading: showSelfLoading,
      widgetType: _widgetType,
      emptyRetry: () {
        getData();
      },
      errorRetry: () {
        getData();
      },
      successWidget: _successWidget,
    );
  }

  Widget get _successWidget {
    return TSNetworkResultWidget(
      title: '我是【请求成功，且有数据】的界面',
      getData_Success: getData,
      getData_NoData: getData,
      getData_Error: getData,
    );
  }

  // 获取网络数据
  void getData() {
    showSelfLoading = true;
    setState(() {});
    Future.delayed(Duration(seconds: 1), () {
      print('延时1s执行');
      getRequest().then((value) {
        showSelfLoading = false;

        String bean = value;
        if (bean == null) {
          _widgetType = WidgetType.NoData;
        } else {
          _widgetType = WidgetType.Success;
        }
        setState(() {});
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

  /*
  Widget successWidget() {
    return Center(
        child: EasyRefresh(
          child: ListView.builder(
            //controller: scrollController,
            itemBuilder: (context, index) {
              return _item(orderList, index);
            },
            itemCount: orderList.length,
          ),
          //firstRefresh: true,
          controller: _controller,
          header: ClassicalHeader(
            refreshText: '下拉刷新',
            refreshReadyText: '释放刷新',
            refreshingText: '正在刷新...',
            refreshedText: '刷新完成',
            refreshFailedText: '刷新失败',
            noMoreText: '没有更多',
            infoText: '更新于 %T',
          ),
          footer: ClassicalFooter(
              loadedText: '加载完成',
              loadReadyText: '释放加载',
              loadingText: '正在加载...',
              loadFailedText: '加载失败',
              noMoreText: '没有更多',
              infoText: '更新于 %T'
          ),
          onRefresh: () async{
            _getOrderList();
          },
          onLoad: orderList.length==10? () async{
            _getMoreList();
          }:null,
        )
    );
  */
}
