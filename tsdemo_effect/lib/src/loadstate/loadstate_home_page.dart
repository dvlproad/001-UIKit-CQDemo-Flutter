import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './loadstate_page.dart';
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
        'theme': "LoadState(加载各状态视图:加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "加载中",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSLoadStatePage(loadState: WidgetType.Init)));
            },
          },
          {
            'title': "成功",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSLoadStatePage(loadState: WidgetType.Success)));
            },
          },
          {
            'title': "失败",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSLoadStatePage(loadState: WidgetType.Error)));
            },
          },
          {
            'title': "无数据空页面",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSLoadStatePage(loadState: WidgetType.NoData)));
            },
          },
        ]
      },
      {
        'theme': "LoadState(加载各状态视图:加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "整体测试（PageType）",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadStatePage()));
            },
          },
          {
            'title': "整体测试(PageType+LoadState)",
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
