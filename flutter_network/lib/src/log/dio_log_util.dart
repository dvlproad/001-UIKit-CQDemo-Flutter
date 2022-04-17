/*
 * @Author: dvlproad
 * @Date: 2022-04-16 19:19:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-17 23:36:39
 * @Description: dio的日志输出工具
 */
import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import 'package:flutter_log/flutter_log.dart';
import '../url/url_util.dart';
import '../mock/mock_analy_util.dart';

/// api 日志信息类型
enum ApiLogLevel {
  normal, // 正常日志信息
  warning, // 警告信息
  error, // 错误信息
}

/// api 请求的阶段类型
enum ApiProcessType {
  request, // 请求阶段
  error, // 请求失败
  response, // 请求成功
}

class DioLogUtil {
  static void Function(
    String fullUrl, // 完整的url路径
    String logString, {
    ApiProcessType apiProcessType, // api 请求的阶段类型
    ApiLogLevel apiLogLevel, // api 日志信息类型
    bool isCacheApiLog, // 是否是缓存请求的日志
  }) _logApiInfoAction; // 打印请求各阶段出现的不同等级的日志信息

  static void initDioLogUtil({
    @required
        void Function(
      String fullUrl, // 完整的url路径
      String logString, {
      ApiProcessType apiProcessType, // api 请求的阶段类型
      ApiLogLevel apiLogLevel, // api 日志信息类型
      bool isCacheApiLog, // 是否是缓存请求的日志
    })
            logApiInfoAction, // 打印请求各阶段出现的不同等级的日志信息
  }) {
    _logApiInfoAction = logApiInfoAction;
  }

  static void logApi(
    String fullUrl, // 完整的url路径
    String logString, // api 日志信息
    ApiProcessType apiProcessType, // api 请求的阶段类型
    ApiLogLevel apiLogLevel, // api 日志信息类型
    {
    bool isFromCache, // 是否是缓存数据
  }) {
    if (_logApiInfoAction != null) {
      _logApiInfoAction(
        fullUrl,
        logString,
        apiProcessType: apiProcessType,
        apiLogLevel: apiLogLevel,
        isCacheApiLog: isFromCache,
      );
    } else {
      print("Error：网络api日志输出接口未定义，请先调用 DioLogUtil.initDioLogUtil 来实现");
    }
  }
}
