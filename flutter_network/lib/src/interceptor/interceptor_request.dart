/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-03 16:05:04
 * @Description: 请求拦截器
 */
import 'package:dio/dio.dart';
import './device_info.dart';

class RequestInterceptor extends Interceptor {
  /// 对 RequestOptions 添加额外的信息
  static Function(RequestOptions options)? dealRequestOptionsAction;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (RequestInterceptor.dealRequestOptionsAction != null) {
      RequestInterceptor.dealRequestOptionsAction!(options);
    }

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
