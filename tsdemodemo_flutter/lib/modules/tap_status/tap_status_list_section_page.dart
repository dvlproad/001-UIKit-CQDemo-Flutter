/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-20 18:47:40
 * @Description: 测试在长页面里点击状态栏能够返回到页面的顶部
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TapStatusListSectionPage extends StatefulWidget {
  const TapStatusListSectionPage({Key key}) : super(key: key);

  @override
  State<TapStatusListSectionPage> createState() =>
      _TapStatusListSectionPageState();
}

class _TapStatusListSectionPageState extends State<TapStatusListSectionPage> {
  @override
  Widget build(BuildContext context) {
    var values = [];
    for (var i = 0; i < 200; i++) {
      values.add({
        'title': "Button(按钮)",
        // 'nextPageName': BaseUIKitRouters.buttonHomePage,
      });
    }

    var sectionModels = [
      {'theme': "组件", 'values': values},
    ];

    // return Scaffold(
    //   body: CJTSSectionTableView(
    //     context: context,
    //     sectionModels: sectionModels,
    //   ),
    // );

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
