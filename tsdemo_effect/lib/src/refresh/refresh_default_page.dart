import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart'; //如果要使用炫酷的样式需要引入，不同的样式引入不同的文件，详见官方api
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart'; //如果要使用炫酷的样式需要引入，不同的样式引入不同的文件，详见官方api
import 'package:flutter_effect/flutter_effect.dart';

class TSRefreshDefaultPage extends StatefulWidget {
  @override
  _TSRefreshDefaultPageState createState() => _TSRefreshDefaultPageState();
}

class _TSRefreshDefaultPageState extends State<TSRefreshDefaultPage> {
  List<String> addStr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  List<String> str = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  // GlobalKey<EasyRefreshState> _easyRefreshKey =
  //     new GlobalKey<EasyRefreshState>();
  // GlobalKey<RefreshHeaderState> _headerKey =
  //     new GlobalKey<RefreshHeaderState>();
  // GlobalKey<RefreshFooterState> _footerKey =
  //     new GlobalKey<RefreshFooterState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh(全局默认文本)"),
      ),
      body: Center(
        child: new EasyRefresh(
          // key: _easyRefreshKey,
          header: BezierCircleHeader(
            // key: _headerKey,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          footer: BezierBounceFooter(
            // key: _footerKey,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),

          child: new ListView.builder(
            //ListView的Item
            itemCount: str.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                height: 70.0,
                child: Card(
                  child: new Center(
                    child: new Text(
                      str[index],
                      style: new TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              );
            },
          ),
          onRefresh: () async {
            await new Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                str.clear();
                str.addAll(addStr);
              });
            });
          },
          onLoad: () async {
            await new Future.delayed(const Duration(seconds: 1), () {
              if (str.length < 20) {
                setState(() {
                  str.addAll(addStr);
                });
              }
            });
          },
        ),
      ),
      // persistentFooterButtons: <Widget>[
      //   FlatButton(
      //       onPressed: () {
      //         _easyRefreshKey.currentState.callRefresh();
      //       },
      //       child: Text("refresh", style: TextStyle(color: Colors.black))),
      //   FlatButton(
      //       onPressed: () {
      //         _easyRefreshKey.currentState.callLoadMore();
      //       },
      //       child: Text("loadMore", style: TextStyle(color: Colors.black)))
      // ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
