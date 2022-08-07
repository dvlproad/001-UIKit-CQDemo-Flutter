/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-14 03:08:07
 * @Description: 
 */
import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class DioChangeUtil {
  /// 修改 baseUrl
  static void changeOptions(Dio dio, {required String baseUrl}) {
    if (baseUrl.endsWith('/') == false) {
      baseUrl = '$baseUrl/';
    }

    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
    );
  }

  static void changeHeaders(Dio dio, {required Map<String, dynamic> headers}) {
    // print("dio.options.headers111=${dio.options.headers}");
    // addAll 才是正确的，不要用 dio.options.copyWith(header:xxx);
    dio.options.headers.addAll(headers);
    // print("dio.options.headers222=${dio.options.headers}");
  }

  static void removeHeadersKey(Dio dio, String removeKey) {
    dio.options.headers.remove(removeKey);
  }

  // 修改代理 proxy
  // 修改代理 proxy(返回代理设置成功与否，当传入的ip地址格式不正确等则无法成功设置代理)
  static bool changeProxy(Dio dio, {required String proxyIp}) {
    bool canUpdate = canUpdateProxy(proxyIp); // 无代理的话，一定是null
    if (canUpdate == false) {
      return false;
    }

    String serviceValidProxyIp = proxyIp;
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        if (serviceValidProxyIp != null) {
          return "PROXY $serviceValidProxyIp";
        } else {
          return 'DIRECT';
        }
      };
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) {
      //   return true;
      // };
    };

    return true;
  }

  // 判断是否能够更新代理（无代理 或 指定ip代理）
  static bool canUpdateProxy(String ipString) {
    if (ipString == null) {
      return true; // 设置成”无代理“
    }

    bool isValid = isValidProxyIp(ipString); // 设置指定的代理ip地址
    if (isValid == false) {
      throw Exception(
          'Error:您设置的代理ipString=$ipString，既不是无代理，也不是有效的代理ip地址。(如果不设置代理,ip请设为null；如果要设置代理,ip请设置形如192.168.1.1)');
    }
    return isValid;
  }

  // 判断是否是有效的代理ip地址
  static bool isValidProxyIp(String ipString) {
    if (ipString == null) {
      return false;
    }

    final reg = RegExp(r'^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}');

    bool isMatch = reg.hasMatch(ipString);
    return isMatch;
  }
}
