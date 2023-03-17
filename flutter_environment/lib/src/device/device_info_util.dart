/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 13:55:00
 * @Description: 设备信息获取工具
 */
import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'package:http_proxy/http_proxy.dart';
import '../proxy_page_data_bean.dart';

class DeviceInfoUtil {
  /// 获取手机设备自身的代理ip和port
  static Future<TSEnvProxyModel> getPhoneProxy() async {
    HttpProxy httpProxy = await HttpProxy.createHttpProxy();
    String proxyIpAndPort = "${httpProxy.host}:${httpProxy.port}";
    //print("proxyIpAndPort = $proxyIpAndPort");

    TSEnvProxyModel proxyModel = TSEnvProxyModel(
      proxyId: 'osSystemProxy',
      name: "系统代理",
      proxyIp: proxyIpAndPort,
      check: false,
    );

    return proxyModel;
  }

  /// 获取手机设备自身的所有ip信息
  static Future<String> getPhoneSystemNetworkInterface() async {
    List<NetworkInterface> interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.any,
    );

    String networkInterface = "";
    for (var interface in interfaces) {
      networkInterface += "### name: ${interface.name}\n";
      int i = 0;
      interface.addresses.forEach((address) {
        networkInterface += "${i++}) ${address.address}\n";
      });
    }

    return networkInterface;
  }

  /// 获取手机设备自身的ip地址
  static Future<Map<String, String>?> getPhoneSystemIpMap() async {
    List<NetworkInterface> interfaces = await NetworkInterface.list(
      includeLoopback: false,
      type: InternetAddressType.any,
    );

    String? systemIp;
    for (NetworkInterface interface in interfaces) {
      if (interface.name == 'en0') {
        for (InternetAddress address in interface.addresses) {
          systemIp = address.address;
          break;
        }
        break;
      }
    }

    if (systemIp != null) {
      return {"name": 'en0', "value": systemIp};
    }

    for (NetworkInterface interface in interfaces) {
      if (interface.name == 'wlan0') {
        for (InternetAddress address in interface.addresses) {
          systemIp = address.address;
          break;
        }
        break;
      }
    }
    if (systemIp != null) {
      return {"name": 'wlan0', "value": systemIp};
    }

    return null;
  }
}
