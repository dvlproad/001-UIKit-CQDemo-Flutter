// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-27 01:44:59
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-28 16:24:28
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:webview_flutter/webview_flutter.dart';

import '../js_add_check_run/webview_controller_add_check_run_js.dart';

//webView的方法
extension AppCallH5JSExtension on WebViewController {
  /// 发送app生命周期状态
  cj_sendAppLifecycleState(AppLifecycleState state) async {
    String stateString = _getAppLifecycleStateString(state);
    cj_runJsMethodWithParamString(
      '__on_did_change_app_lifecycle_state',
      jsParamJsonString: stateString,
    );
  }

  String _getAppLifecycleStateString(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        return 'inactive';
      case AppLifecycleState.paused:
        return 'paused';
      case AppLifecycleState.resumed:
        return 'resumed';
      case AppLifecycleState.detached:
        return 'detached';
      default:
        return state.toString().split('.').last;
    }
  }

  /// 更新 键盘显示隐藏及高度变化
  cj_sendKeyboardHeight(double keyboardHeight) async {
    cj_runJsMethodWithParamMap(
      '__on_did_change_keyboard_height',
      params: {
        'keyboardHeight': keyboardHeight,
      },
    );
  }

  /*
  /// 更新 用户登录状态变化(浏览app页面时状态变化会直接退到登录页，浏览h5页面时状态变化调用 logout 的js方法也会退到登录页，所以不需要上报此状态)
  cj_sendUserLoginState(bool isLogin) async {
    cj_runJsMethodWithParamMap(
      '__on_did_change_user_login_state',
      params: {
        'isLogin': isLogin,
      },
    );
  }
  */
}
