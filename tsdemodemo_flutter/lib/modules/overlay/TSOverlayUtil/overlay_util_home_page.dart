import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';

class TSOverlayUtilHomePage extends CJTSBasePage {
  final String title;

  TSOverlayUtilHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSOverlayUtilHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay Util 首页'),
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
            'nextPageName': "MessageAlertPage"
          },
          // { 'title': "MessageAlertModalPage", 'content': '单条信息的弹窗视图弹出测试', 'nextPageName': OverlayRouters.messageAlertUtilPage },
        ]
      },
      {
        'theme': "多条信息的弹窗视图",
        'values': [
          {
            'title': "ListMessageAlertPage",
            'content': '多条信息的弹窗视图显示测试',
            'nextPageName': "ListMessageAlertPage"
          },
          // { 'title': "ListMessageAlertModalPage(待补充)", 'content': '多条信息的弹窗视图弹出测试', 'nextPageName': "ListMessageAlertModalPage" },
        ]
      },
      {
        'theme': "单输入框的弹窗视图",
        'values': [
          {
            'title': "TextInputAlertPage",
            'content': '单输入框的弹窗视图显示测试',
            'nextPageName': "TextInputAlertPage"
          },
          // { 'title': "TextInputAlertModalPage(待补充)", 'content': '单输入框的弹窗视图弹出测试', 'nextPageName': "TextInputAlertModalPage" },
        ]
      },
      {
        'theme': "多输入框的弹窗视图",
        'values': [
          {
            'title': "ListTextInputAlertPage",
            'content': '多输入框的弹窗视图显示测试',
            'nextPageName': "ListTextInputAlertPage"
          },
          // { 'title': "ListTextInputAlertModalPage(待补充)", 'content': '多输入框的弹窗视图弹出测试', 'nextPageName': "ListTextInputAlertModalPage" },
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
