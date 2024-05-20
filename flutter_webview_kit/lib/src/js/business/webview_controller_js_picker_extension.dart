// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-30 10:00:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-20 10:47:09
 * @Description: 
 */
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Picker on WebViewController {
  /// 打开相册选择图片或视频 并上传（待考虑视频缩略图是否提供）
  cjjs_pickMediasAndUpload({
    required Future<List<String>> Function({
      String? allowMeidaTypeString,
      required int maxCount,
      required bool showCamera,
    })
        pickMediasHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_pickMediasAndUpload',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? allowMeidaTypeString = h5Params?["allowMeidaType"];
        int maxCount = h5Params?["maxCount"] ?? 1;
        bool showCamera = h5Params?["showCamera"] ?? true;

        List<String> imageUrls = await pickMediasHandle(
          allowMeidaTypeString: allowMeidaTypeString,
          maxCount: maxCount,
          showCamera: showCamera,
        );
        Map<String, dynamic> jsCallbackMap = {
          "imageUrls": imageUrls, // 待考虑视频缩略图是否提供
        };

        return JSResponseModel.success(
          isSuccess: true,
          result: jsCallbackMap,
        );
      },
    );
  }
}
