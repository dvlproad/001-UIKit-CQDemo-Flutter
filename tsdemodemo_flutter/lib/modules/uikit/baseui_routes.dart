import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_home_page.dart';
// button
import 'package:tsdemodemo_flutter/modules/uikit/button/button_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/button/theme_button_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/button/other_button_page.dart';
// textField
import 'package:tsdemodemo_flutter/modules/uikit/textfielddemo/textfield_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textfielddemo/icon_textfield_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textfielddemo/text_textfield_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textfielddemo/textinputformmtter_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textviewdemo/textview_emoji_maxlength_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textviewdemo/textview_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textviewdemo/textview_maxlength_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textviewdemo/textview_page.dart';

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
  // textView
  static const textViewHomePage = '/textview_home_page';
  static const textViewPage = '/textview_page';
  static const textViewMaxLengthPage = '/textview_maxlength_page';
  static const textViewEmojiMaxLengthPage = '/textview_emoji_maxlength_page';

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
    // textView
    BaseUIKitRouters.textViewHomePage: (BuildContext context) =>
        TSTextViewHomePage(),
    BaseUIKitRouters.textViewPage: (BuildContext context) => TSTextViewPage(),
    BaseUIKitRouters.textViewMaxLengthPage: (BuildContext context) =>
        TSTextViewMaxLengthPage(),
    BaseUIKitRouters.textViewEmojiMaxLengthPage: (BuildContext context) =>
        TSTextViewEmojiMaxLengthPage(),
  };
}
