import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './page/ts_cache_home_page.dart';

class TSCacheMainPage extends CJTSBaseTabBarPage {
  TSCacheMainPage({Key key}) : super(key: key);

  @override
//  _TSCacheMainPageState createState() => _TSCacheMainPageState();
  CJTSBaseTabBarPageState getState() => _TSCacheMainPageState();
}

class _TSCacheMainPageState extends CJTSBaseTabBarPageState<TSCacheMainPage> {
  @override
  List<dynamic> get tabbarModels {
    List<dynamic> tabbarModels = [
      {
        'title': "shared_preferences",
        'nextPage': TSCacheHomePage(),
      },
      {
        'title': "xxx(wu）",
        'nextPage': TSCacheHomePage(),
      },
      {
        'title': "sqlite(wu）",
        'nextPage': TSCacheHomePage(),
      },
    ];

    return tabbarModels;
  }
}
