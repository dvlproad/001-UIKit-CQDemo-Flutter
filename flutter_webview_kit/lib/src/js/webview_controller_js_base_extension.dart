// ignore_for_file: non_constant_identifier_names, camel_case_extensions

/*
 * @Author: dvlproad
 * @Date: 2023-01-13 18:54:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 11:16:07
 * @Description: 
 */
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

// business
import './business/webview_controller_js_auth_extension.dart';
import './business/webview_controller_js_mp_extension.dart';
import './business/webview_controller_js_pay_extension.dart';
import './business/webview_controller_js_picker_extension.dart';
// import './business/webview_controller_js_share_extension.dart';

/// 添加JSChannel
extension AddJSChannel_CJBase on WebViewController {
  // test
  cjjs_test({
    required Future Function() closeWebToNativeBeforeOpenBrowserHandle,
    required Future Function(String errorMessage) openBrowserErrorHandle,
    required void Function(String? message) showMessageHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cjjs_test_openBrowser(
      closeWebToNativeBeforeOpenBrowserHandle:
          closeWebToNativeBeforeOpenBrowserHandle,
      errorHandle: openBrowserErrorHandle,
    );
    cjjs_test_h5CallAppAndCallBackToH5(
      showMessageHandle: showMessageHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
  }

  // base
  cjjs_base({
    required BuildContext? Function() contextGetBlock,
    required Future<Map<String, dynamic>> Function() fixedAppInfoGetBlock,
    required Future<Map<String, dynamic>> Function() fixedMonitorInfoGetBlock,
    required String? Function() getCurrentUserToken,
    required Map<String, dynamic> Function() currentUserInfoGetBlock,
    required void Function(String message) showToastHandle,
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
    required Function(SystemUiOverlayStyle systemUiOverlayStyle)
        updateAppStatusBarStyleHandle,
    required Function(bool? shouldResize) updateResizeToAvoidBottomInsetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
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

    cjjs_showAppToast(resultHandle: showToastHandle);
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
    cjjs_updateAppStatusBarStyle(callBack: updateAppStatusBarStyleHandle);
    cjjs_updateResizeToAvoidBottomInset(
      callBack: updateResizeToAvoidBottomInsetHandle,
    );
    cjjs_getScreenInfo(
      contextGetBlock: contextGetBlock,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    // share
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

  // business
  cjjs_business({
    required Future<Map<String, dynamic>?> Function({
      required String certName,
      required String certNo,
    })
        authRealPersonResultMapGetHandle,
    required Future<Map<String, dynamic>?> Function({
      required String avatarUrl,
    })
        authAvatarResultMapGetHandle,
    required Future<bool> Function(String mpPath) goMpHandle,
    required Future<bool> Function({
      required String payType,
      required Map<String, dynamic> argsFromH5,
    })
        payHandle,
    required Future<List<String>> Function({
      String? allowMeidaTypeString,
      required int maxCount,
      required bool showCamera,
    })
        pickMediasHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cjjs_authRealPerson(
      resultMapGetHandle: authRealPersonResultMapGetHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_authAvatar(
      resultMapGetHandle: authAvatarResultMapGetHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_callWeChatMiniProgram(
      goMpHandle: goMpHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_pay(
      payHandle: payHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
    cjjs_pickMediasAndUpload(
      pickMediasHandle: pickMediasHandle,
      webViewControllerGetBlock: webViewControllerGetBlock,
    );
  }
}
