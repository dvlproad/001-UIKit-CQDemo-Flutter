// overlay 的 Util 测试
import 'package:flutter/widgets.dart';
import './TSOverlayUtil/overlay_util_home_page.dart';

class OverlayUtilRouters {
  static const overlayUtilHomePage = '/overlay_util_home_page';
  static const messageAlertUtilPage = '/message_alert_util_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayUtilRouters.overlayUtilHomePage: (BuildContext context) =>
        TSOverlayUtilHomePage(),
  };
}
