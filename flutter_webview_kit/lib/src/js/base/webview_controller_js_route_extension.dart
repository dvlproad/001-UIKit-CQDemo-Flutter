/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:23:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:21:44
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';
import '../../js_add_check_run/h5_call_bridge_response_model.dart';

/// 添加JSChannel
extension AddJSChannel_Route on WebViewController {
  /// 跳转到app指定页面_Url
  cjjs_jumpAppPageUrl({
    required void Function(String url) resultHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_jumpAppPageUrl',
      onMessageReceived: (JavaScriptMessage message) {
        String jsonString = message.message.toString();
        Map? map = json.decode(jsonString);
        if (map == null) {
          return;
        }
        String? url = map['url'];
        if (url == null || url.isEmpty) {
          return;
        }
        resultHandle(url);
      },
    );
  }

  /// 跳转到app指定页面_Name
  cjjs_jumpAppPageName({
    required void Function(
      String pageName, {
      Map<String, dynamic>? pageParams,
      // 进入到 app页面后，如果返回到当前页面，是否需要根据特殊参数做特殊处理。(eg: 从悬浮在window的游戏web进入app，要隐藏游戏；而从进入的页面返回时候，需要将隐藏的游戏再显示出来)
      Map<String, dynamic>? pageBackParams,
    })
        resultHandle,
  }) {
    cj_addJavaScriptChannel(
      "h5CallBridgeAction_jumpAppPageName",
      onMessageReceived: (JavaScriptMessage message) {
        Map map = json.decode(message.message);
        String pageName = map["pageName"];
        Map<String, dynamic>? pageParams = map["pageParams"];
        Map<String, dynamic>? pageBackParams = map["pageBackParams"];
        resultHandle(
          pageName,
          pageParams: pageParams,
          pageBackParams: pageBackParams,
        );
      },
    );
  }

  /// 跳转到第几个一级页
  cjjs_backToHomeIndex({
    required void Function(int homeIndex) resultHandle,
  }) {
    cj_addJavaScriptChannel(
      'h5CallBridgeAction_backToHomeIndex',
      onMessageReceived: (JavaScriptMessage message) {
        Map<String, dynamic>? map = json.decode(message.message.toString());
        if (map == null) {
          return;
        }
        int? homeIndex = map["homeIndex"];
        if (homeIndex != null) {
          resultHandle(homeIndex);
        }
      },
    );
  }

  /// 是否隐藏底部tabbar（当 webView 作为一级页面的时候需要使用到)
  cjjs_hidesBottomBarWhenPushed({
    required WebViewController? Function() webViewControllerGetBlock,
    required void Function(bool shouldHide) hidesBottomBarHandle,
  }) {
    cj2_addJavaScriptChannel(
      'h5CallBridgeAction_hidesBottomBarWhenPushed',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) {
        bool? hidesBottomBar = h5Params?['hidesBottomBar'];
        if (hidesBottomBar == null) {
          return JSResponseModel.error(message: '缺少 hidesBottomBar 参数');
        }
        hidesBottomBarHandle(hidesBottomBar);
        return JSResponseModel.success(isSuccess: true);
      },
    );
  }

  /// 调起小程序，进入到指定界面(常用于：app中的h5页面，需要调起微信小程序执行支付等)
  cjjs_launchWeChatMiniProgram({
    required Future<bool> Function(String mpPath) goMpHandle,
    required WebViewController? Function() webViewControllerGetBlock,
  }) {
    cj2_addJavaScriptChannel_asyncReceived(
      'h5CallBridgeAction_goWechatMP',
      callBackWebViewControllerGetBlock: webViewControllerGetBlock,
      onMessageReceived: (Map<String, dynamic>? h5Params) async {
        String? path = h5Params?['path'];
        if (path == null || path.isEmpty) {
          return JSResponseModel.error(message: '缺少 path 参数');
        }
        // 返回值保持和微信sdk 的 launchWeChatMiniProgram 方法返回值一致，都是一个bool值
        bool isSuccess = await goMpHandle(path);
        return JSResponseModel.success(isSuccess: isSuccess);
      },
    );
  }
}
