// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-23 13:41:22
 * @Description: 
 */
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
// test
import './test/webview_controller_js_test_extension.dart';
// base
import './base/webview_controller_js_info_extension.dart';
import './base/webview_controller_js_info_hardware_extension.dart';
import './base/webview_controller_js_overlay_extension.dart';
import './base/webview_controller_js_route_extension.dart';
import './base/webview_controller_js_checkversion_extension.dart';
import './base/webview_controller_js_logout_extension.dart';
import './base/webview_controller_js_ui_extension.dart';
// import './base/webview_controller_js_info_share_extension.dart';

// business 直接在 app 中设置
// import './business/webview_controller_js_auth_extension.dart';
// import './business/webview_controller_js_pay_extension.dart';
// import './business/webview_controller_js_picker_extension.dart';
// import './business/webview_controller_js_share_extension.dart';

import './other/webview_controller_js_webview_extension.dart';

/// 添加JSChannel
extension AddJSChannel_CJBase on WebViewController {
  // test
  cjjs_test({
    // 关闭当前 web 以返回到原生页面，并打开浏览器用于测试浏览器上的链接能否直接打开app
    required void Function() beforeGoBrowserCloseWebviewHandle,
    // 离开app，打开浏览器前在app上的停留时间
    required Duration beforeGoBrowserNeedWaitDuration,
    required Future Function(String errorMessage) openBrowserErrorHandle,
    required void Function(String? message) showMessageHandle,
    required dynamic Function() callbackResultGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cjjs_test_openBrowser(
      closeWebviewHandle: beforeGoBrowserCloseWebviewHandle,
      beforeGoBrowserNeedWaitDuration: beforeGoBrowserNeedWaitDuration,
      errorHandle: openBrowserErrorHandle,
    );
    cjjs_test_h5CallAppAndCallBackToH5(
      showMessageHandle: showMessageHandle,
      callbackResultGetBlock: callbackResultGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
  }

  // base
  cjjs_base({
    required BuildContext? Function() contextGetBlock,
    required void Function()? closeWebViewHandle, // 自定义关闭事件
    required Future<Map<String, dynamic>> Function() fixedAppInfoGetBlock,
    required Future<Map<String, dynamic>> Function() fixedMonitorInfoGetBlock,
    required String? Function() getCurrentUserToken,
    required Map<String, dynamic> Function() currentUserInfoGetBlock,
    required void Function(String message) showToastHandle,
    required void Function(String? title, String? message, {String? bizType})
        showAlertHandle,
    required void Function(bool show, bool onlyContext) showHudHandle,
    required void Function(String url) jumpAppPageUrlHandle,
    required void Function(
      String pageName, {
      Map<String, dynamic>? pageParams,
      // 进入到 app页面后，如果返回到当前页面，是否需要根据特殊参数做特殊处理。(eg: 从悬浮在window的游戏web进入app，要隐藏游戏；而从进入的页面返回时候，需要将隐藏的游戏再显示出来)
      Map<String, dynamic>? pageBackParams,
    })
        jumpAppPageNameHandle,
    required void Function(int homeIndex) backToHomeIndexHandle,
    required void Function(bool shouldHide) hidesBottomBarHandle,
    required Future<void> Function({
      required bool isManualCheck,
      required String callOwner,
    })
        checkVersion,
    required Future<bool> Function() logoutHandle,
    required Future<bool> Function(String mpPath) goMpHandle,
    required Function(SystemUiOverlayStyle systemUiOverlayStyle)
        updateAppStatusBarStyleHandle,
    required Function(bool? shouldResize) updateResizeToAvoidBottomInsetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cjjs_closeWebView(
      closeWebViewHandle: () {
        if (closeWebViewHandle != null) {
          closeWebViewHandle();
          return;
        }

        BuildContext? context = contextGetBlock();
        if (context == null) {
          return;
        }
        bool canPop = Navigator.canPop(context);
        if (canPop) {
          Navigator.pop(context); // 🚑：请先判断，避免白屏
        } else {
          showToastHandle(
              "调用 h5CallBridgeAction_closeWebView 关闭网页失败。不能无脑执行 Navigator.pop(context); 否则会出现白屏");
          // controller.goBack();
          // Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
    );
    cjjs_getFixedAppInfo(
      callbackMapGetBlock: fixedAppInfoGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_getFixedMonitorInfo(
      callbackMapGetBlock: fixedMonitorInfoGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_getCurrentUserToken(
      getCurrentUserToken: getCurrentUserToken,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_getCurrentUserInfo(
      callbackMapGetBlock: currentUserInfoGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );

    cjjs_showAppToast(showToastHandle: showToastHandle);
    cjjs_showAppAlert(showAlertHandle: showAlertHandle);
    cjjs_showAppHud(showHudHandle: showHudHandle);

    cjjs_jumpAppPageUrl(resultHandle: jumpAppPageUrlHandle);
    cjjs_jumpAppPageName(resultHandle: jumpAppPageNameHandle);
    cjjs_backToHomeIndex(resultHandle: backToHomeIndexHandle);
    cjjs_hidesBottomBarWhenPushed(
      webViewControllerGetBlock: webViewControllerGetBlock,
      hidesBottomBarHandle: hidesBottomBarHandle,
    );
    cjjs_checkVersion(
      checkVersion: checkVersion,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_logout(logoutHandle: logoutHandle);
    cjjs_launchWeChatMiniProgram(
      goMpHandle: goMpHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );

    cjjs_updateAppStatusBarStyle(callBack: updateAppStatusBarStyleHandle);
    cjjs_updateResizeToAvoidBottomInset(
      callBack: updateResizeToAvoidBottomInsetHandle,
    );
  }

  // ui
  cjjs_ui({
    required BuildContext? Function() contextGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
    required Future<String> Function()?
        platformDescriptionGetBlock, // 补充获取平台描述含①系统名称(iOS、Android等）、②是否有底部标签栏，避免h5提供的日志未说明设备环境
  }) {
    cjjs_getScreenInfo(
      contextGetBlock: contextGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
      platformDescriptionGetBlock: () async {
        if (platformDescriptionGetBlock != null) {
          return await platformDescriptionGetBlock();
        }
        String des = Platform.operatingSystem;
        des += "(${Platform.operatingSystemVersion})";
        return des;
      },
    );
  }

  // hardware
  cjjs_hardware({
    required void Function() openAppSettingsHandle,
    // required Future<Map<String, dynamic>> Function(bool? needFullAccuracy) userLocationInfoGetBlock,
    required void Function(bool? needFullAccuracy, String callbackJSMethodName)
        getUserLocationInfoHandle,
  }) {
    cjjs_openAppSettings(openAppSettingsHandle: openAppSettingsHandle);
    cjjs_getUserLocationInfo(
      getUserLocationInfoHandle: getUserLocationInfoHandle,
    );
  }
}
