// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:45:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:21:57
 * @Description: 
 */
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
    required Future<String> Function()
        platformDescriptionGetBlock, // 补充获取平台描述含①系统名称(iOS、Android等）、②是否有底部标签栏，避免h5提供的日志未说明设备环境
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_getScreenInfo',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
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

        // final double viewPaddingTop = mediaQueryData.viewPadding.top;
        // final double viewPaddingBottom = mediaQueryData.viewPadding.bottom;
        // callbackMap.addAll({
        //   "viewPaddingTop": viewPaddingTop,
        //   "viewPaddingBottom": viewPaddingBottom,
        // });
        // debugPrint("paddingTopBottom=${callbackMap.toString()}");

        String platformDescription = await platformDescriptionGetBlock();
        callbackMap['platformDescription'] = platformDescription;
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
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_updateAppStatusBarStyle',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        if (h5Params?["statusBarColor"] == "light") {
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
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_updateResizeToAvoidBottomInset',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        bool? shouldResize = WebUrlValueConvertUtil.boolFrom(
            h5Params?["shouldResizeToAvoidBottomInset"]);
        callBack(shouldResize);
      },
    );
  }
}

/// 参考：flutter_foundation_base 的 ValueConvertUtil
class WebUrlValueConvertUtil {
  // 将 value 转化为 string （避免后台传int）
  static String stringFrom(dynamic value) {
    if (value is String) {
      return value;
    } else if (value is int) {
      return value.toString();
    } else if (value is double) {
      return value.toString();
    } else if (value is bool) {
      return value.toString();
    } else if (value is List) {
      return value.toString();
    } else if (value is Map) {
      return value.toString();
    } else {
      return value.toString();
    }
  }

  // 将 value 转化为 bool （避免后台传 string）
  static bool? boolFrom(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is String) {
      if (value == "true") {
        return true;
      } else if (value == "false") {
        return false;
      } else {
        return null;
      }
    } else if (value is bool) {
      return value;
    } else {
      return null;
    }
  }
}
