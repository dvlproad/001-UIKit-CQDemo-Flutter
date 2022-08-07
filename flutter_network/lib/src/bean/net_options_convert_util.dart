/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 14:31:09
 * @Description: dio模型转为自身模型的转换方法
 */

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'req_options.dart';
import 'err_options.dart';
import 'res_options.dart';

import '../cache/dio_cache_util.dart';

class NetworkModelConvertUtil {
  // request
  static ReqOptions newRequestOptions(RequestOptions options) {
    bool? isRequestCache = null;
    if (null != DioCacheUtil.isRequestCacheCheckFunction) {
      isRequestCache = DioCacheUtil.isRequestCacheCheckFunction(options);
    }

    var reqOpt = ReqOptions(
      baseUrl: options.baseUrl,
      path: options.path,
      // uri: options.uri,
      method: options.method,
      contentType: options.contentType.toString(),
      params: options.queryParameters,
      data: options.data,
      headers: options.headers,
      isRequestCache: isRequestCache,
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

    bool? isErrorFromCache = null;
    if (null != DioCacheUtil.isCacheErrorCheckFunction) {
      isErrorFromCache = DioCacheUtil.isCacheErrorCheckFunction(err);
    }
    errOptions.isErrorFromCache = isErrorFromCache;

    return errOptions;
  }

  // response
  static ResOptions newResponse(Response response) {
    ReqOptions reqOpt = newRequestOptions(response.requestOptions);
    bool? isResponseFromCache = null;
    if (null != DioCacheUtil.isCacheResponseCheckFunction) {
      isResponseFromCache = DioCacheUtil.isCacheResponseCheckFunction(response);
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
    bool? isRequestCache = null;
    if (null != DioCacheUtil.isRequestCacheCheckFunction) {
      isRequestCache = DioCacheUtil.isRequestCacheCheckFunction(this);
    }

    if (isRequestCache == true) {
      return this.uri.toString().hashCode;
    } else {
      return this.hashCode;
    }
  }
}
