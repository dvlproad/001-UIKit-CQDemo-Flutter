import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

import 'package:flutter_network/flutter_network.dart';
import './devtool_routes.dart';

import './dev_util.dart';

import './overlay_page2.dart';
import './drag/darg_page1.dart';
import './drag/darg_page2.dart';
import './drag/log_page.dart';

class TSDevToolHomePage extends CJTSBasePage {
  final String title;

  TSDevToolHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSDevToolHomePage> {
  var sectionModels = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Dev Tool 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Dev Tool(调试工具)",
        'values': [
          {
            'title': "Environment(环境)",
            'actionBlock': () {
              DevUtil.goChangeEnvironmentNetwork(context,
                  showTestApiWidget: true);
            },
          },
          {
            'title': "ApiMock(模拟)",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              DevUtil.goChangeApiMock(context, showTestApiWidget: true);
            },
          },
          {
            'title': "Overlay",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return OverlayPage2();
              }));
            },
          },
          {
            'title': "Floating(悬浮按钮)",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DraggablePage1();
              }));
            },
          },
          {
            'title': "Floating(悬浮按钮)",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return DraggablePage2();
              }));
            },
          },
          {
            'title': "Floating logView(全部底部log视图)",
            // 'nextPageName': DevToolRouters.apiMockPage,
            'actionBlock': () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return TSLogPage();
              }));
            },
          },
          {
            'title': "显示开工工具的悬浮按钮",
            'actionBlock': () {
              DevUtil.showDevFloatingWidget(
                showTestApiWidget: true,
              );
            },
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
