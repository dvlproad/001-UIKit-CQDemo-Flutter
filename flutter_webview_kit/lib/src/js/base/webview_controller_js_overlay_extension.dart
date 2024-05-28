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
  /// 显示app的 toast 样式
  cjjs_showAppToast({
    required void Function(String message) showToastHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_showAppToast',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        final String? msg = h5Params?["message"];
        if (msg == null || msg.isEmpty) {
          return;
        }
        showToastHandle(msg);
      },
    );
  }

  /// 显示app的 alert 样式(bizType用于区分业务类型)
  cjjs_showAppAlert({
    required void Function(String? title, String? message, {String? bizType})
        showAlertHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_showAppAlert',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        final String? title = h5Params?["title"];
        final String? message = h5Params?["message"];
        final String? bizType = h5Params?["bizType"];
        showAlertHandle(title, message, bizType: bizType);
      },
    );
  }

  /// 显示app的 hud 样式(bizType用于区分业务类型)
  cjjs_showAppHud({
    required void Function(bool show, bool onlyContext) showHudHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_showAppHud',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        final bool show = h5Params?["show"] ?? false; // true显示、false关闭
        final bool onlyContext =
            h5Params?["onlyContext"] ?? false; // 是否只在context中显示
        showHudHandle(show, onlyContext);
      },
    );
  }
}
