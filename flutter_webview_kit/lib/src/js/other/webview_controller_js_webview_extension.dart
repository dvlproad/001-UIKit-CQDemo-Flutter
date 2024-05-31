// ignore_for_file: camel_case_extensions, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-04-30 10:15:13
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 11:35:30
 * @Description: 
 */
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_WebView on WebViewController {
  /// 关闭webview
  cjjs_closeWebView({
    required void Function() closeWebViewHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_closeWebView',
      onMessageReceived: (JavaScriptMessage message) {
        closeWebViewHandle();
      },
    );
  }

  /// 刷新网页(到新地址)
  cjjs_web_updateToUrl({
    required Function() updateCompleteBlock,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj1_addJavaScriptChannel(
      'h5CallBridgeAction_reloadAppWebView',
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        String? url = h5Params?['url'];
        if (url == null || url.isEmpty) {
          return;
        }

        WebViewController? webViewController = webViewControllerGetBlock();
        if (webViewController == null) {
          return;
        }
        webViewController.loadRequest(Uri.parse(url));
        updateCompleteBlock();
      },
    );
  }

  /// 重新加载
  cjjs_web_reload({
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_reload',
      onMessageReceived: (JavaScriptMessage message) {
        WebViewController? webViewController = webViewControllerGetBlock();
        if (webViewController == null) {
          return;
        }
        webViewController.reload();
      },
    );
  }
}
