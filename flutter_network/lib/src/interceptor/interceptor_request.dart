import 'package:dio/dio.dart';
import './device_info.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);

    ///注入公共 header
    // Map<String, Object> header = {
    //   'version': '1000',
    // };
    // options.headers.addAll(header);
    // handler.next(options);

    // getHeaders().then((header) {
    //   options.headers.addAll(header);
    //   handler.next(options);
    // });
  }

  ///获取公共 header 信息
  Future<Map<String, dynamic>> getHeaders() async {
    String version = await DeviceInfo.version();
    Map<String, dynamic> header = {
      'full_version': version,
    };
    return header;
  }
}
