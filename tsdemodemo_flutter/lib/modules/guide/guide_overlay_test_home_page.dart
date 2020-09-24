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
import 'package:flutter_demo_kit/tableview/CJTSSectionTableView.dart';
import 'package:flutter_demo_kit/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cq-guide-overlay/guide_overlay_util.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

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
                if (shouldShowGuide == true) {
                  Navigator.pushNamed(
                    context,
                    Routers.guideOverlayTestPage1,
                    arguments: params,
                  );
                } else {
                  Navigator.pushNamed(
                    context,
                    Routers.reportUploadPage,
                    arguments: params,
                  );
                }
              });
            },
            // 'nextPageName': Routers.guideOverlayTestPage1,
          },
          {
            'title': "Guide2(需要获取坐标的组件位于*子组件*中(GlobalKey))",
            'nextPageName': Routers.guideOverlayTestPage2,
          },
          {
            'title': "Guide3(需要获取坐标的组件位于*子组件*中(Key))",
            'nextPageName': Routers.guideOverlayTestPage3,
          },
          {
            'title': "Guide4(需要获取坐标的组件位于*子组件*中(Key))",
            'content': '要等待子视图加载完成',
            'nextPageName': Routers.guideOverlayTestPage4,
          },
        ]
      },
      {
        'theme': "导航蒙层模块2",
        'values': [
          {
            'title': "Guide5(不用获取坐标)",
            'nextPageName': Routers.guideOverlayTestPage5,
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
