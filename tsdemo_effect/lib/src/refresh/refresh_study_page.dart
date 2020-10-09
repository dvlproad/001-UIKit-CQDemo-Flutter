import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart'; //如果要使用炫酷的样式需要引入，不同的样式引入不同的文件，详见官方api
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart'; //如果要使用炫酷的样式需要引入，不同的样式引入不同的文件，详见官方api

class TSRefreshStudyPage extends StatefulWidget {
  @override
  _TSRefreshStudyPageState createState() => _TSRefreshStudyPageState();
}

class _TSRefreshStudyPageState extends State<TSRefreshStudyPage> {
  List<String> addStr = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];
  List<String> str = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"];

  EasyRefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Refresh(学习例子)"),
      ),
      body: Center(
        child: new EasyRefresh(
          header: BezierCircleHeader(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          footer: BezierBounceFooter(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          controller: _refreshController,
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
      // 固定在下方显示的按钮
      persistentFooterButtons: <Widget>[
        FlatButton(
          onPressed: () {
            _refreshController.callRefresh();
          },
          child: Text("refresh", style: TextStyle(color: Colors.black)),
        ),
        FlatButton(
          onPressed: () {
            _refreshController.callLoad();
          },
          child: Text("loadMore", style: TextStyle(color: Colors.black)),
        )
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
