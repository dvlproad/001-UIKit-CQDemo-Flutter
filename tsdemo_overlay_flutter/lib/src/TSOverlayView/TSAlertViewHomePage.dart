/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:17:01
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_view_routes.dart';

class TSAlertViewHomePage extends CJTSBasePage {
  final String? title;

  TSAlertViewHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSAlertViewHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay View 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "单条信息的弹窗视图",
        'values': [
          {
            'title': "MessageAlertPage",
            'content': '单条信息的弹窗视图显示测试',
            'nextPageName': OverlayViewRouters.messageAlertViewPage,
          },
        ]
      },
      {
        'theme': "多条信息的弹窗视图",
        'values': [
          {
            'title': "ListMessageAlertPage",
            'content': '多条信息的弹窗视图显示测试',
            // 'nextPageName': "ListMessageAlertPage",
          },
        ]
      },
      {
        'theme': "单输入框的弹窗视图",
        'values': [
          {
            'title': "TextInputAlertPage",
            'content': '单输入框的弹窗视图显示测试',
            'nextPageName': OverlayViewRouters.textInputAlertViewPage,
          },
        ]
      },
      {
        'theme': "多输入框的弹窗视图",
        'values': [
          {
            'title': "ListTextInputAlertPage",
            'content': '多输入框的弹窗视图显示测试',
            // 'nextPageName': "ListTextInputAlertPage",
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
