import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/devtool/devtool_home_page.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_page.dart';

class DevToolRouters {
  // 组件模块
  static const devtoolHomePage = '/devtool_home_page';
  static const environmentPage = '/environment_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    DevToolRouters.devtoolHomePage: (BuildContext context) =>
        TSDevToolHomePage(),
    DevToolRouters.environmentPage: (BuildContext context) =>
        TSEnvironmentPage(),
  };
}
