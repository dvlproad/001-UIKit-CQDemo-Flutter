// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-30 10:00:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 10:26:19
 * @Description: 
 */
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

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
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_pickMediasAndUpload',
      onMessageReceived: (JavaScriptMessage message) async {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }
        String? jsMethodName = map["callbackMethod"];
        String? allowMeidaTypeString = map["allowMeidaType"];
        int maxCount = map["maxCount"] ?? 1;
        bool showCamera = map["showCamera"] ?? true;

        List<String> imageUrls = await pickMediasHandle(
          allowMeidaTypeString: allowMeidaTypeString,
          maxCount: maxCount,
          showCamera: showCamera,
        );
        Map<String, dynamic> jsCallbackMap = {
          "imageUrls": imageUrls, // 待考虑视频缩略图是否提供
        };
        if (jsMethodName == null) {
          WebViewController? webViewController = webViewControllerGetBlock();
          webViewController?.cj_runJsMethodWithParamMap(
            jsMethodName!,
            params: jsCallbackMap,
          );
        }
      },
    );
  }
}
