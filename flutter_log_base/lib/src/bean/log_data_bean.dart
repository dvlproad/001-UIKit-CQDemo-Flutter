// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad dvlproad@163.com
 * @LastEditTime: 2023-03-23 22:39:23
 * @Description: 日志信息模型
 */

import 'package:flutter/material.dart'; // 需要使用颜色 Color
import 'package:flutter_foundation_base/flutter_foundation_base.dart';
import './api_purpose_model.dart';
import './api_user_bean.dart';

enum LogObjectType {
  api_app, // app中的网络请求
  api_cache, // 网络缓存请求
  api_sdk, // sdk中的网络请求
  api_buriedPoint, // 埋点
  dart, // 语法
  widget, // 视图
  sdk_other,
  buriedPoint_other,
  route, // 路由
  monitor_network, // 监控：网络类型变化
  monitor_lifecycle, // 监控：生命周期变化
  click_other,
  click_share,
  h5_route, // 路由(与网页跳转有关)
  h5_js, // js交互
  heartbeat, // 心跳
  im, // IM
  other, // 其他
}

enum LogLevel {
  normal, // 正常信息(目前用于请求开始)
  success, // 成功信息(目前用于请求结束：成功)
  warning, // 警告信息(目前用于请求结束：报错)
  error, // 错误日志(目前用于请求结束：失败)
  dangerous, // 危险错误(如白屏等)，会上报企业微信
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
    if (logType == LogObjectType.other) {
      shortMapString = shortMap.map2StringWitKey();
    } else if (logType == LogObjectType.api_app ||
        logType == LogObjectType.api_cache) {
      if (shortMap is Map<String, dynamic>) {
        Map<String, dynamic> _shortMap = shortMap as Map<String, dynamic>;
        shortMapString += (_shortMap.purposeString ?? "");
        shortMapString += (_shortMap.peopleString ?? "");
        if (shortMapString.isNotEmpty) {
          shortMapString += "\n";
        }
      }
      shortMapString += shortMap.map2StringWithoutKey(
        withoutkeys: ["ApiPurpose"],
      );
    } else {
      shortMapString = shortMap.map2StringWithoutKey(); // 不需要key
    }

    return shortMapString;
  }

  String get detailMapString {
    Map<dynamic, dynamic> detailMap = detailLogModel;
    String detailMapString = detailMap.map2StringWitKey();

    String detailString = detailMapString;
    if (logType == LogObjectType.api_app && extraLogInfo != null) {
      // List<String> robotUrls = ApiPostUtil.getRobotUrlsByApiHost(apiHost);
      String logFotterMessage = extraLogInfo!["logFotterMessage"] ?? '';
      detailString += '\n$logFotterMessage';
    }

    return detailString;
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
