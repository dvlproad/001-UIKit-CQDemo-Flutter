/*
 * @Author: dvlproad
 * @Date: 2022-04-20 18:53:09
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 16:18:38
 * @Description: 
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './baseui_routes.dart';

class TSBaseUIHomePage extends CJTSBasePage {
  final String? title;

  TSBaseUIHomePage({Key? key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSBaseUIHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'BaseUI首页'),
    );
  }

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "组件",
        'values': [
          {
            'title': "Button(按钮)",
            'nextPageName': BaseUIKitRouters.buttonHomePage,
          },
          {
            'title': "Image(图片)",
            'nextPageName': BaseUIKitRouters.imageviewHomePage,
          },
          {
            'title': "TextFiled(文本框)",
            'nextPageName': BaseUIKitRouters.textFieldHomePage,
          },
          {
            'title': "TextView(文本框多行)",
            'nextPageName': BaseUIKitRouters.textViewHomePage,
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
