import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/overlay/overlay_home_page.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TS221MessageAlertPage.dart';

class OverlayRouters {
  // overlay的测试首页
  static const overlayHomePage = '/overlay_home_page';
  static const messageAlertPage = '/message_alert_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayRouters.overlayHomePage: (BuildContext context) =>
        TSOverlayHomePage(),
    OverlayRouters.messageAlertPage: (BuildContext context) =>
        TSMessageAlertPage(),
  };
}
