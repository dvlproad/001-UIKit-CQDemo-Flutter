/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 16:20:12
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemo_baseui/src/baseui_routes.dart';

class TSTextFieldHomePage extends CJTSBasePage {
  final String? title;

  TSTextFieldHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSTextFieldHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'TextField首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Textfield UI",
        'values': [
          {
            'title': "icon textfield(常见于登录)",
            'nextPageName': BaseUIKitRouters.iconTextFieldPage,
          },
          {
            'title': "text textfield(常见于忘记密码)",
            'nextPageName': BaseUIKitRouters.textTextFieldPage,
          },
        ]
      },
      {
        'theme': "Textfield Formatter",
        'values': [
          {
            'title': "文本内容限制(用户名、昵称)",
            'nextPageName': BaseUIKitRouters.textinputfomrmatterPage,
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
