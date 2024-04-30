// ignore_for_file: non_constant_identifier_names, camel_case_extensions

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Logout on WebViewController {
  /// 登出
  cjjs_logout({
    required Future<bool> Function() logoutHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_logout',
      onMessageReceived: (JavaScriptMessage message) {
        logoutHandle();
      },
    );
  }
}
