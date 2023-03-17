/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-09-06 13:53:56
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
    Map<String, dynamic> shortLogJsonMap = {};
    if (detailLogJsonMap['isRealApi'] != null) {
      shortLogJsonMap.addAll({"isRealApi": detailLogJsonMap['isRealApi']});
    }
    shortLogJsonMap.addAll({"fullUrl": options.fullUrl});
    shortLogJsonMap.addAll({"Request": "Request:${options.method}"});
    // String apiShortMessge = '';
    // if (detailLogJsonMap.containsKey('isRealApi')) {
    //   apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    // }
    // apiShortMessge += "${options.fullUrl}\n";
    // apiShortMessge += "Request:${options.method}";

    DateTime dateTime = options.requestTime;

    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.request,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortLogJsonMap: shortLogJsonMap,
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
    Map<String, dynamic> shortLogJsonMap = {};
    if (detailLogJsonMap['isRealApi'] != null) {
      shortLogJsonMap.addAll({"isRealApi": detailLogJsonMap['isRealApi']});
    }
    shortLogJsonMap.addAll({"URL": detailLogJsonMap['URL']});
    shortLogJsonMap.addAll({"ERRORTYPE": detailLogJsonMap['ERRORTYPE']});
    if (err.response != null) {
      int statusCode = err.response!.statusCode ?? HttpStatusCode.Unknow;
      String responseCodeMessage = "Response:statusCode:${statusCode}";
      shortLogJsonMap.addAll({"Response": responseCodeMessage});
    }
    // String apiShortMessge = '';
    // if (detailLogJsonMap.containsKey('isRealApi')) {
    //   apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    // }
    // apiShortMessge += "${detailLogJsonMap['URL']}\n";
    // apiShortMessge += "Error:${detailLogJsonMap['ERRORTYPE']}\n";
    // if (err.response != null) {
    //   int statusCode = err.response!.statusCode ?? HttpStatusCode.Unknow;
    //   apiShortMessge += "Response:statusCode:${statusCode}";
    // }

    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.error,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortLogJsonMap: shortLogJsonMap,
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

    // 真正的 statusCode
    int statusCode = response.statusCode ?? HttpStatusCode.Unknow;
    ResponseModel responseModel = getSuccessResponseModelBlock(
      response.fullUrl,
      statusCode,
      response.data,
      response.isResponseFromCache,
    );

    // shortMessage
    ApiLogLevel apiLogLevel = responseModel.apiLogLevel;

    Map<String, dynamic> shortLogJsonMap = {};
    if (detailLogJsonMap['isRealApi'] != null) {
      shortLogJsonMap.addAll({"isRealApi": detailLogJsonMap['isRealApi']});
    }
    shortLogJsonMap.addAll({"URL": detailLogJsonMap['URL']});
    String responseCodeMessage = "Response:statusCode:${statusCode}";
    int businessCode = responseModel
        .statusCode; // 有些项目里把500等错误的statusCode,下沉到最后的responseModel里
    if (businessCode != null) {
      responseCodeMessage += "_code:${businessCode}";
    }
    shortLogJsonMap.addAll({"Response": responseCodeMessage});

    // String apiShortMessge = '';
    // if (detailLogJsonMap.containsKey('isRealApi')) {
    //   apiShortMessge += "isRealApi:${detailLogJsonMap['isRealApi']}\n";
    // }
    // apiShortMessge += "${detailLogJsonMap['URL']}\n";
    // apiShortMessge += "Response:statusCode:${statusCode}";

    // int businessCode = responseModel
    //     .statusCode; // 有些项目里把500等错误的statusCode,下沉到最后的responseModel里
    // if (businessCode != null) {
    //   apiShortMessge += "_code:${businessCode}";
    // }

    DateTime dateTime = response.responseTime;
    ApiMessageModel apiMessageModel = ApiMessageModel(
      apiProcessType: ApiProcessType.response,
      dateTime: dateTime,
      detailLogJsonMap: detailLogJsonMap,
      shortLogJsonMap: shortLogJsonMap,
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
