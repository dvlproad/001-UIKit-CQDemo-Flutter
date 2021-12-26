import 'package:dio/dio.dart';
import './device_info.dart';

class HeaderInterceptor extends Interceptor {
  @override
  onRequest(RequestOptions options) async {
    ///注入公共 header
    options.headers.addAll(await getHeaders());

    return super.onRequest(options);
  }

  ///获取公共 header 信息
  static Future<Map<String, Object>> getHeaders() async {
    return {
      'version': await DeviceInfo.version(),
    };
  }
}
