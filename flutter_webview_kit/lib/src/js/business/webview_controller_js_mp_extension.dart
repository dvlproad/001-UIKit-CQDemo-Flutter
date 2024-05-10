// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-29 19:19:02
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:42:31
 * @Description: 
 */
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_MiniProgram on WebViewController {
  /// 调起小程序(执行支付等)
  cjjs_callWeChatMiniProgram({
    required Future<bool> Function(String mpPath) goMpHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_callWechatMP',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? path = h5Params?['path'];
        if (path == null || path.isEmpty) {
          return JSResponseModel.error(message: '缺少 path 参数');
        }

        bool isSuccess = await goMpHandle(path);
        return JSResponseModel.success(isSuccess: isSuccess);
      },
    );
  }
}
