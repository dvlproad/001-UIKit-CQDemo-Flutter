import 'package:dio/dio.dart';
import 'dart:convert' as convert;

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //RequestOptions option = response.requestOptions;
    handler.next(response);
  }
}
