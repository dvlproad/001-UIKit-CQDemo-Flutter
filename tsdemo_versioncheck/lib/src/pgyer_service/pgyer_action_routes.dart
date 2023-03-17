/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 16:35:18
 * @Description: overlay 的 action 测试
 */
import 'package:flutter/widgets.dart';
import 'pgyer_home_page.dart';

class PgyerRouters {
  static const overlayActionHomePage = '/pgyerVersionCheck_home_page';

  static Map<String, WidgetBuilder> routes = {
    PgyerRouters.overlayActionHomePage: (BuildContext context) =>
        TSPgyerHomePage(),
  };
}
