/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 23:50:30
 * @Description: 
 */
// overlay 的 所有(View+Action+Util) 测试
import 'package:flutter/widgets.dart';
import './versioncheck_main_page.dart';

import './pgyer_service/pgyer_action_routes.dart';
import './custom_service/custom_service_routes.dart';

class VersionCheckAllRouters {
  static const versionCheckMainPage = '/versioncheck_view_main_page';

  static Map<String, WidgetBuilder> routes = getRoutes();

  static Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      VersionCheckAllRouters.versionCheckMainPage: (BuildContext context) =>
          TSVersionCheckMainPage(),
    });
    // pgyer
    routes.addAll(PgyerRouters.routes);

    // 添加 custom service 测试
    routes.addAll(CustomServiceRouters.routes);

    return routes;
  }
}
