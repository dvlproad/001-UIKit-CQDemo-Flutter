// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:12:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 10:51:46
 * @Description: 
 */
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Auth on WebViewController {
  ///实人认证(实名通过后，也要进行活体通过)
  cjjs_authRealPerson({
    required Future<Map<String, dynamic>?> Function({
      required String certName,
      required String certNo,
    })
        resultMapGetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_auth_realPerson',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String certName = h5Params?['certName'] ?? "";
        String certNo = h5Params?['certNo'] ?? "";
        Map<String, dynamic>? callbackMap = await resultMapGetHandle(
          certNo: certNo,
          certName: certName,
        );
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }

  /// 头像认证
  cjjs_authAvatar({
    required Future<Map<String, dynamic>?> Function({
      required String avatarUrl,
    })
        resultMapGetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_auth_avatar',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String avatarUrl = h5Params?['avatarUrl'] ?? "";
        Map<String, dynamic>? callbackMap = await resultMapGetHandle(
          avatarUrl: avatarUrl,
        );
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }
}
