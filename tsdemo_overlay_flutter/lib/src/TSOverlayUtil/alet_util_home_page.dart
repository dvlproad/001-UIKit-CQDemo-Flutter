/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:19:29
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_util_routes.dart';

class TSAlertUtilHomePage extends CJTSBasePage {
  final String? title;

  TSAlertUtilHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSAlertUtilHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Alert 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "单条信息的弹窗视图",
        'values': [
          {
            'title': "MessageAlertModalPage",
            'content': '单条信息的弹窗视图弹出测试',
            'nextPageName': OverlayUtilRouters.messageAlertUtilPage,
          },
        ]
      },
      {
        'theme': "多条信息的弹窗视图",
        'values': [
          {
            'title': "ListMessageAlertModalPage(待补充)",
            'content': '多条信息的弹窗视图弹出测试',
            'nextPageName': OverlayUtilRouters.messageAlertUtilPage,
          },
        ]
      },
      {
        'theme': "单输入框的弹窗视图",
        'values': [
          {
            'title': "TextInputAlertModalPage(待补充)",
            'content': '单输入框的弹窗视图弹出测试',
            'nextPageName': OverlayUtilRouters.messageAlertUtilPage,
          },
        ]
      },
      {
        'theme': "多输入框的弹窗视图",
        'values': [
          {
            'title': "ListTextInputAlertModalPage(待补充)",
            'content': '多输入框的弹窗视图弹出测试',
            'nextPageName': OverlayUtilRouters.messageAlertUtilPage
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
