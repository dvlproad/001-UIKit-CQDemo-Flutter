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
  /// 发送 webview 页面是否显示的状态
  cj_sendWebviewShowState(bool isShow) async {
    cj_runJsMethodWithParamMap(
      '__on_did_change_webview_show_state',
      params: {
        "isShow": isShow,
      },
    );
  }

  /// 发送app生命周期状态（不能用此状态来判断页面是否显示）
  cj_sendAppLifecycleState(AppLifecycleState state) async {
    String stateString;
    String stateDescription;
    // [Flutter的应用生命周期状态（lifecycleState）管理](https://blog.csdn.net/qq_28550263/article/details/134127670)
    switch (state) {
      case AppLifecycleState.inactive:
        stateString = 'inactive';
        stateDescription = '非活动状态：仍然位于前台，但不能响应用户交互。【执行一些暂停操作，例如停止定时器或保存应用程序状态】';
        break;
      case AppLifecycleState.paused:
        stateString = 'paused';
        stateDescription = '从前台进入后台/设备锁屏或进入睡眠模式';
        break;
      case AppLifecycleState.resumed:
        stateString = 'resumed';
        stateDescription = '从后台返回到前台并可见时';
        break;
      case AppLifecycleState.detached:
        stateString = 'detached';
        stateDescription = '分离状态：表示应用程序尚未启动或已经被销毁';
        break;
      default:
        stateString = state.toString().split('.').last;
        stateDescription = '';
        break;
    }

    cj_runJsMethodWithParamMap(
      '__on_did_change_app_lifecycle_state',
      params: {
        "state": stateString,
        "stateDescription": stateDescription,
      },
    );
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
