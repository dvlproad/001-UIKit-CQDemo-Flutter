/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 02:09:14
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

import 'package:app_updateversion_kit/app_updateversion_kit.dart';
import 'pgyer_action_routes.dart';

class TSPgyerHomePage extends CJTSBasePage {
  TSPgyerHomePage({Key? key}) : super(key: key);

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
      title: Text('Pagyer 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Version Check",
        'values': [
          {
            'title': "蒲公英上的版本检查",
            'content': '版本检查',
            'actionBlock': () {
              _manualCheckVersion();
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

  _manualCheckVersion() {
    // LoadingUtil.showInContext(context);
    // Future.delayed(Duration(milliseconds: 3000)).then((value) {
    //   LoadingUtil.dismissInContext(context);
    // });
    CheckVersionUtil.checkVersion(
      isManualCheck: true,
    ).then((value) {
      // LoadingUtil.dismissInContext(context);
    }).catchError((onError) {
      // LoadingUtil.dismissInContext(context);
    });
  }
}
