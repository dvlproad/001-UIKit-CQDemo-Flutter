/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:18:38
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_action_routes.dart';

import './overlay_action_util.dart';

class TSOverlayActionHomePage extends CJTSBasePage {
  final String? title;

  TSOverlayActionHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState
    extends CJTSBasePageState<TSOverlayActionHomePage> {
  var sectionModels = [];

  @override
  void dispose() {
    OverlayActionUtil.dismiss();
    super.dispose();
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay Action 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Overlay Action",
        'values': [
          {
            'title': "Overlay.of(context).insert(overlayEntry1);",
            'content': 'Overlay的弹出',
            'actionBlock': () {
              OverlayActionUtil.show(context);
            },
          },
          {
            'title': "showDialog",
            'content': 'Overlay的弹出',
            'actionBlock': () {
              OverlayActionUtil.show_showDialog(context);
            },
          },
          {
            'title': "flutter_easyloading",
            'content': 'Overlay的弹出',
            'actionBlock': () {
              OverlayActionUtil.show_flutter_easyloading();
            },
          },
          {
            'title': "本页面",
            'content': '本页面',
            'actionBlock': () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TSOverlayActionHomePage();
              }));
            },
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
