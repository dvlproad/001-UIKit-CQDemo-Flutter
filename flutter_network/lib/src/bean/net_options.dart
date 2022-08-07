/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 13:47:31
 * @Description: 请求过程的各种数据模型类
 */
import 'dart:convert' as convert;
import 'package:flutter/foundation.dart';
import 'req_options.dart';
import 'err_options.dart';
import 'res_options.dart';
import '../network_bean.dart' show ResponseModel;
import '../interceptor_log/util/net_options_log_bean.dart';
export './err_options.dart' show NetworkErrorType;

/// api 请求的阶段类型
enum ApiProcessType {
  request, // 请求阶段
  error, // 请求失败
  response, // 请求成功
}

/*
 *  必须实现：将"网络请求成功返回的数据responseObject"转换为"模型"的方法
 *
 *  @param fullUrl          网络请求的完整接口:用来判断是否是模拟环境
 *  @param responseObject   网络请求成功返回的数据
 *  @param isCacheData      是否是缓存数据
 *
 *  @return 数据模型
 */
typedef CJNetworkClientGetSuccessResponseModelBlock = ResponseModel Function(
    String fullUrl, dynamic responseObject, bool? isCacheData);

/*
 *  必须实现：将"网络请求失败返回的数据error"转换为"模型"的方法
 *
 *  @param error            网络请求失败返回的数据
 *  @param errorMessage     从网络中获取到错误信息getErrorMessageFromHTTPURLResponse
 *
 *  @return 数据模型
 */
// typedef CJResponseModel * _Nullable (^CJNetworkClientGetFailureResponseModelBlock)(NSError * _Nullable error, NSString * _Nullable errorMessage);
typedef CJNetworkClientGetFailureResponseModelBlock = ResponseModel Function(
    String fullUrl, int? statusCode, dynamic responseObject, bool? isCacheData);
typedef CJNetworkClientGetDioErrorResponseModelBlock = ResponseModel Function(
    String fullUrl, ErrOptions errorModel, bool? isCacheData);

///需要的网络数据类
class NetOptions {
  ReqOptions reqOptions;
  ResOptions? resOptions;
  ErrOptions? errOptions;

  CJNetworkClientGetSuccessResponseModelBlock getSuccessResponseModelBlock;

  NetOptions({
    required this.reqOptions,
    this.resOptions,
    this.errOptions,
    required this.getSuccessResponseModelBlock,
  });

  String get fullUrl {
    String url = reqOptions.fullUrl;

    return url;
  }

  bool isCacheApiLog(ApiProcessType apiProcessType) {
    if (apiProcessType == ApiProcessType.request) {
      return reqOptions.isRequestCache ?? false;
    } else if (apiProcessType == ApiProcessType.error) {
      return errOptions!.isErrorFromCache ?? false;
    } else {
      // if (apiProcessType == ApiProcessType.response) {
      return resOptions!.isResponseFromCache ?? false;
    }
  }

  Map<String, dynamic> getDetailLogJsonMap(ApiProcessType apiProcessType) {
    if (apiProcessType == ApiProcessType.request) {
      return reqOptions.detailLogJsonMap;
    } else if (apiProcessType == ApiProcessType.error) {
      return errOptions!.detailLogJsonMap;
    } else {
      // if (apiProcessType == ApiProcessType.response) {
      return resOptions!.detailLogJsonMap;
    }
  }

  String getLogHeaderString(ApiProcessType apiProcessType) {
    String logHeaderString = ''; // 日志头
    if (apiProcessType == ApiProcessType.request) {
      logHeaderString += "======== REQUEST(请求开始的信息) ========";
    } else if (apiProcessType == ApiProcessType.error) {
      NetworkErrorType errorType = errOptions!.type;
      logHeaderString += "请求失败(${errorType.toString()})的回复：\n";
      logHeaderString += "============== Error ==============";

      ApiLogLevel apiErroLogLevel;
      if (errorType == NetworkErrorType.connectTimeout ||
          errorType == NetworkErrorType.sendTimeout ||
          errorType == NetworkErrorType.receiveTimeout) {
        apiErroLogLevel = ApiLogLevel.error_timeout;
      } else {
        apiErroLogLevel = ApiLogLevel.error_other;
      }
    } else if (apiProcessType == ApiProcessType.response) {
      logHeaderString += "=========== RESPONSE ===========\n"; // 日志头
      ResOptions response = resOptions!;
      ResponseModel responseModel = getSuccessResponseModelBlock(
          response.fullUrl, response.data, response.isResponseFromCache);

      // shortMessage
      int? statusCode = response.statusCode; // 真正的 statusCode
      int businessCode = responseModel
          .statusCode; // 有些项目里把500等错误的statusCode,下沉到最后的responseModel里

      ApiLogLevel apiLogLevel = responseModel.apiLogLevel;

      if (apiLogLevel == ApiLogLevel.response_success ||
          apiLogLevel == ApiLogLevel.response_warning) {
        logHeaderString += "请求成功(code$businessCode)的回复";
      } else {
        logHeaderString += "请求失败(code$businessCode)的回复";
      }
    }

    return logHeaderString;
  }
}

class ApiEnvInfo {
  String? serviceValidProxyIp;

  ApiEnvInfo({
    this.serviceValidProxyIp,
  });
}
