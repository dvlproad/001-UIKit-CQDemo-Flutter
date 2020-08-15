import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textfield_home_page.dart';
import 'package:tsdemodemo_flutter/modules/uikit/textfield_page.dart';

class BaseUIKitRouters {
  // 组件模块
  static const uikitHomePage = '/uikit_home_page';
  static const textfieldHomePage = '/textfield_home_page';
  static const textfieldPage = '/textfield_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    BaseUIKitRouters.uikitHomePage: (BuildContext context) =>
        TSBaseUIHomePage(),
    BaseUIKitRouters.textfieldHomePage: (BuildContext context) =>
        TSTextFieldHomePage(),
    BaseUIKitRouters.textfieldPage: (BuildContext context) => TSTextFieldPage(),
  };
}
