/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-28 18:05:28
 * @Description: 日志信息模型
 */

import 'package:meta/meta.dart';

enum LogObjectType {
  api, // 网络请求
  dart, // 语法
  widget, // 视图
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
  String content;

  Map<String, dynamic>? logInfo;
  dynamic detailLogModel;

  LogModel({
    required this.logType,
    required this.logLevel,
    required this.dateTime,
    this.title,
    required this.content,
    this.logInfo, // 用来标识处理的log特殊数据
    this.detailLogModel,
  });

  @override
  String toString() => '$title $content';

  // json 与 model 转换
  factory LogModel.fromJson(Map<String, dynamic> json) {
    return LogModel(
      logType: json['logType'] ?? LogObjectType.other,
      logLevel: json['logLevel'] ?? LogLevel.normal,
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dateTime']),
      title: json['title'],
      content: json['content'] ?? '',
      logInfo: json['logInfo'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "title": this.title,
      "content": this.content,
      "logLevel": this.logLevel,
      "logInfo": this.logInfo,
    };
  }
}
