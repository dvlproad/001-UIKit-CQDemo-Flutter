// overlay 的 所有(View+Action+Util) 测试
import 'package:flutter/widgets.dart';
import './overlay_main_page.dart';
import './TSOverlayView/overlay_view_routes.dart'; // view
import './TSOverlayAction/overlay_action_routes.dart'; //action
import './TSOverlayUtil/overlay_util_routes.dart'; // util

class OverlayAllRouters {
  static const overlayMainPage = '/overlay_view_main_page';

  static Map<String, WidgetBuilder> routes = OverlayAllRouters.getRoutes();

  static Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      OverlayAllRouters.overlayMainPage: (BuildContext context) =>
          TSOverlayMainPage(),
    });
    // 添加 view 测试
    routes.addAll(OverlayViewRouters.routes);

    // 添加 action 测试
    routes.addAll(OverlayActionRouters.routes);

    // 添加 util 测试
    routes.addAll(OverlayUtilRouters.routes);

    return routes;
  }
}
