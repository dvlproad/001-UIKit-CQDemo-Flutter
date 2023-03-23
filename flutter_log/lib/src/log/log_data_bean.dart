// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:52:17
 * @Description: 日志信息模型
 */

import 'package:flutter/material.dart'; // 需要使用颜色 Color
import '../string_format_util/formatter_object_util.dart';

enum LogObjectType {
  api_app, // app中的网络请求
  api_cache, // 网络缓存请求
  api_sdk, // sdk中的网络请求
  dart, // 语法
  widget, // 视图
  route, // 路由
  api_buriedPoint, // 埋点
  monitor_network, // 监控(埋点、网络类型变化等)
  other, // 其他
}

enum LogLevel {
  normal, // 正常信息(目前用于请求开始)
  success, // 成功信息(目前用于请求结束：成功)
  warning, // 警告信息(目前用于请求结束：报错)
  error, // 错误日志(目前用于请求结束：失败)
}

// log分类
enum LogCategory {
  all, // 所有 (LogLevel.normal + LogLevel.success + LogLevel.warning + LogLevel.error)
  success_warning_error, // 所有的请求结果(包含成功、警告、失败) (LogLevel.success + LogLevel.warning + LogLevel.error)
  warning, // 警告信息 (LogLevel.warning)
  error, // 错误日志(LogLevel.error)
}

class LogModel {
  LogObjectType logType;
  LogLevel logLevel;

  DateTime dateTime;
  String? title;
  Map<dynamic, dynamic> shortMap;

  Map<dynamic, dynamic>? extraLogInfo;
  dynamic detailLogModel;

  LogModel({
    required this.logType,
    required this.logLevel,
    required this.dateTime,
    this.title,
    required this.shortMap,
    this.extraLogInfo, // 用来标识处理的log特殊数据
    this.detailLogModel,
  });

  @override
  String toString() => '$title $shortMapString';

  String get shortMapString {
    String shortMapString = '';
    if (logType == LogObjectType.api_app ||
        logType == LogObjectType.api_cache ||
        logType == LogObjectType.api_buriedPoint ||
        logType == LogObjectType.monitor_network) {
      shortMapString = _joinLogJsonString(shortMap);
    } else {
      shortMapString = _getLogJsonString(shortMap);
    }

    return shortMapString;
  }

  String get detailMapString {
    Map<dynamic, dynamic> detailMap = detailLogModel;
    String detailMapString = _getLogJsonString(detailMap);

    String detailString = detailMapString;
    if (logType == LogObjectType.api_app && extraLogInfo != null) {
      // List<String> robotUrls = ApiPostUtil.getRobotUrlsByApiHost(apiHost);
      String logFotterMessage = extraLogInfo!["logFotterMessage"] ?? '';
      detailString += '\n$logFotterMessage';
    }

    return detailString;
  }

  static String _joinLogJsonString(Map<dynamic, dynamic> logJsonMap) {
    if (logJsonMap.isEmpty) {
      return '';
    }
    String logJsonString = '';
    for (var key in logJsonMap.keys) {
      Object keyValue = logJsonMap[key];
      String keyValueString = keyValue.toString();

      logJsonString += "$keyValueString\n";
    }
    logJsonString =
        logJsonString.substring(0, logJsonString.length - "\n".length);
    return logJsonString;
  }

  static String _getLogJsonString(Map<dynamic, dynamic> logJsonMap) {
    if (logJsonMap.isEmpty) {
      return '';
    }
    String logJsonString = '';

    // if (detailLogJsonMap["METHOD"] == "GET") {
    //   // debug;
    // }
    // int keyCount = logJsonMap.keys.length;
    // for (var i = 0; i < keyCount; i++) {
    //   String key = logJsonMap.keys[i];
    for (var key in logJsonMap.keys) {
      Object keyValue = logJsonMap[key];
      String keyValueString =
          FormatterUtil.convert(keyValue, 0, isObject: true);
      // if (i > 0) {
      //   logJsonString += "\n";
      // }
      logJsonString += "- $key:\n$keyValueString\n";
      logJsonString += "\n";
    }
    logJsonString =
        logJsonString.substring(0, logJsonString.length - "\n".length - 1);
    return logJsonString;
  }

  // json 与 model 转换
  factory LogModel.fromJson(Map<dynamic, dynamic> json) {
    return LogModel(
      logType: json['logType'] ?? LogObjectType.other,
      logLevel: json['logLevel'] ?? LogLevel.normal,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      title: json['title'],
      shortMap: json['shortMap'] ?? '',
      extraLogInfo: json['extraLogInfo'],
    );
  }
  Map<dynamic, dynamic> toJson() {
    return {
      "title": title,
      "shortMap": shortMap,
      "logLevel": logLevel,
      "extraLogInfo": extraLogInfo,
    };
  }

  // 获取其他值
  Color get logColor {
    Color subTitleColor = Colors.black;
    if (logLevel == LogLevel.error) {
      if (logType == LogObjectType.api_cache) {
        subTitleColor = Colors.red.shade200;
      } else {
        subTitleColor = Colors.red;
      }
    } else if (logLevel == LogLevel.warning) {
      if (logType == LogObjectType.api_cache) {
        subTitleColor = Colors.orange.shade200;
      } else {
        subTitleColor = Colors.orange;
      }
    } else if (logLevel == LogLevel.success) {
      if (logType == LogObjectType.route) {
        subTitleColor = Colors.blue;
      } else if (logType == LogObjectType.monitor_network) {
        subTitleColor = Colors.cyan;
      } else {
        if (logType == LogObjectType.api_cache) {
          subTitleColor = Colors.green.shade200;
        } else {
          subTitleColor = Colors.green;
        }
      }
    }

    return subTitleColor;
  }
}
