import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/util/util_home_page.dart';
import 'package:tsdemodemo_flutter/modules/util/device_info_page.dart';

class UtilRouters {
  // 工具的测试首页
  static const utilHomePage = '/util_home_page';
  static const deviceInfoPage = '/deviceInfo_page';

  static Map<String, WidgetBuilder> routes = {
    // 工具 util
    UtilRouters.utilHomePage: (BuildContext context) => TSUtilHomePage(),
    UtilRouters.deviceInfoPage: (BuildContext context) => TSDeviceInfoPage(),
  };
}
