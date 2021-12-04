import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSLoadStatePage extends StatefulWidget {
  final  LoadState loadState;
  TSLoadStatePage({
    Key key,
    this.loadState = LoadState.State_Loading,
  }) : super(key: key);


  @override
  _TSLoadStatePageState createState() => _TSLoadStatePageState();
}

class _TSLoadStatePageState extends State<TSLoadStatePage> {
  LoadState _layoutState;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _layoutState = widget.loadState;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LoadState(加载各状态视图:加载中、成功、失败、无数据)"),
      ),
      body: Center(
        child: _listView(context),
      ),
    );
  }

  Widget _listView(BuildContext context){
    return LoadStateLayout(
      state: _layoutState,
      emptyRetry: (){
        setState(() {
          _layoutState = LoadState.State_Loading;
        });
//        _getOrderList();
      },
      errorRetry: () {
        setState(() {
          _layoutState = LoadState.State_Loading;
        });
//        _getOrderList();
      }, //错误按钮点击过后进行重新加载
      successWidget: Center(child: Text('成功')),
    );
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
