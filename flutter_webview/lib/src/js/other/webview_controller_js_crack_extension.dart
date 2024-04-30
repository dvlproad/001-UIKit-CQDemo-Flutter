/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:59:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:30:56
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Crack on WebViewController {
  /// 是否是模拟器
  cjjs_isRunningOnSimulator({
    required Future<Map<String, dynamic>> Function()
        checkSimulatorResultMapGetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_isSimulator',
      onMessageReceived: (JavaScriptMessage message) async {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }
        String jsMethodName = map["callbackMethod"];

        Map<String, dynamic> callbackMap =
            await checkSimulatorResultMapGetHandle();
        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }
}
