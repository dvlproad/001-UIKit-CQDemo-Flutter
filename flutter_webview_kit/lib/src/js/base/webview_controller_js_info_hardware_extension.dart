/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:19:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 11:28:07
 * @Description: 硬件相关的JS
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'package:flutter/foundation.dart';

import 'package:webview_flutter/webview_flutter.dart';

// import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Hardware on WebViewController {
  /// 打开app设置(常用场景:h5 只获取权限值，自定义弹窗时候，需要调用此方法)
  cjjs_openAppSettings({
    required void Function() openAppSettingsHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_openAppSettings',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        openAppSettingsHandle();
      },
    );
  }

  /*
  /// 获取定位开关权限(某些网页活动需要精准定位，如果没有精准定位，需要展示对应的网页样式提示框)，并将返回值回调给 h5
  cjjs_getLocationPermission({
    required Future<Map<String, dynamic>> Function() callbackMapGetBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_getLocationPermission',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        Map<String, dynamic> callbackMap = await callbackMapGetBlock();
        return JSResponseModel.success(isSuccess: true, result: callbackMap);
      },
    );
  }
  */

  /// 获取用户当前位置信息，并在获取后调用js方法回传（此处没法直接返回 callbackMap ，因为定位信息代码上可能是 callback 提供
  cjjs_getUserLocationInfo({
    required void Function(bool? needFullAccuracy, String callbackJSMethodName)
        getUserLocationInfoHandle,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_getUserLocationInfo',
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? jsMethodName = h5Params?["callbackMethod"];
        if (jsMethodName == null || jsMethodName.isEmpty) {
          String errorMessage = "缺失获取定位成功后，要调用的回调方法 callbackMethod ，所以也没必要去定位了";
          debugPrint("qian error: $errorMessage");
          return;
        }

        bool? needFullAccuracy = h5Params?["fullAccuracy"];
        getUserLocationInfoHandle(needFullAccuracy, jsMethodName);
      },
    );
  }
}
