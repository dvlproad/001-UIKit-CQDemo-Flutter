// overlay 的 Util 测试
import 'package:flutter/widgets.dart';
import './overlay_util_home_page.dart';
import './TSAlertUtil1_MessageAlertPage.dart';

class OverlayUtilRouters {
  static const overlayUtilHomePage = '/overlay_util_home_page';
  static const messageAlertUtilPage = '/message_alert_util_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayUtilRouters.overlayUtilHomePage: (BuildContext context) =>
        TSOverlayUtilHomePage(),
    OverlayUtilRouters.messageAlertUtilPage: (BuildContext context) =>
        TSMessageAlertViewPage(),
  };
}
