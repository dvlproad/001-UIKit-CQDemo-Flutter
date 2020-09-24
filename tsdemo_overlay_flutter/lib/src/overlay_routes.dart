// overlay 的 所有(View+Util) 测试
import 'package:flutter/widgets.dart';
import './overlay_main_page.dart';
import './TSOverlayView/overlay_view_routes.dart'; // view

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

    return routes;
  }
}
