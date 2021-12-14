import 'package:flutter/widgets.dart';
import './datepicker_home_page.dart';
// button
// import './button/button_home_page.dart';

class DatePickerRouters {
  // 组件模块
  static const datepickerHomePage = '/datepicker_home_page';
  // button
  // static const buttonHomePage = '/button_home_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    DatePickerRouters.datepickerHomePage: (BuildContext context) =>
        TSDatePickerHomePage(),
    // // button
    // DatePickerRouters.buttonHomePage: (BuildContext context) =>
    //     TSButtonHomePage(),
    // DatePickerRouters.themeButtonPage: (BuildContext context) =>
    //     TSThemeButtonPage(),
    // DatePickerRouters.otherButtonPage: (BuildContext context) =>
    //     TSOtherButtonsPage(),
  };
}
