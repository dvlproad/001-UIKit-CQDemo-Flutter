import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/TSAlertViewHomePage.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/TSAlertView1_MessageAlertPage.dart';

class OverlayRouters {
  // overlay的测试首页
  static const overlayHomePage = '/overlay_home_page';
  static const messageAlertPage = '/message_alert_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayRouters.overlayHomePage: (BuildContext context) =>
        TSAlertViewHomePage(),
    OverlayRouters.messageAlertPage: (BuildContext context) =>
        TSAlertView1_MessageAlertPage(),
  };
}
