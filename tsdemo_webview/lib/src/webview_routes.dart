import 'package:flutter/widgets.dart';
import './webview_home_page.dart';
// button
// import './button/button_home_page.dart';

class WebViewRouters {
  // 组件模块
  static const webviewHomePage = '/webview_home_page';
  // button
  // static const buttonHomePage = '/button_home_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    WebViewRouters.webviewHomePage: (BuildContext context) =>
        TSWebViewHomePage(),
    // // button
    // WebViewRouters.buttonHomePage: (BuildContext context) =>
    //     TSButtonHomePage(),
    // WebViewRouters.themeButtonPage: (BuildContext context) =>
    //     TSThemeButtonPage(),
    // WebViewRouters.otherButtonPage: (BuildContext context) =>
    //     TSOtherButtonsPage(),
  };
}
