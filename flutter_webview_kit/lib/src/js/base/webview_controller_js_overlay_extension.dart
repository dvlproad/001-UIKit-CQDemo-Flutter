// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:42:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:35:22
 * @Description: 
 */
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Overlay on WebViewController {
  /// 显示app的toast样式
  cjjs_showAppToast({
    required Future<void> Function(String message) resultHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_showAppToast',
      onMessageReceived: (JavaScriptMessage message) {
        Map map = json.decode(message.message.toString());
        final String? msg = map["message"];
        if (msg == null || msg.isEmpty) {
          return;
        }
        resultHandle(msg);
      },
    );
  }
}
