/*
 * @Author: dvlproad
 * @Date: 2023-03-27 17:22:14
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-27 18:45:44
 * @Description: 
 */
import 'package:flutter_environment_base/flutter_environment_base.dart';
import '../app_network/app_network_manager.dart';
import '../monitor_network/monitor_network_manager.dart';

class AppNetworkChangeUtil {
  /// *********************** baseUrl 设置 ************************
  static void changeOptions(TSEnvNetworkModel bNetworkModel) {
    AppNetworkManager().changeOptions(baseUrl: bNetworkModel.apiHost);
    MonitorNetworkManager()
        .changeOptions(baseUrl: bNetworkModel.monitorApiHost);
  }

  /// *********************** proxy 设置 ************************
  static bool changeProxy(String? proxyIp) {
    bool changeSuccess = AppNetworkManager().changeProxy(proxyIp);
    // bool changeSuccess2 = MonitorNetworkManager().changeProxy(proxyIp);

    return changeSuccess;
  }
}
