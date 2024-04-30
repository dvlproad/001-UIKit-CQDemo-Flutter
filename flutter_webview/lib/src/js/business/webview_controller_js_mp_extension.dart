// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:19:02
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:37:14
 * @Description: 
 */
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_MiniProgram on WebViewController {
  /// 调起小程序(执行支付等)
  cjjs_callWeChatMiniProgram({
    required Future<bool> Function(String mpPath) goMpHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_callWechatMP',
      onMessageReceived: (JavaScriptMessage message) async {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }

        Map<String, dynamic> jsCallbackMap = JSResponseModel.initMap();
        if (map['path'] == null || map['path'].isEmpty) {
          jsCallbackMap = JSResponseModel.errorMap(message: '缺少 path 参数');
        } else {
          String path = map['path'];
          bool isSuccess = await goMpHandle(path);
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
