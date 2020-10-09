import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './refresh_study_page.dart';
import './refresh_default_page.dart';

class TSRefreshHomePage extends CJTSBasePage {
  TSRefreshHomePage({Key key}) : super(key: key);

  @override
//  _TSRefreshHomePageState createState() => _TSRefreshHomePageState();
  CJTSBasePageState getState() {
    return _TSRefreshHomePageState();
  }
}

class _TSRefreshHomePageState extends CJTSBasePageState<TSRefreshHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Refresh 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Refresh 学习",
        'values': [
          {
            'title': "Refresh(学习例子)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSRefreshStudyPage()));
            },
          },
        ]
      },
      {
        'theme': "Refresh CQApp中",
        'values': [
          {
            'title': "Refresh(全局默认文本)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSRefreshDefaultPage()));
            },
          },
          // {
          //   'title': "Refresh(页面自定义文本)",
          //   // 'nextPageName': BaseUIKitRouters.imageviewHomePage,
          // },
          // {
          //   'title': "Refresh(页面无文本)",
          //   // 'nextPageName': BaseUIKitRouters.textFieldHomePage,
          // },
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
