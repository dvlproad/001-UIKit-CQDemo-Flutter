import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './page/ts_network_home_page.dart';

class TSNetworkMainPage extends CJTSBaseTabBarPage {
  TSNetworkMainPage({Key key}) : super(key: key);

  @override
//  _TSNetworkMainPageState createState() => _TSNetworkMainPageState();
  CJTSBaseTabBarPageState getState() => _TSNetworkMainPageState();
}

class _TSNetworkMainPageState
    extends CJTSBaseTabBarPageState<TSNetworkMainPage> {
  @override
  List<dynamic> get tabbarModels {
    List<dynamic> tabbarModels = [
      {
        'title': "Network",
        'nextPage': TSNetworkHomePage(),
      },
      {
        'title': "Network(wu）",
        'nextPage': TSNetworkHomePage(),
      },
      {
        'title': "Network(wu）",
        'nextPage': TSNetworkHomePage(),
      },
    ];

    return tabbarModels;
  }
}
