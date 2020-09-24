import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_routes.dart';

class TSGestureHomePage extends CJTSBasePage {
  final String title;

  TSGestureHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSGestureHomePage> {
  var sectionModels = [];

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "手势等",
        'values': [
          {
            'title': "Listener(原始指针事件)",
            'nextPageName': GestureRouters.listenerPage,
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
