import 'package:flutter/widgets.dart';
import './cache_main_page.dart';
import './page/ts_cache_home_page.dart';

class CacheAllRouters {
  static const cacheMainPage = '/cache_main_page';
  static const cacheHomePage = '/cache_home_page';

  static Map<String, WidgetBuilder> routes = CacheAllRouters.getRoutes();

  static Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      CacheAllRouters.cacheMainPage: (BuildContext context) =>
          TSCacheMainPage(),
    });
    // 添加 page 测试
    routes.addAll({
      CacheAllRouters.cacheHomePage: (BuildContext context) =>
          TSCacheHomePage(),
    });

    return routes;
  }
}
