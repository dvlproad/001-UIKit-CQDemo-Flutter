/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:19:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-31 15:04:26
 * @Description: h5数据的持久化
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_InfoCache on WebViewController {
  /// h5 的json数据在 app 中的保存、获取、删除
  cjjs_cache({
    required Future<bool> Function(Map<String, dynamic> json, String key)
        saveCacheJsonToKeyHandle,
    required Future<Map<String, dynamic>?> Function(String key)
        getCacheJsonFromKeyHandle,
    required Future<bool> Function(String key) removeCacheJsonByKeyHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_saveCacheJsonToKey',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        if (h5Params == null || h5Params.isEmpty) {
          return JSResponseModel.error(message: '缺少 key 和 value 参数');
        }
        // key
        String? key = h5Params['key'];
        if (key == null || key.isEmpty) {
          return JSResponseModel.error(message: '缺少 key 参数');
        }
        // value
        if (h5Params['value'] == null) {
          return JSResponseModel.error(message: '缺少 value 参数');
        }
        if (h5Params['value'] is! Map) {
          String valueString = h5Params['value'].toString();
          return JSResponseModel.error(message: '暂时只支持保存map方法\n$valueString');
        }
        Map<String, dynamic> json = h5Params['value'] ?? {};

        bool saveSuccess = await saveCacheJsonToKeyHandle(json, key);
        return JSResponseModel.success(isSuccess: saveSuccess);
      },
    );

    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_getCacheJsonFromKey',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? key = h5Params?['key'];
        if (key == null || key.isEmpty) {
          return JSResponseModel.error(message: '缺少 key 参数');
        }
        Map<String, dynamic>? callbackMap =
            await getCacheJsonFromKeyHandle(key);
        return JSResponseModel.success(isSuccess: true, result: callbackMap);
      },
    );

    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_removeCacheJsonByKey',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? key = h5Params?['key'];
        if (key == null || key.isEmpty) {
          return JSResponseModel.error(message: '缺少 key 参数');
        }
        bool removeSuccess = await removeCacheJsonByKeyHandle(key);
        return JSResponseModel.success(isSuccess: removeSuccess);
      },
    );
  }
}
