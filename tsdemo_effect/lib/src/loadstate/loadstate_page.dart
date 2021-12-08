import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

import 'package:dio/dio.dart';

class TSLoadStatePage extends StatefulWidget {
  final WidgetType loadState;
  TSLoadStatePage({
    Key key,
    this.loadState = WidgetType.Init,
  }) : super(key: key);

  @override
  _TSLoadStatePageState createState() => _TSLoadStatePageState();
}

class _TSLoadStatePageState extends State<TSLoadStatePage> {
  WidgetType _widgetType;
  bool showLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _widgetType = widget.loadState;
    showLoading = false;

    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoadState(加载各状态视图:加载中、成功、失败、无数据)"),
      ),
      body: Center(
        child: _pageTypeWidget,
      ),
    );
  }

  Widget get _pageTypeWidget {
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
      successWidget: Center(child: Text('成功')),
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
