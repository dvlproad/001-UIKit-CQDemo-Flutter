/*
 * GuideOverlayTestHomePage.dart
 *
 * @Description: 引导蒙层的测试首页
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/27 17:08
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_guide_kit/src/guide_overlay_util.dart';
import './guide_routes.dart';

class GuideOverlayTestHomePage extends CJTSBasePage {
  final String title;

  GuideOverlayTestHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState
    extends CJTSBasePageState<GuideOverlayTestHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? '引导蒙层'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "导航蒙层模块",
        'values': [
          {
            'title': "Guide1(需要获取坐标的组件位于*当前组件*中)",
            'actionBlock': () {
              GuideOverlayUtil().shouldShowGuideOverlay().then((value) {
                bool shouldShowGuide = value;
                var params = {};
                // if (shouldShowGuide == true) {
                //   Navigator.pushNamed(
                //     context,
                //     Routers.guideOverlayTestPage1,
                //     arguments: params,
                //   );
                // } else {
                //   Navigator.pushNamed(
                //     context,
                //     Routers.reportUploadPage,
                //     arguments: params,
                //   );
                // }
              });
            },
            'nextPageName': GuideRouters.guideOverlayTestPage1,
          },
          {
            'title': "Guide2(需要获取坐标的组件位于*子组件*中(GlobalKey))",
            'nextPageName': GuideRouters.guideOverlayTestPage2,
          },
          {
            'title': "Guide3(需要获取坐标的组件位于*子组件*中(Key))",
            'nextPageName': GuideRouters.guideOverlayTestPage3,
          },
          {
            'title': "Guide4(需要获取坐标的组件位于*子组件*中(Key))",
            'content': '要等待子视图加载完成',
            'nextPageName': GuideRouters.guideOverlayTestPage4,
          },
        ]
      },
      {
        'theme': "导航蒙层模块2",
        'values': [
          {
            'title': "Guide5(不用获取坐标)",
            'nextPageName': GuideRouters.guideOverlayTestPage5,
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
