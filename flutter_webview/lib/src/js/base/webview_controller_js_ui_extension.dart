// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:45:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 10:31:04
 * @Description: 
 */
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_UI on WebViewController {
  /// 更新状态栏颜色
  cjjs_updateAppStatusBarStyle({
    required Function(SystemUiOverlayStyle systemUiOverlayStyle) callBack,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_updateAppStatusBarStyle',
      onMessageReceived: (JavaScriptMessage message) {
        Map map = json.decode(message.message.toString());

        if (map["statusBarColor"] == "light") {
          callBack(SystemUiOverlayStyle.light);
        } else {
          callBack(SystemUiOverlayStyle.dark);
        }
      },
    );
  }

  /// 更新键盘弹出时候是否自动调整页面大小
  cjjs_updateResizeToAvoidBottomInset({
    required Function(bool? shouldResize) callBack,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_updateResizeToAvoidBottomInset',
      onMessageReceived: (JavaScriptMessage message) {
        Map map = json.decode(message.message.toString());

        bool? shouldResize = map["shouldResizeToAvoidBottomInset"];
        callBack(shouldResize);
      },
    );
  }

  /*
  /// 获取键盘变化高度，并回调给h5
  cjjs_getCurrentKeyboardHeight({
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_getCurrentKeyboardHeight',
      onMessageReceived: (JavaScriptMessage message) async {
        Map map = json.decode(message.message.toString());
        String jsMethodName = map["callbackMethod"];
        Map callbackMap = {
          "keyboardHeight": 123,
        };
        WebViewController? webViewController = webViewControllerGetBlock();
        webViewController?.cj_runJsMethodWithParamMap(
          jsMethodName,
          params: callbackMap,
        );
      },
    );
  }
  */
}
