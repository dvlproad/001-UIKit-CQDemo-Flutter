/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:16:43
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_view_routes.dart';

class OverlayViewHomePage extends CJTSBasePage {
  OverlayViewHomePage({Key? key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<OverlayViewHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay View 首页'),
    );
  }

  @override
  Widget contentWidget() {
    String imageSource =
        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3460118221,780234760&fm=26&gp=0.jpg';

    sectionModels = [
      {
        'theme': "单条信息的弹窗视图",
        'values': [
          {
            'title': "MessageAlertPage",
            'content': '单条信息的弹窗视图显示测试',
            'nextPageName': OverlayViewRouters.messageAlertViewPage,
          },
          {
            'title': "Toast(View)-暂无",
            'imageSource': imageSource,
            // 'nextPageName': "ToastHomePage1"
          },
          {
            'title': "ActionSheet(View)",
            'imageSource': imageSource,
            // 'nextPageName': "ActionSheetHomePage1"
          },
          {
            'title': "Alert(View)",
            'imageSource': imageSource,
            'nextPageName': OverlayViewRouters.alertViewHomePage,
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
