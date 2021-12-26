// overlay 的 Util 测试
import 'package:flutter/widgets.dart';
import './overlay_util_home_page.dart';
// toast
import './ts_toast_home_page.dart';
// alert
import './alet_util_home_page.dart';
import './TSAlertUtil1_MessageAlertPage.dart';
// actionsheet
import './ts_actionsheet_home_page.dart';

class OverlayUtilRouters {
  static const overlayUtilHomePage = '/overlay_util_home_page';
  // toasst
  static const toastUtilHomePage = '/toast_util_home_page';
  // alert
  static const alertUtilHomePage = '/alert_util_home_page';
  static const messageAlertUtilPage = '/message_alert_util_page';
  // actionsheet
  static const actionsheetUtilHomePage = '/actionsheet_util_home_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayUtilRouters.overlayUtilHomePage: (BuildContext context) =>
        TSOverlayUtilHomePage(),
    // toast
    OverlayUtilRouters.toastUtilHomePage: (BuildContext context) =>
        TSToastHomePage(),
    // alert
    OverlayUtilRouters.alertUtilHomePage: (BuildContext context) =>
        TSAlertUtilHomePage(),
    OverlayUtilRouters.messageAlertUtilPage: (BuildContext context) =>
        TSMessageAlertViewPage(),
    // actionsheet
    OverlayUtilRouters.actionsheetUtilHomePage: (BuildContext context) =>
        TSActionSheetHomePage(),
  };
}
