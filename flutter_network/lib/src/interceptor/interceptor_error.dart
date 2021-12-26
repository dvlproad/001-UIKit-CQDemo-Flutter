import 'package:dio/dio.dart';
import 'dart:convert' as convert;
import 'Loading.dart';
import 'ResultData.dart';

/// 数据初步处理
class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    // TODO: implement onError
    super.onError(err, handler);
    Loading.dismiss();

    //String errorMessage = err.message;
    String errorMessage = "非常抱歉！服务器开小差了～";
    // Toast.show(errorMessage, navigatorKey.currentState.overlay.context,
    //     gravity: Toast.CENTER, duration: 2);
  }
}
