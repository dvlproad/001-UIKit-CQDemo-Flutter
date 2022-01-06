import 'dart:convert';
import 'package:flutter/material.dart';

// import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

// import 'package:fluwx/fluwx.dart'; // 微信
import 'package:image_picker/image_picker.dart'; // 调用相册

import 'package:toast/toast.dart';

class JSUtil {
  // WebViewController webViewController;
  // JSUtil({this.webViewController});
  // Future<String> runJavascript(String javascriptString) {
  //   return webViewController.runJavascript(javascriptString);
  // }

  FlutterWebviewPlugin flutterWebViewPlugin;
  JSUtil({this.flutterWebViewPlugin});
  Future<String> runJavascript(String javascriptString) async {
    return flutterWebViewPlugin.evalJavascript(javascriptString);
  }

  Set<JavascriptChannel> javascriptChannels;
  void configJavascriptChannels(Set<JavascriptChannel> javascriptChannels) {
    this.javascriptChannels = javascriptChannels;
  }

  ///返回
  JavascriptChannel backJsChannel(BuildContext context) => JavascriptChannel(
      name: 'getflutterback',
      onMessageReceived: (JavascriptMessage message) {
        print("get message from JS, message is: ${message.message}");
        Navigator.of(context).pop();
      });
}
