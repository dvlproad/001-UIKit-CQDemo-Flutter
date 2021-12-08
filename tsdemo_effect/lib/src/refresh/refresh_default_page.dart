import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSRefreshDefaultPage extends StatefulWidget {
  @override
  _TSRefreshDefaultPageState createState() => _TSRefreshDefaultPageState();
}

class _TSRefreshDefaultPageState extends State<TSRefreshDefaultPage> {
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
        title: Text("Refresh(全局默认文本)"),
      ),
      body: Center(
        child: new EasyRefresh(
          // header: BezierCircleHeader(
          //   color: Theme.of(context).scaffoldBackgroundColor,
          // ),
          footer: RefreshFooter(
            noMoreWidget: Text(
              "没有更多媒体了",
              style: TextStyle(
                color: Color(0xFFBFBFBF),
              ),
            ),
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
    );
  }
}
