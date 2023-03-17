/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 14:19:14
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_util_routes.dart';

class TSOverlayUtilHomePage extends CJTSBasePage {
  TSOverlayUtilHomePage({Key? key}) : super(key: key);

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
    String imageSource =
        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3460118221,780234760&fm=26&gp=0.jpg';

    sectionModels = [
      {
        'theme': "Util",
        'values': [
          {
            'title': "Toast(Util)",
            'imageSource': imageSource,
            'nextPageName': OverlayUtilRouters.toastUtilHomePage,
          },
          {
            'title': "Alert(Util)",
            'imageSource': imageSource,
            'nextPageName': OverlayUtilRouters.alertUtilHomePage,
          },
          {
            'title': "ActionSheet(Util)",
            'imageSource': imageSource,
            'nextPageName': OverlayUtilRouters.actionsheetUtilHomePage,
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
