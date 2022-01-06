import 'package:flutter/material.dart';
import 'package:flutter_webview/flutter_webview.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import '../web_js.dart';

class WebViewPage extends StatefulWidget {
  String Url;
  WebViewPage({
    Key key,
    this.Url,
  }) : super(key: key);

  @override
  _WebViewPageState createState() => new _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  JSUtil jsutil;

  @override
  void initState() {
    super.initState();

    jsutil = JSUtil(flutterWebViewPlugin: flutterWebViewPlugin);

    Set<JavascriptChannel> javascriptChannels = {
      jsutil.backJsChannel(context),
    };
    jsutil.configJavascriptChannels(javascriptChannels);
  }

  @override
  Widget build(BuildContext context) {
    return BaseWebPage(
      flutterWebViewPlugin: flutterWebViewPlugin,
      Url: widget.Url, // 需要先支持http
      javascriptChannels: jsutil.javascriptChannels,
    );
  }
}
