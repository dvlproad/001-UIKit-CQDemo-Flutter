import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './ts_base_page.dart';
import './ts_default_page.dart';
import './my_info.dart';

class TSBasePageHomePage extends CJTSBasePage {
  TSBasePageHomePage({Key key}) : super(key: key);

  @override
//  _TSBasePageHomePageState createState() => _TSBasePageHomePageState();
  CJTSBasePageState getState() {
    return _TSBasePageHomePageState();
  }
}

class _TSBasePageHomePageState extends CJTSBasePageState<TSBasePageHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('BasePage 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "LoadState(加载各状态视图:加载中、成功、失败、无数据)",
        'values': [
          {
            'title': "BasePage(系统appBar)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSBasePage()));
            },
          },
          {
            'title': "BasePage(自己的appBar)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TSBasePage(successHasCustomAppBar: true)));
            },
          },
          {
            'title': "DefaultPage",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSDefaultPage()));
            },
          },
        ]
      },
      {
        'theme': "其他",
        'values': [
          {
            'title': "Cell",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyInfo()));
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
