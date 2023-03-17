/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 16:35:41
 * @Description: 
 */
// overlay 的 View 测试
import 'package:flutter/widgets.dart';
import 'custom_service_home_page.dart';

import './custom_service_home_page.dart';

class CustomServiceRouters {
  static const overlayViewHomePage = '/serviceVersionCheck_home_page';

  static Map<String, WidgetBuilder> routes = {
    CustomServiceRouters.overlayViewHomePage: (BuildContext context) =>
        CustomServiceHomePage(),
  };
}
