// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:45:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:21:57
 * @Description: 
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_UI on WebViewController {
  /// 获取设备屏幕信息（供h5设置导航栏等位置)，并将返回值回调给 h5
  cjjs_getScreenInfo({
    required BuildContext? Function() contextGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_getScreenInfo',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        // if (h5Params?['path'] == null || h5Params?['path'].isEmpty) {
        //   return JSResponseModel.error(message: '缺少 path 参数');
        // }

        BuildContext? context = contextGetBlock();
        if (context == null) {
          return JSResponseModel.error(message: 'app自身获取 context 出错');
        }

        MediaQueryData mediaQueryData = MediaQuery.of(context);
        final double screenWidth = mediaQueryData.size.width;
        final double screenHeight = mediaQueryData.size.height;
        final double paddingTop = mediaQueryData.padding.top;
        final double paddingBottom = mediaQueryData.padding.bottom;
        Map<String, dynamic> callbackMap = {
          'screenWidth': screenWidth,
          'screenHeight': screenHeight,
          'paddingTop': paddingTop, // statusBarHeight 状态栏的高度
          'paddingBottom': paddingBottom,
        };
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }

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
}
