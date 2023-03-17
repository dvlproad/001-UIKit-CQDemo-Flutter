/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 16:39:00
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'pgyer_action_routes.dart';

class TSPgyerHomePage extends CJTSBasePage {
  final String? title;

  TSPgyerHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSPgyerHomePage> {
  var sectionModels = [];

  @override
  void dispose() {
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
        'theme': "Version Check",
        'values': [
          {
            'title': "Overlay.of(context).insert(overlayEntry1);",
            'content': 'Overlay的弹出',
            'actionBlock': () {
              // OverlayActionUtil.show(context);
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
