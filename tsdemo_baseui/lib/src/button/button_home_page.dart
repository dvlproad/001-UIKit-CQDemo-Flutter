/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 16:19:21
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemo_baseui/src/baseui_routes.dart';

class TSButtonHomePage extends CJTSBasePage {
  final String? title;

  TSButtonHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSButtonHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Button 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Button",
        'values': [
          {
            'title': "theme button(主题按钮)",
            'nextPageName': BaseUIKitRouters.themeButtonPage,
          },
          {
            'title': "state button(状态按钮)",
            'nextPageName': BaseUIKitRouters.stateButtonPage,
          },
          {
            'title': "other button(其他按钮)",
            'nextPageName': BaseUIKitRouters.otherButtonPage,
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
