import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import './ts_appbar_page.dart';

class TSAppBarHomePage extends CJTSBasePage {
  TSAppBarHomePage({Key key}) : super(key: key);

  @override
//  _TSAppBarHomePageState createState() => _TSAppBarHomePageState();
  CJTSBasePageState getState() {
    return _TSAppBarHomePageState();
  }
}

class _TSAppBarHomePageState extends CJTSBasePageState<TSAppBarHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('AppBar 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "导航栏(自定义)",
        'values': [
          {
            'title': "导航栏(自定义)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSAppBarPage()));
            },
          },
        ],
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
