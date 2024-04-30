// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:12:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 12:23:02
 * @Description: 
 */
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Auth on WebViewController {
  ///实人认证
  cjjs_authRealName({
    required Future<Map<String, dynamic>?> Function({
      required String certName,
      required String certNo,
    })
        resultMapGetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_realPersonAuthentication',
      onMessageReceived: (JavaScriptMessage message) async {
        Map map = json.decode(message.message.toString());

        String certName = map['certName'] ?? "";
        String certNo = map['certNo'] ?? "";

        String jsMethodName = map["callbackMethod"];

        Map<String, dynamic>? callbackMap = await resultMapGetHandle(
          certNo: certNo,
          certName: certName,
        );
        if (callbackMap == null) {
          return;
        }

        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }
}
