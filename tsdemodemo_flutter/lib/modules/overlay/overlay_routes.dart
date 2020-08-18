import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/overlay_view_routes.dart';
import 'package:tsdemodemo_flutter/modules/overlay/overlay_main_page.dart';

// overlay 的 Util 测试
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayUtil/overlay_util_home_page.dart';


// overlay 的 View 测试
class OverlayAllRouters {
  // overlay 的测试
  static const overlayMainPage = '/overlay_view_main_page';

  static Map<String, WidgetBuilder> routes = OverlayAllRouters.getRoutes();

  static Map<String, WidgetBuilder> getRoutes() {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      OverlayAllRouters.overlayMainPage: (BuildContext context) =>
          TSOverlayMainPage(),
    });
    routes.addAll(OverlayViewRouters.routes);

    return routes;
  }
}




class OverlayUtilRouters {
  // overlay 的 Util 测试
  static const overlayUtilHomePage = '/overlay_util_home_page';
  static const messageAlertUtilPage = '/message_alert_util_page';

  static Map<String, WidgetBuilder> routes = {
    // overlay 的 Util 测试
    OverlayUtilRouters.overlayUtilHomePage: (BuildContext context) =>
        TSOverlayUtilHomePage(),
  };
}

