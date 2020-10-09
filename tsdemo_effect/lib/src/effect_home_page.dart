import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './refresh/refresh_home_page.dart';
import './empty/empty_home_page.dart';

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
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
