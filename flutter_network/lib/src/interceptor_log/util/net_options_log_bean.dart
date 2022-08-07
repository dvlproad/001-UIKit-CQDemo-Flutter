/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-14 00:01:22
 * @Description: 请求各过程中的信息获取
 */
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
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

/// api 日志信息类型
enum ApiLogLevel {
  request, // 正常日志信息
  error_timeout, // 请求超时的错误信息（超时的请求错误企业微信上报，使用文件折叠，其他用纯文本铺开）
  error_other, // 请求失败的其他错误信息（超时的请求错误企业微信上报，使用文件折叠，其他用纯文本铺开）
  response_warning, // 请求成功但业务失败(警告)
  response_success, // 请求成功并业务成功(恭喜)
}

class ApiMessageModel {
  DateTime dateTime;
  ApiProcessType apiProcessType;

  Map<String, dynamic> detailLogJsonMap;
  String shortMessage;
  ApiLogLevel apiLogLevel;

  bool? isCacheApiLog;

  // error 才有的数据
  NetworkErrorType? errorType;

  // response 才有的数据
  int? statusCode;
  int? businessCode;

  ApiMessageModel({
    required this.dateTime,
    required this.apiProcessType,
    required this.detailLogJsonMap,
    required this.shortMessage, // 简略信息(目前只用在页面日志列表的cell里，详情里还是完整信息)
    required this.apiLogLevel,
    this.errorType, // error 时候才有
    this.statusCode, // response 时候才有
    this.businessCode, // response 时候才有
    this.isCacheApiLog,
  });

  String get logHeaderString {
    String logHeaderString = ''; // 日志头
    if (apiProcessType == ApiProcessType.request) {
      logHeaderString += "======== REQUEST(请求开始的信息) ========";
    } else if (apiProcessType == ApiProcessType.error) {
      logHeaderString += "请求失败(${errorType.toString()})的回复：\n";
      logHeaderString += "============== Error ==============";
    } else if (apiProcessType == ApiProcessType.response) {
      logHeaderString += "=========== RESPONSE ===========\n"; // 日志头
      if (apiLogLevel == ApiLogLevel.response_success ||
          apiLogLevel == ApiLogLevel.response_warning) {
        logHeaderString += "请求成功(code$businessCode)的回复";
      } else {
        logHeaderString += "请求失败(code$businessCode)的回复";
      }
    }

    return logHeaderString;
  }

  String get detailMessage {
    String detailLogJsonString = getDetailLogJsonString(detailLogJsonMap);
    String apiDetailMessage = "$logHeaderString\n$detailLogJsonString";

    return apiDetailMessage;
  }

  static String getDetailLogJsonString(Map<String, dynamic> detailLogJsonMap) {
    String detailLogJsonString = '';

    // if (detailLogJsonMap["METHOD"] == "GET") {
    //   // debug;
    // }
    for (String key in detailLogJsonMap.keys) {
      Object keyValue = detailLogJsonMap[key];
      String keyValueString =
          FormatterUtil.convert(keyValue, 0, isObject: true);
      detailLogJsonString += "- $key:\n$keyValueString\n\n";
    }
    return detailLogJsonString;
  }
}
