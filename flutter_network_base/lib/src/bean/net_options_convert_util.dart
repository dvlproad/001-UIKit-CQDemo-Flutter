/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-30 19:29:13
 * @Description: dio模型转为自身模型的转换方法
 */

import 'package:dio/dio.dart';
import 'req_options.dart';
import 'err_options.dart';
import 'res_options.dart';

import '../cache/dio_cache_util.dart';

class NetworkModelConvertUtil {
  // request
  static ReqOptions newRequestOptions(RequestOptions options) {
    bool? isRequestCache;
    if (DioCacheUtil.isRequestCacheCheckFunction != null) {
      isRequestCache = DioCacheUtil.isRequestCacheCheckFunction!(options);
    }

    DateTime? requestTime = options.extra['requestStartTime'];
    requestTime ??= DateTime.now();
    var reqOpt = ReqOptions(
      baseUrl: options.baseUrl,
      path: options.path,
      // uri: options.uri,
      method: options.method,
      contentType: options.contentType.toString(),
      params: options.queryParameters,
      data: options.data, // 参数params放Request模型的位置:GET请求时params中,POST请求时data中
      headers: options.headers,
      isRequestCache: isRequestCache,
      requestTime: requestTime,
    );

    return reqOpt;
  }

  // error
  static NetworkErrorType _newErrorType(DioErrorType dioErrorType) {
    NetworkErrorType errorType = NetworkErrorType.other;
    if (dioErrorType == DioErrorType.connectTimeout) {
      errorType = NetworkErrorType.connectTimeout;
    } else if (dioErrorType == DioErrorType.sendTimeout) {
      errorType = NetworkErrorType.sendTimeout;
    } else if (dioErrorType == DioErrorType.receiveTimeout) {
      errorType = NetworkErrorType.receiveTimeout;
    } else if (dioErrorType == DioErrorType.response) {
      errorType = NetworkErrorType.response;
    } else if (dioErrorType == DioErrorType.cancel) {
      errorType = NetworkErrorType.cancel;
    } else {
      errorType = NetworkErrorType.other;
    }
    return errorType;
  }

  static ErrOptions newError(DioError err) {
    NetworkErrorType errorType = _newErrorType(err.type);

    ReqOptions reqOpt = newRequestOptions(err.requestOptions);
    ErrOptions errOptions = ErrOptions(
      message: err.message,
      requestOptions: reqOpt,
      type: errorType,
    );

    if (err.response != null) {
      ResOptions resOpt = newResponse(err.response!);
      errOptions.response = resOpt;
    }

    bool? isErrorFromCache;
    if (DioCacheUtil.isCacheErrorCheckFunction != null) {
      isErrorFromCache = DioCacheUtil.isCacheErrorCheckFunction!(err);
    }
    errOptions.isErrorFromCache = isErrorFromCache;

    return errOptions;
  }

  // response
  static ResOptions newResponse(Response response) {
    ReqOptions reqOpt = newRequestOptions(response.requestOptions);
    bool? isResponseFromCache;
    if (DioCacheUtil.isCacheResponseCheckFunction != null) {
      isResponseFromCache =
          DioCacheUtil.isCacheResponseCheckFunction!(response);
    }
    var resOpt = ResOptions(
      requestOptions: reqOpt,
      statusCode: response.statusCode ?? 0,
      data: response.data,
      headersMap: response.headers.map,
      isResponseFromCache: isResponseFromCache,
    );

    return resOpt;
  }
}

extension RequestId on RequestOptions {
  int get requestId {
    bool? isRequestCache;
    if (DioCacheUtil.isRequestCacheCheckFunction != null) {
      isRequestCache = DioCacheUtil.isRequestCacheCheckFunction!(this);
    }

    if (isRequestCache == true) {
      return uri.toString().hashCode;
    } else {
      return hashCode;
    }
  }
}
