import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_home_page.dart';
// textField
import 'package:tsdemodemo_flutter/modules/uikit/textfield_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/icon_textfield_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/text_textfield_page.dart';

class BaseUIKitRouters {
  // 组件模块
  static const uikitHomePage = '/uikit_home_page';
  static const textFieldHomePage = '/textfield_home_page';
  static const iconTextFieldPage = '/icon_textfield_page';
  static const textTextFieldPage = '/text_textfield_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    BaseUIKitRouters.uikitHomePage: (BuildContext context) =>
        TSBaseUIHomePage(),
    BaseUIKitRouters.textFieldHomePage: (BuildContext context) =>
        TSTextFieldHomePage(),
    BaseUIKitRouters.iconTextFieldPage: (BuildContext context) => TSIconTextFieldPage(),
    BaseUIKitRouters.textTextFieldPage: (BuildContext context) => TSTextTextFieldPage(),
  };
}
