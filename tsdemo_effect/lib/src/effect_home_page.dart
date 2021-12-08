import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './refresh/refresh_home_page.dart';
import './empty/empty_home_page.dart';
import './loading/loading_home_page.dart';
import './loadstate/loadstate_home_page.dart';

import './basepage/tspage_home_page.dart';

import 'package:flutter_effect/src/load_state_widget/load_state_widget.dart';

class TSEffectHomePage extends CJTSBasePage {
  TSEffectHomePage({Key key}) : super(key: key);

  @override
//  _TSEffectHomePageState createState() => _TSEffectHomePageState();
  CJTSBasePageState getState() {
    return _TSEffectHomePageState();
  }
}

class _TSEffectHomePageState extends CJTSBasePageState<TSEffectHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Effect 首页'),
    );
  }

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "Refresh",
        'values': [
          {
            'title': "Refresh",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSRefreshHomePage()));
            },
          },
        ]
      },
      {
        'theme': "Empty",
        'values': [
          {
            'title': "Empty",
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSEmptyHomePage()));
            },
          },
        ]
      },
      {
        'theme': "Loading(加载中)",
        'values': [
          {
            'title': "Loading",
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadingHomePage()));
            },
          },
        ]
      },
      {
        'theme': "LoadState(加载各状态视图:加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "LoadState",
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSLoadStateHomePage()));
            },
          },
        ]
      },
      {
        'theme': "BasePage(加载各状态视图:加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "BasePage",
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSBasePageHomePage()));
            },
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
