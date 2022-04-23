/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 02:15:03
 * @Description: 请求拦截器
 */
import 'package:dio/dio.dart';
import './device_info.dart';
import '../trace/trace_util.dart';

class RequestInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);

    // 注入公共 header
    // String traceId = TraceUtil.traceId();
    // Map<String, Object> header = {
    //   'version': '1000',
    //   "trace_id": traceId,
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
