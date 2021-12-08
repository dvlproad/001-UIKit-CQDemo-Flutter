import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

import './TSOverlayView/OverlayViewHomePage.dart';
import './TSOverlayAction/overlay_action_home_page.dart';
import './TSOverlayUtil/overlay_util_home_page.dart';

class TSOverlayMainPage extends CJTSBaseTabBarPage {
  TSOverlayMainPage({Key key}) : super(key: key);

  @override
//  _TSOverlayMainPageState createState() => _TSOverlayMainPageState();
  CJTSBaseTabBarPageState getState() => _TSOverlayMainPageState();
}

class _TSOverlayMainPageState
    extends CJTSBaseTabBarPageState<TSOverlayMainPage> {
  @override
  List<dynamic> get tabbarModels {
    List<dynamic> tabbarModels = [
      {
        'title': "OverlayView",
        'nextPage': OverlayViewHomePage(),
      },
      {
        'title': "OverlayAction",
        'nextPage': TSOverlayActionHomePage(),
      },
      {
        'title': "OverlayUtil",
        'nextPage': TSOverlayUtilHomePage(),
      },
    ];

    return tabbarModels;
  }
}
