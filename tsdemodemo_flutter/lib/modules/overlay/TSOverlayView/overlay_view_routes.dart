// overlay 的 View 测试

import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/OverlayViewHomePage.dart';

import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/TSAlertViewHomePage.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/TSAlertView1_MessageAlertPage.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/TSAlertView3_TextInputAlertPage.dart';

class OverlayViewRouters {
  static const overlayViewHomePage = '/overlay_view_home_page';
  // alert
  static const alertViewHomePage = '/alert_view_home_page';
  static const messageAlertViewPage = '/message_alert_view_page';
  static const listMessageAlertViewPage = '/list_message_alert_view_page';
  static const textInputAlertViewPage = '/textInput_alert_view_page';
  static const listTextInputAlertViewPage = '/list_textInput_view_page';


  static Map<String, WidgetBuilder> routes = {
    OverlayViewRouters.overlayViewHomePage: (BuildContext context) =>
        OverlayViewHomePage(),
    OverlayViewRouters.alertViewHomePage: (BuildContext context) =>
        TSAlertViewHomePage(),
    OverlayViewRouters.messageAlertViewPage: (BuildContext context) =>
        TSAlertView1_MessageAlertPage(),
    OverlayViewRouters.textInputAlertViewPage: (BuildContext context) =>
        TSAlertView3_TextInputAlertPage(),
  };
}
