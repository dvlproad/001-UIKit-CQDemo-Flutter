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
      failureWidget: _bodyFailureWidget(context),
    );
  }

  Widget _bodyFailureWidget(BuildContext context) {
    return null;
    // 测试在webView上弹出其他视图
    return Scaffold(
      appBar: AppBar(
        title: const Text('h5请求失败的视图'),
      ),
      body: Container(
        color: Colors.green,
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Center(
              child: Text(
                '加载失败',
                style: TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              child: const Text('测试在webView上弹出其他视图'),
              onPressed: () {
                _showPopup();
              },
            ),
            ElevatedButton(
              child: const Text('刷新有效地址 https://www.baidu.com'),
              onPressed: () {
                flutterWebViewPlugin.launch('https://www.baidu.com');
              },
            ),
            ElevatedButton(
              child: const Text('刷新无效地址 https://www.baidu2.com'),
              onPressed: () {
                flutterWebViewPlugin.launch('https://www.baidu2.com');
              },
            ),
            ElevatedButton(
              child: const Text('退出'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup() {
    showDialog<Null>(
      context: context,
      builder: (BuildContext context) {
        return new SimpleDialog(
          title: new Text('选择'),
          children: <Widget>[
            new SimpleDialogOption(
              child: new Text('选项 1'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new SimpleDialogOption(
              child: new Text('选项 2'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((val) {
      print(val);
    });
  }
}
