import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:dio/dio.dart';

import '../widget/test_network_widget.dart';

class TSDefaultPage extends BJHDefaultPage {
  TSDefaultPage({
    Key key,
  }) : super(key: key);

  @override
  _TSDefaultPageState createState() => _TSDefaultPageState();
}

class _TSDefaultPageState extends BJHDefaultPageState<TSDefaultPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text("DefaultPage(加载中、成功、失败、无数据)"),
    );
  }

  @override
  Widget buildInitWidget(BuildContext context) {
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

  @override
  Widget buildSuccessWidget(BuildContext context) {
    return TSNetworkResultWidget(
      title: '我是【请求成功，且有数据】的界面',
      getData_Success: () {
        simulate_getData(WidgetType.SuccessWithData);
      },
      getData_NoData: () {
        simulate_getData(WidgetType.SuccessNoData);
      },
      getData_Error: () {
        simulate_getData(WidgetType.ErrorNetwork);
      },
    );
  }

  void simulate_getData(WidgetType widgetType) {
    showSelfLoadingAction();

    Future.delayed(Duration(seconds: 1), () {
      print('延时1s执行');
      updateWidgetType(widgetType);
    });
  }

  // @override
  // Widget buildNodataWidget(BuildContext context) {
  //   return StateNodataWidget(
  //     emptyRetry: getData,
  //   );
  // }

  // @override
  // Widget buildErrorWidget(BuildContext context) {
  //   return StateErrorWidget(
  //     errorRetry: getData,
  //   );
  // }

  // @override
  // Widget buildSelfLoadingWidgetWidget(BuildContext context) {
  //   return Container(
  //     height: 242,
  //     // color: Color.fromRGBO(22, 17, 175, 0.5),
  //     child: StateLoadingWidget(),
  //   );
  // }

  // 获取网络数据
  void getData() {
    showSelfLoadingAction();

    Future.delayed(Duration(seconds: 1), () {
      print('延时1s执行');
      getRequest().then((value) {
        String bean = value;
        if (bean == null) {
          updateWidgetType(WidgetType.SuccessNoData);
        } else {
          updateWidgetType(WidgetType.SuccessWithData);
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
