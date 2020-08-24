import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_home_page.dart';
// button
import 'package:tsdemodemo_flutter/modules/uikit/button/button_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/button/theme_button_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/button/other_button_page.dart';
// textField
import 'package:tsdemodemo_flutter/modules/uikit/textfield_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/icon_textfield_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/text_textfield_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textinputformmtter_page.dart';

class BaseUIKitRouters {
  // 组件模块
  static const uikitHomePage = '/uikit_home_page';
  // button
  static const buttonHomePage = '/button_home_page';
  static const themeButtonPage = '/theme_button_page';
  static const otherButtonPage = '/other_button_page';
  // textField
  static const textFieldHomePage = '/textfield_home_page';
  static const iconTextFieldPage = '/icon_textfield_page';
  static const textTextFieldPage = '/text_textfield_page';
  static const textinputfomrmatterPage = '/textinputfomrmatter_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    BaseUIKitRouters.uikitHomePage: (BuildContext context) =>
        TSBaseUIHomePage(),
    // button
    BaseUIKitRouters.buttonHomePage: (BuildContext context) =>
        TSButtonHomePage(),
    BaseUIKitRouters.themeButtonPage: (BuildContext context) =>
        TSThemeButtonPage(),
    BaseUIKitRouters.otherButtonPage: (BuildContext context) =>
        TSOtherButtonsPage(),
    // textField
    BaseUIKitRouters.textFieldHomePage: (BuildContext context) =>
        TSTextFieldHomePage(),
    BaseUIKitRouters.iconTextFieldPage: (BuildContext context) =>
        TSIconTextFieldPage(),
    BaseUIKitRouters.textTextFieldPage: (BuildContext context) =>
        TSTextTextFieldPage(),
    BaseUIKitRouters.textinputfomrmatterPage: (BuildContext context) =>
        TSTextInputFormmaterPage(),
  };
}
