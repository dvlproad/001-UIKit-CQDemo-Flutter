import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

// pagetype_appbar
import './ts_pagetype_appbar_page.dart';

import './pagetype_loadstate_page.dart';

import 'package:flutter_effect/flutter_effect.dart'; // 只为引入状态枚举

class TSLoadStateHomePage extends CJTSBasePage {
  TSLoadStateHomePage({Key key}) : super(key: key);

  @override
//  _TSLoadStateHomePageState createState() => _TSLoadStateHomePageState();
  CJTSBasePageState getState() {
    return _TSLoadStateHomePageState();
  }
}

class _TSLoadStateHomePageState extends CJTSBasePageState<TSLoadStateHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('LoadState 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "测试 PageTypeAppBar 中 PayeType(加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "加载中",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSPageTypeAppBarPage(widgetType: WidgetType.Init)));
            },
          },
          {
            'title': "成功",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSPageTypeAppBarPage(
                          widgetType: WidgetType.SuccessWithData)));
            },
          },
          {
            'title': "失败",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSPageTypeAppBarPage(
                          widgetType: WidgetType.ErrorNetwork)));
            },
          },
          {
            'title': "无数据空页面",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSPageTypeAppBarPage(
                          widgetType: WidgetType.SuccessNoData)));
            },
          },
        ]
      },
      {
        'theme': "测试 PageTypeAppBar 中 AppBar(有无导航栏)",
        'values': [
          {
            'title': "content无再加自定义的导航栏",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSPageTypeAppBarPage(
                            successHasCustomAppBar: false,
                          )));
            },
          },
          {
            'title': "content有自己加自定义的导航栏",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSPageTypeAppBarPage(successHasCustomAppBar: true)));
            },
          },
        ]
      },
      {
        'theme': "测试 PageTypeAppBar+Loading",
        'values': [
          {
            'title': "整体测试(PageTypeAppBar+Loading)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSPageTypeLoadStatePage()));
            },
          },
        ]
      },
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: CJTSSectionTableView(
            context: context,
            sectionModels: sectionModels,
          ),
        ),
      ],
    );
  }
}
