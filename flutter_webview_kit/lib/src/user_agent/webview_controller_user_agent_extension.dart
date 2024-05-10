/*
 * @Author: dvlproad
 * @Date: 2024-04-29 18:19:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 14:27:38
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names, camel_case_extensions
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 添加JSChannel
extension AppendCustomUserAgentExtension on WebViewController {
  /// 添加 user-agent 在原来的user-agent后
  cj_appendCustomUserAgent(Map<String, dynamic> customUserAgentMap) async {
    String customUserAgentString = json.encode(customUserAgentMap);

    Object originUserAgent =
        await runJavaScriptReturningResult("navigator.userAgent");
    String newUserAgentString = "$originUserAgent<$customUserAgentString>";
    setUserAgent(newUserAgentString);

    Object newUserAgent =
        await runJavaScriptReturningResult("navigator.userAgent");
    debugPrint("验证.设置完后新的 userAgent: ${newUserAgent.toString()}");
  }
}
