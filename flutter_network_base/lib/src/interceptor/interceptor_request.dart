/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 17:11:16
 * @Description: 请求拦截器
 */
import 'package:dio/dio.dart';

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
}
