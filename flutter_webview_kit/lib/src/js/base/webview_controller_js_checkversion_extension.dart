// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:36:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 11:22:23
 * @Description: 
 */

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_CheckVersion on WebViewController {
  /// 检查更新
  cjjs_checkVersion({
    required WebViewController? Function() webViewControllerGetBlock,
    required Future<void> Function({
      required bool isManualCheck,
      required String callOwner,
    })
        checkVersion,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_checkVersion',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        bool isManualCheck = h5Params?["isManualCheck"] ?? true;
        String callOwner = h5Params?["callOwner"] ?? "h5";

        checkVersion(
          isManualCheck: isManualCheck,
          callOwner: callOwner,
        ).then((value) {
          String? jsMethodName = h5Params?["callbackMethod"];

          WebViewController? webViewController = webViewControllerGetBlock();
          if (jsMethodName != null) {
            Map<String, dynamic> callbackMap = {
              // "userToken": userToken,
            };
            webViewController?.cj_runJsMethodWithParamMap(
              jsMethodName,
              params: callbackMap,
            );
          }
        });
      },
    );
  }
}
