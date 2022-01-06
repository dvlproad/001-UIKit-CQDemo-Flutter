import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './webview_plugin/ts_webview_plugin_home_page.dart';
import './webview/ts_webview_flutter_home_page.dart';

class TSWebViewHomePage extends CJTSBasePage {
  TSWebViewHomePage({Key key}) : super(key: key);

  @override
//  _TSWebViewHomePageState createState() => _TSWebViewHomePageState();
  CJTSBasePageState getState() {
    return _TSWebViewHomePageState();
  }
}

class _TSWebViewHomePageState extends CJTSBasePageState<TSWebViewHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('WebView 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "WebView",
        'values': [
          {
            'title': "WebViewPlugin",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSWebViewPluginHomePage()));
            },
          },
          {
            'title': "WebViewFlutter",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TSWebViewFlutterHomePage()));
            },
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
