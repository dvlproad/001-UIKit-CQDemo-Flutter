/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 21:12:54
 * @Description: ResponseModel 的处理方式
 */
import 'package:flutter_network_base/flutter_network_base.dart';

class ErrorResponseUtil {
  static ResponseModel getErrorResponseModel(
    String fullUrl,
    ErrOptions err,
    bool? isFromCache, {
    required ErrOptions errOptions,
  }) {
    NetworkErrorType errorType = err.type;
    // cancel
    if (errorType == NetworkErrorType.cancel) {
      return ResponseModel(
        statusCode: HttpStatusCode.ErrorDioCancel,
        message: '请求已取消',
        result: null,
        isCache: isFromCache,
        dateModel: ResponseDateModel.fromErrOptions(errOptions),
      );
    }

    // connectTimeout\sendTimeout\receiveTimeout
    if (errorType == NetworkErrorType.connectTimeout ||
        errorType == NetworkErrorType.sendTimeout ||
        errorType == NetworkErrorType.receiveTimeout) {
      return ResponseModel(
        statusCode: HttpStatusCode.ErrorTimeout,
        message: err.message,
        result: null,
        isCache: isFromCache,
        dateModel: ResponseDateModel.fromErrOptions(errOptions),
      );
    }

    if (errorType == NetworkErrorType.response) {
      /// When the server response, but with a incorrect status, such as 404, 503...
      return ResponseModel(
        statusCode: err.response?.statusCode ?? HttpStatusCode.ErrorDioResponse,
        message: err.response?.statusMessage ?? '服务器开小差',
        result: null,
        isCache: isFromCache,
        dateModel: ResponseDateModel.fromErrOptions(errOptions),
      );
    }

    // other: Default error type, Some other Error. In this case, you can use the DioError.error if it is not null.
    // String errorMessage = '请求$fullUrl的时候，发生网络错误:${err.message}';
    // String errorMessage = err.message;
    return ResponseModel(
      statusCode: HttpStatusCode.ErrorDioOther,
      message: '网络开小差了，请检查下网络再试！',
      result: null,
      isCache: isFromCache,
      dateModel: ResponseDateModel.fromErrOptions(errOptions),
    );
  }
}
