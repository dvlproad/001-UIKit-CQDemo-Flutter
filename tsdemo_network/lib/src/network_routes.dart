import 'package:flutter/widgets.dart';
import './network_main_page.dart';
import './page/ts_network_home_page.dart';

class NetworkAllRouters {
  static const networkMainPage = '/network_main_page';
  static const networkHomePage = '/network_home_page';

  static Map<String, WidgetBuilder> routes = NetworkAllRouters.getRoutes();

  static Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      NetworkAllRouters.networkMainPage: (BuildContext context) =>
          TSNetworkMainPage(),
    });
    // 添加 page 测试
    routes.addAll({
      NetworkAllRouters.networkHomePage: (BuildContext context) =>
          TSNetworkHomePage(),
    });

    return routes;
  }
}
