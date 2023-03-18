/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 02:09:50
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

import 'package:app_updateversion_kit/app_updateversion_kit.dart';
import 'custom_service_routes.dart';

class CustomServiceHomePage extends CJTSBasePage {
  CustomServiceHomePage({Key? key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<CustomServiceHomePage> {
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
            'title': "Toast(View)-暂无",
            'imageSource': imageSource,
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
