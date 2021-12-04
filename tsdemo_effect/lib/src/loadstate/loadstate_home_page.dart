import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './loadstate_page.dart';

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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadStatePage(loadState: LoadState.State_Loading)));
            },
          },
          {
            'title': "成功",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadStatePage(loadState: LoadState.State_Success)));
            },
          },
          {
            'title': "失败",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadStatePage(loadState: LoadState.State_Error)));
            },
          },
          {
            'title': "无数据空页面",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadStatePage(loadState: LoadState.State_Empty)));
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
