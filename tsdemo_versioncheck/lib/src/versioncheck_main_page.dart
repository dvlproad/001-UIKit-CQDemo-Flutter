/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 16:38:08
 * @Description: 
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TSVersionCheckMainPage extends CJTSBaseTabBarPage {
  TSVersionCheckMainPage({
    Key? key,
    List<dynamic>? tabbarModels,
  }) : super(
          key: key,
          tabbarModels: tabbarModels,
        );

  @override
//  _TSTSVersionCheckMainPageState createState() => _TSTSVersionCheckMainPageState();
  CJTSBaseTabBarPageState getState() => _TSTSVersionCheckMainPageState();
}

class _TSTSVersionCheckMainPageState
    extends CJTSBaseTabBarPageState<TSVersionCheckMainPage> {
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
