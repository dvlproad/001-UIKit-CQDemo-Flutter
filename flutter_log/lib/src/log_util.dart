/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-30 18:45:33
 * @Description: 日志类
 */
import 'package:meta/meta.dart';
import 'package:flutter/material.dart';
import './log/dev_log_util.dart';
import './string_format_util/formatter_object_util.dart';

import './log_console/print_console_log_util.dart';
import './log/dev_log_util.dart';

import './log_robot/common_error_robot.dart';
import './log_robot/compile_mode_util.dart';

import './log/log_data_bean.dart';
import './log/popup_logview_manager.dart';

typedef ShouldLogFunction = bool Function(
    LogObjectType logObjectType, LogLevel logLevel,
    {Map<String, dynamic>? extraLogInfo});

class LogUtil {
  // 局部变量
  // 是否打印到调试控制台
  static late bool Function(LogObjectType logObjectType, LogLevel logLevel,
      {Map<String, dynamic>? extraLogInfo}) shouldPrintToConsoleFunction;
  // 是否tost到界面
  static late ShouldLogFunction shouldShowToastFunction;
  // 是否显示到页面上
  static late bool Function(LogObjectType logObjectType, LogLevel logLevel,
      {Map<String, dynamic>? extraLogInfo}) shouldShowToPageFunction;
  // 是否上报发送到企业微信上
  static late String? Function(LogObjectType logObjectType, LogLevel logLevel,
      {Map<String, dynamic>? extraLogInfo}) postToWechatRobotUrlGetFunction;

  static void init({
    required String tolerantRobotKey, // 为防止找不到机器人时候上报信息丢失，而添加的容错机器人
    required String packageDescribe, // 包的描述(生产、测试、开发包)
    required String Function() userDescribeBlock, // 当前使用该包的用户信息
    required bool Function(LogObjectType logObjectType, LogLevel logLevel,
            {Map<String, dynamic>? extraLogInfo})
        shouldPrintToConsoleBlock,
    required ShouldLogFunction shouldShowToastBlock,
    required bool Function(LogObjectType logObjectType, LogLevel logLevel,
            {Map<String, dynamic>? extraLogInfo})
        shouldShowToPageBlock,
    required String? Function(LogObjectType logObjectType, LogLevel logLevel,
            {Map<String, dynamic>? extraLogInfo})
        postToWechatRobotUrlGetBlock,
    String? tag,
    required Widget Function(LogModel logModel) logDetailPageBuilder,
  }) {
    CommonErrorRobot.init(
      tolerantRobotKey: tolerantRobotKey,
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
    );

    shouldPrintToConsoleFunction = shouldPrintToConsoleBlock;
    shouldShowToastFunction = shouldShowToastBlock;
    shouldShowToPageFunction = shouldShowToPageBlock;
    postToWechatRobotUrlGetFunction = postToWechatRobotUrlGetBlock;
    ApplicationLogViewManager.logDetailPageBuilder = logDetailPageBuilder;
    tag = tag;
  }

  // String serviceValidProxyIp; // 网络库当前服务的有效的代理ip地址(无代理或其地址无效时候，这里会传null)

  static String desForLogLevel(LogLevel logLevel) {
    String levelString = logLevel.toString().split('.').last;
    return '  $levelString  ';
  }

  // /// 控制台打印
  // static consologObject(Object object) {
  //   String consologMessage = FormatterUtil.convert(object, 0, isObject: true);
  //   PrintConsoleLogUtil.printConsoleLog(null, null, consologMessage);
  // }

  static void templog(String message) {
    PrintConsoleLogUtil.templog(message);
  }

  static void printConsoleLog(Object object, {String? tag, String? stag}) {
    PrintConsoleLogUtil.printConsoleLog(object, tag: tag, stag: stag);
  }

  /// 通用异常上报:企业微信
  static Future<bool> postError(
    String robotKey,
    String
        title, // 可为null，不是null时候，只是为了对 customMessage 起一个强调作用。(一般此title肯定在customMessage有包含到)
    String customMessage,
    List<String> mentionedList,
  ) async {
    return CommonErrorRobot.post(
      robotKey: robotKey,
      postType: RobotPostType.text,
      title: title,
      customMessage: customMessage,
      mentionedList: mentionedList,
    );
  }
}
