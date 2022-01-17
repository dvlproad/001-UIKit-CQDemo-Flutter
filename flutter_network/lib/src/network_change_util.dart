import 'package:dio/dio.dart';
import 'package:dio/adapter.dart';

class DioChangeUtil {
  /// 修改 baseUrl
  static void changeOptions(Dio dio, {String baseUrl}) {
    if (baseUrl.endsWith('/') == false) {
      baseUrl = '$baseUrl/';
    }

    dio.options = dio.options.copyWith(
      baseUrl: baseUrl,
    );
  }

  static void changeHeaders(Dio dio, {Map<String, dynamic> headers}) {
    dio.options = dio.options.copyWith(
      headers: headers,
    );
  }

  // 修改代理 proxy
  static void changeProxy(Dio dio, {String proxyIp}) {
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.findProxy = (uri) {
        if (proxyIp != null) {
          return "PROXY $proxyIp";
        } else {
          return 'DIRECT';
        }
      };
      // client.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) {
      //   return true;
      // };
    };
  }
}
