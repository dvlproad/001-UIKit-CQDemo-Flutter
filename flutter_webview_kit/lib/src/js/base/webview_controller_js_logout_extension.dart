/*
 * @Author: dvlproad
 * @Date: 2024-05-10 15:30:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-31 17:53:58
 * @Description: 用户的登录、登出、绑定微信登操作
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Logout on WebViewController {
  /// 退出（会自动并进入到登录界面）
  cjjs_logout({
    required Future<bool> Function() logoutHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_logout',
      onMessageReceived: (JavaScriptMessage message) {
        logoutHandle();
      },
    );
  }

  // /// 进入到绑定微信界面（暂时没发现会有此场景）
  // cjjs_bindWechat({
  //   required Future<bool> Function() bindWechatHandle,
  // }) {
  //   cj_addJavaScriptChannel(
  //     'h5CallBridgeAction_bindWechat',
  //     onMessageReceived: (JavaScriptMessage message) {
  //       bindWechatHandle();
  //     },
  //   );
  // }
}
