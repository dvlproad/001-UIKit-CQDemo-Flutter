/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:14:46
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:03:24
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/h5_call_bridge_response_model.dart';
import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Test on WebViewController {
  /// 测试浏览器中的链接显示，且链接可打开app的_原生页面
  cjjs_test_openBrowser({
    // 关闭当前 web 以返回到原生页面，并打开浏览器用于测试浏览器上的链接能否直接打开app
    required Future Function() closeWebToNativeBeforeOpenBrowserHandle,
    required Future Function(String errorMessage) errorHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_test_openBrowser',
      onMessageReceived: (JavaScriptMessage message) async {
        String jsonString = message.message.toString();
        Map map = json.decode(jsonString);
        String url = map['url'];

        // url = "yuanwangwu://openpage?pageName=webNavPage&url=https://www.baidu.com";
        // url = "https://www.baidu.com";
        // url = http: //localhost:4000/Architecture%E6%9E%B6%E6%9E%84/h5js/dvlp_h5js_demo/dvlp_h5_open_app_demo.html?appRouteUrl=yuanwangwu://openpage?pageName=imChatPage&conversationID=126191&imUserId=1602856363702501376&showName=婉艺&type=1&dialogSubjectId=1506196208391966720;
        // url =
        //     "http: //localhost:4000/Architecture%E6%9E%B6%E6%9E%84/h5js/dvlp_h5js_demo/dvlp_h5_open_app_demo.html?appRouteUrl=yuanwangwu%3A%2F%2Fopenpage%3FpageName%3DimChatPage%26conversationID%3D126191%26imUserId%3D1602856363702501376%26showName%3D%E5%A9%89%E8%89%BA%26type%3D1%26dialogSubjectId%3D1506196208391966720%0A";
        Uri Url = Uri.parse(url);
        bool canLaunch = await canLaunchUrl(Url);
        if (canLaunch) {
          await closeWebToNativeBeforeOpenBrowserHandle();
          await launchUrl(
            Url,
            mode: LaunchMode.externalApplication,
          );
        } else {
          errorHandle("无法打开当前网址 $url");
        }
      },
    );
  }

  /// 测试 h5 调用 app 方法，并将返回值回调给 h5
  cjjs_test_h5CallAppAndCallBackToH5({
    required void Function(String? message) showMessageHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_test_h5CallAppAndCallBackToH5',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        final String? msg = h5Params?["message"];
        showMessageHandle(msg);

        Map callbackMap = {
          "keyboardHeight": 123,
        };
        return JSResponseModel.success(
          isSuccess: true,
          result: callbackMap,
        );
      },
    );
  }
}
