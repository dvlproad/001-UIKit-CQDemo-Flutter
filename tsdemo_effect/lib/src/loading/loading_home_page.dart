import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import './loading_page.dart';

class TSLoadingHomePage extends CJTSBasePage {
  TSLoadingHomePage({Key key}) : super(key: key);

  @override
//  _TSLoadingHomePageState createState() => _TSLoadingHomePageState();
  CJTSBasePageState getState() {
    return _TSLoadingHomePageState();
  }
}

class _TSLoadingHomePageState extends CJTSBasePageState<TSLoadingHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Loading 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "加载动画",
        'values': [
          {
            'title': "加载动画(个体)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSLoadingPage()));
            },
          },
          {
            'title': "加载动画(单例)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              LoadingUtil.show();
              Future.delayed(Duration(seconds: 1), () {
                print('延时1s执行');
                LoadingUtil.dismiss();
              });
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
