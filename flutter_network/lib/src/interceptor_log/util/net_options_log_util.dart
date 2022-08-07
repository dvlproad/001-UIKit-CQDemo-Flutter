/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 14:03:10
 * @Description: 请求各过程中的信息获取
 */
import 'package:meta/meta.dart';

import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:flutter_log/src/string_format_util/formatter_object_util.dart';
import '../../log/dio_log_util.dart';
import '../../url/url_util.dart';

import '../../bean/err_options.dart';
import '../../bean/req_options.dart';
import '../../bean/res_options.dart';
import '../../bean/net_options.dart';

import '../../network_bean.dart';

import '../../network_util.dart'
    show CJNetworkClientGetSuccessResponseModelBlock;

import './net_options_log_bean.dart';

class ApiInfoGetter {
  static ApiMessageModel apiMessageModel(
      NetOptions options, ApiProcessType apiProcessType) {
    if (apiProcessType == ApiProcessType.request) {
      return logRequestOptions(options.reqOptions);
    } else if (apiProcessType == ApiProcessType.error) {
      return logErrorOptions(
        options.errOptions!,
        getSuccessResponseModelBlock: options.getSuccessResponseModelBlock,
      );
    } else if (apiProcessType == ApiProcessType.response) {
      return logResponse(
        options.resOptions!,
        getSuccessResponseModelBlock: options.getSuccessResponseModelBlock,
      );
    } else {
      throw Exception('无此类型，不会走到这里');
    }
  }

  // request
  static ApiMessageModel logRequestOptions(ReqOptions options) {
    // detailLogJsonMap
    Map<String, dynamic> detailLogJsonMap = options.detailLogJsonMap;

    // shortMessage
    String apiShortMessge = '';
    if (detailLogJsonMap.containsKey('isRealApi')) {
      apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    }
    apiShortMessge += "${options.fullUrl}\n";
    apiShortMessge += "Request:${options.method}";

    DateTime dateTime = options.requestTime;

    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.request,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortMessage: apiShortMessge,
      apiLogLevel: ApiLogLevel.request,
      isCacheApiLog: options.isRequestCache,
    );
    return apiMessageModel;
  }

  // error
  static ApiMessageModel logErrorOptions(
    ErrOptions err, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
  }) {
    // detailLogJsonMap
    Map<String, dynamic> detailLogJsonMap = err.detailLogJsonMap;

    DateTime dateTime = err.errorTime;

    ApiLogLevel apiErroLogLevel;
    if (err.type == NetworkErrorType.connectTimeout ||
        err.type == NetworkErrorType.sendTimeout ||
        err.type == NetworkErrorType.receiveTimeout) {
      apiErroLogLevel = ApiLogLevel.error_timeout;
    } else {
      apiErroLogLevel = ApiLogLevel.error_other;
    }

    // shortMessage
    String apiShortMessge = '';
    if (detailLogJsonMap.containsKey('isRealApi')) {
      apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    }
    apiShortMessge += "${detailLogJsonMap['URL']}\n";
    apiShortMessge += "Error:${detailLogJsonMap['ERRORTYPE']}\n";
    if (err.response != null) {
      int statusCode = err.response!.statusCode ?? HttpStatusCode.Unknow;
      apiShortMessge += "Response:statusCode:${statusCode}";
    }

    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.error,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortMessage: apiShortMessge,
      apiLogLevel: apiErroLogLevel,
      isCacheApiLog: err.isErrorFromCache,
      errorType: err.type,
    );
    return apiMessageModel;
  }

  // response
  static ApiMessageModel logResponse(
    ResOptions response, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
  }) {
    // detailLogJsonMap
    Map<String, dynamic> detailLogJsonMap = response.detailLogJsonMap;

    ResponseModel responseModel = getSuccessResponseModelBlock(
        response.fullUrl, response.data, response.isResponseFromCache);

    // shortMessage
    int statusCode =
        response.statusCode ?? HttpStatusCode.Unknow; // 真正的 statusCode
    int businessCode = responseModel
        .statusCode; // 有些项目里把500等错误的statusCode,下沉到最后的responseModel里

    ApiLogLevel apiLogLevel = responseModel.apiLogLevel;

    String apiShortMessge = '';
    if (detailLogJsonMap.containsKey('isRealApi')) {
      apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    }
    apiShortMessge += "${detailLogJsonMap['URL']}\n";
    apiShortMessge += "Response:statusCode:${statusCode}_code:${businessCode}";

    DateTime dateTime = response.responseTime;
    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.response,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortMessage: apiShortMessge,
      apiLogLevel: apiLogLevel,
      isCacheApiLog: response.isResponseFromCache,
      statusCode: statusCode,
      businessCode: businessCode,
    );
    return apiMessageModel;
  }

  static String printWrapped(String text) {
    final pattern = new RegExp('.{1,800}'); // 800 is the size of each chunk

    String allString = '';
    pattern.allMatches(text).forEach((match) {
      String? string = match.group(0);
      allString = allString + '\n' + string!;
    });

    return allString;
  }
}
