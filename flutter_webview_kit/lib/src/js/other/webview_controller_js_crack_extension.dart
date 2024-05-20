/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:59:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 11:08:18
 * @Description: 风控相关
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Crack on WebViewController {
  /// 是否是模拟器
  cjjs_isRunningOnSimulator({
    required Future<Map<String, dynamic>> Function(List<String>? types)
        checkSimulatorResultMapGetHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_isSimulator',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        List<String>? types = h5Params?['types'];
        // if (types == null || types.isEmpty) {
        //   return JSResponseModel.error(message: '缺少 types 参数');
        // }
        Map<String, dynamic> callbackMap =
            await checkSimulatorResultMapGetHandle(types);
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }
}
