/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:19:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:31:37
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Info on WebViewController {
  /// 获取app的公共信息，并将返回值回调给 h5
  cjjs_getFixedAppInfo({
    required Future<Map<String, dynamic>> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_getFixedAppInfo',
      onMessageReceived: (JavaScriptMessage message) async {
        Map map = json.decode(message.message.toString());
        String jsMethodName = map["callbackMethod"];

        Map<String, dynamic> callbackMap = await callbackMapGetBlock();

        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }

  /// 获取埋点monitor的公共信息，并将返回值回调给 h5
  cjjs_getFixedMonitorInfo({
    required Future<Map<String, dynamic>> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_getFixedMonitorInfo',
      onMessageReceived: (JavaScriptMessage message) async {
        Map map = json.decode(message.message.toString());
        String jsMethodName = map["callbackMethod"];

        Map<String, dynamic> callbackMap = await callbackMapGetBlock();
        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }

  /// 获取用户token(用于安全的告知h5用户信息)，并将返回值回调给 h5
  cjjs_getCurrentUserToken({
    required Future<String> Function() getCurrentUserToken,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_getCurrentUserToken',
      onMessageReceived: (JavaScriptMessage message) async {
        Map map = json.decode(message.message.toString());
        String jsMethodName = map["callbackMethod"];

        String? userToken = await getCurrentUserToken();
        Map<String, dynamic> callbackMap = {
          "userToken": userToken,
        };
        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }
}
