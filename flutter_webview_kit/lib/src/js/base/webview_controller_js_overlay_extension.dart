// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:42:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 10:57:23
 * @Description: 
 */
import 'package:webview_flutter/webview_flutter.dart';

// import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Overlay on WebViewController {
  /// 显示app的toast样式
  cjjs_showAppToast({
    required void Function(String message) resultHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_showAppToast',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        final String? msg = h5Params?["message"];
        if (msg == null || msg.isEmpty) {
          return;
        }
        resultHandle(msg);
      },
    );
  }
}
