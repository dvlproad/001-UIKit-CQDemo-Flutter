/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:23:24
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 10:02:21
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';

import 'package:webview_flutter/webview_flutter.dart';

import '../../js_add_check_run/webview_controller_add_check_run_js.dart';

/// 添加JSChannel
extension AddJSChannel_Route on WebViewController {
  /// 跳转到app指定页面_Url
  cjjs_jumpAppPageUrl({
    required Future<void> Function(String url) resultHandle,
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
    required Future<void> Function(
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
    required Future<void> Function(int homeIndex) resultHandle,
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
}
