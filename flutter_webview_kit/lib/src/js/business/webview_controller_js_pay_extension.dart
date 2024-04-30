/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:48:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:37:37
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Pay on WebViewController {
  /// 调起微信小程序到微信
  cjjs_pay({
    required Future<bool> Function({
      required String payType,
      required Map<String, dynamic> argsFromH5,
    })
        payHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_pay',
      onMessageReceived: (JavaScriptMessage message) async {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }

        Map<String, dynamic> jsCallbackMap = JSResponseModel.initMap();
        String? payType = map['payType'];
        if (payType == null || payType.isEmpty) {
          jsCallbackMap = JSResponseModel.errorMap(message: '缺少 payType 参数');
        } else {
          bool isSuccess = await payHandle(payType: payType, argsFromH5: map);
          jsCallbackMap = JSResponseModel.successMap(isSuccess: isSuccess);
        }

        String? jsMethodName = map["callbackMethod"];
        if (jsMethodName == null) {
          WebViewController? webViewController = webViewControllerGetBlock();
          webViewController?.cj_runJsMethodWithParamMap(
            jsMethodName!,
            params: jsCallbackMap,
          );
        }
      },
    );
  }
}
