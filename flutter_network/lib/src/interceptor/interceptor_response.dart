import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'Loading.dart';
import 'ResultData.dart';

class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    //RequestOptions option = response.requestOptions;
    handler.next(response);
  }
}
