/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:19:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 11:14:48
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_Info on WebViewController {
  /// 获取app的公共信息，并将返回值回调给 h5
  cjjs_getFixedAppInfo({
    required Future<Map<String, dynamic>> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_getFixedAppInfo',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        Map<String, dynamic> callbackMap = await callbackMapGetBlock();
        return JSResponseModel.success(isSuccess: true, result: callbackMap);
      },
    );
  }

  /// 获取埋点monitor的公共信息，并将返回值回调给 h5
  cjjs_getFixedMonitorInfo({
    required Future<Map<String, dynamic>> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_getFixedMonitorInfo',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        Map<String, dynamic> callbackMap = await callbackMapGetBlock();
        return JSResponseModel.success(isSuccess: true, result: callbackMap);
      },
    );
  }

  /// 获取用户token(用于安全的告知h5用户信息)，并将返回值回调给 h5
  cjjs_getCurrentUserToken({
    required String? Function() getCurrentUserToken,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_getCurrentUserToken',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        String? userToken = getCurrentUserToken();
        Map<String, dynamic> callbackMap = {
          "userToken": userToken,
        };
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }

  /// 获取用户信息(常见场景:H5点击用户头像，需要对主态和客态做不同操作时候使用)，并将返回值回调给 h5
  cjjs_getCurrentUserInfo({
    required Map<String, dynamic> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_getCurrentUserInfo',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        Map<String, dynamic> callbackMap = callbackMapGetBlock();
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }
}
