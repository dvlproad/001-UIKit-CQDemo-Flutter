/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:48:19
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:41:43
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_Pay on WebViewController {
  /// 调起微信小程序到微信
  cjjs_pay({
    required Future<bool> Function({
      required String payType,
      required Map<String, dynamic> argsFromH5,
    })
        payHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_pay',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? payType = h5Params?['payType'];
        if (payType == null || payType.isEmpty) {
          return JSResponseModel.error(message: '缺少 payType 参数');
        }

        bool isSuccess =
            await payHandle(payType: payType, argsFromH5: h5Params!);
        return JSResponseModel.success(isSuccess: isSuccess);
      },
    );
  }
}
