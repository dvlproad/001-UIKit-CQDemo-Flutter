/*
 * @Author: dvlproad
 * @Date: 2023-03-24 10:55:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 15:30:04
 * @Description: 
 */
// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_log_base/flutter_log_base.dart';
import 'package:flutter_robot_base/flutter_robot_base.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';

import './log_util.dart';
import 'dart:math';

class AppLogUtil {
  static final Completer _initCompleter = Completer<String>();
  static final _deviceStackTraceRegex = RegExp(r'#[0-9]+\s+(.+) \((\S+)\)');
  static final _webStackTraceRegex = RegExp(r'^((packages|dart-sdk)/\S+/)');
  static final _browserStackTraceRegex =
      RegExp(r'^(?:package:)?(dart:\S+|\S+)');
  static const int stackTraceBeginIndex = 0;
  static const int stackTraceMethodCount = 3;

  static void Function(LogModel gLogModel)? _logGenerateBlock; // 产生日志的回调

  static init({
    required String tolerantRobotKey,
    required PackageNetworkType originPackageNetworkType,
    required PackageNetworkType Function() currentNetworkTypeGetBlock,
    required PackageTargetType originPackageTargetType,
    required String packageDescribe,
    required String Function() userDescribeBlock,
    required bool Function()
        isForceNoUploadEnvGetBlock, // 是否是强制不上报的环境(正式上生产的时候就不要上报了)
    required String Function(String apiHost) getRobotUrlByApiHostBlock,
    required void Function(LogModel gLogModel) logGenerateBlock, // 产生日志的回调
    required void Function(dynamic) jsonViewOnTap,
    required void Function(dynamic) jsonViewOnDoubleTap,
    required void Function(dynamic) jsonViewOnLongPress,
  }) async {
    _logGenerateBlock = logGenerateBlock;
    LogUtil.init(
      tolerantRobotKey: tolerantRobotKey,
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
      shouldPrintToConsoleBlock: (LogObjectType logObjectType, logLevel,
          {Map<String, dynamic>? extraLogInfo}) {
        // 1、dart、widget错误是否输出到控制台
        if (logObjectType == LogObjectType.dart ||
            logObjectType == LogObjectType.widget) {
          return true;
        }

        // 2、api不通知，其已自己管理
        if (logObjectType == LogObjectType.api_app ||
            logObjectType == LogObjectType.api_sdk) {
          bool hasProxy =
              extraLogInfo != null && extraLogInfo['hasProxy'] == true;
          if (hasProxy && logLevel == LogLevel.error) {
            return true; // 有代理并错误的情况下，在控制台输出日志
          }
        }

        return false;
      },
      shouldShowToastBlock: (LogObjectType logObjectType, logLevel,
          {Map<String, dynamic>? extraLogInfo}) {
        // 1、不是debug不tost
        ComplieMode complieMode = ComplieModeUtil.getCompileMode();
        if (complieMode != ComplieMode.debug) {
          return false;
        }

        // 2、api不通知，其已自己管理
        if (logObjectType == LogObjectType.api_app ||
            logObjectType == LogObjectType.api_sdk) {
          return false;
        }

        // 3、dart、widget错误非生产才弹出
        if (logObjectType == LogObjectType.dart ||
            logObjectType == LogObjectType.widget) {
          if (originPackageNetworkType != PackageNetworkType.product) {
            return true;
          }

          return false;
        }

        return false;
      },
      shouldShowToPageBlock: (LogObjectType logObjectType, logLevel,
          {Map<String, dynamic>? extraLogInfo}) {
        return true;
      },
      postToWechatRobotUrlGetBlock: (LogObjectType logObjectType, logLevel,
          {Map<String, dynamic>? extraLogInfo}) {
        /// [LogLevel.dangerous] 用于排查重要问题，会上报企业微信，一般情况不使用
        if (logLevel == LogLevel.dangerous) {
          return _postToWechatRobotUrl_dangerous(
            originPackageNetworkType: originPackageNetworkType,
            originPackageTargetType: originPackageTargetType,
            logObjectType: logObjectType,
            logLevel: logLevel,
            extraLogInfo: extraLogInfo,
          );
        }

        bool isForceNoUploadEnv = isForceNoUploadEnvGetBlock();
        if (isForceNoUploadEnv) {
          return null;
        }

        if (logObjectType == LogObjectType.dart ||
            logObjectType == LogObjectType.widget) {
          return _postToWechatRobotUrl_dart_widget(
            originPackageNetworkType: originPackageNetworkType,
            originPackageTargetType: originPackageTargetType,
            logObjectType: logObjectType,
            logLevel: logLevel,
            extraLogInfo: extraLogInfo,
          );
        } else if (logObjectType == LogObjectType.api_app) {
          return _postToWechatRobotUrl_api(
            originPackageNetworkType: originPackageNetworkType,
            originPackageTargetType: originPackageTargetType,
            currentPackageNetworkType: currentNetworkTypeGetBlock(),
            logObjectType: logObjectType,
            logLevel: logLevel,
            extraLogInfo: extraLogInfo,
            getRobotUrlByApiHostBlock: getRobotUrlByApiHostBlock,
          );
        }

        return null;
      },
      logDetailPageBuilder: (LogModel logModel) {
        if (logModel.detailLogModel is Map) {
          return _mapDetailWidget(
            logModel,
            jsonViewOnTap: jsonViewOnTap,
            jsonViewOnDoubleTap: jsonViewOnDoubleTap,
            jsonViewOnLongPress: jsonViewOnLongPress,
          );
        } else {
          return Container();
        }
      },
    );
    _initCompleter.complete('log初始化完成，后续 logMessage 才可以正常使用回调判断如何打印log');
  }

  static String? _postToWechatRobotUrl_dart_widget({
    required PackageNetworkType originPackageNetworkType,
    required PackageTargetType originPackageTargetType,
    required LogObjectType logObjectType,
    required LogLevel logLevel,
    Map<String, dynamic>? extraLogInfo,
  }) {
    // 2、包不对不通知
    bool isOutProduct = originPackageTargetType == PackageTargetType.formal &&
        originPackageNetworkType == PackageNetworkType.product;
    if (isOutProduct) {
      return null; // 外测生产包dart、weiget错误都不上报
    }

    String robotKey_darterror = '826c6d07-ecb5-4b42-99cd-dbe60dd64904';
    if (logObjectType == LogObjectType.dart) {
      return robotKey_darterror;
    }

    if (logObjectType == LogObjectType.widget) {
      return robotKey_darterror;
    }

    return null;
  }

  static String? _postToWechatRobotUrl_dangerous({
    required PackageNetworkType originPackageNetworkType,
    required PackageTargetType originPackageTargetType,
    required LogObjectType logObjectType,
    required LogLevel logLevel,
    Map<String, dynamic>? extraLogInfo,
  }) {
    String robotKey_darterror = '5bdd6832-cfae-4aeb-96d0-fc49aff3fff4';
    if (logLevel == LogLevel.dangerous) {
      return robotKey_darterror;
    }

    return null;
  }

  static String? _postToWechatRobotUrl_api({
    required PackageNetworkType originPackageNetworkType,
    required PackageNetworkType currentPackageNetworkType,
    required PackageTargetType originPackageTargetType,
    required LogObjectType logObjectType,
    required LogLevel logLevel,
    Map<String, dynamic>? extraLogInfo,
    required String Function(String apiHost) getRobotUrlByApiHostBlock,
  }) {
    /*
    // 拿指定接口来测试上报的代码
    if (extraLogInfo != null && extraLogInfo["logApiPath"] != null) {
      String logApiPath = extraLogInfo["logApiPath"];
      if (logApiPath.contains("goods/getGoodsDetailPageInfo")) {
        return myRobotKey; // 获取商品详情
      }
    }
    */

    // 1、debug 不通知
    ComplieMode complieMode = ComplieModeUtil.getCompileMode();
    if (complieMode == ComplieMode.debug) {
      return null;
    }

    // 2、包不对不通知
    // bool isOutProduct = originPackageTargetType == PackageTargetType.formal && originPackageNetworkType == PackageNetworkType.product;
    // if (isOutProduct) {
    //   return null; // 外测生产包都不上报
    // }
    // 如果环境是生产环境，但包却不是生产包，则异常先不进行上报
    if (originPackageNetworkType != currentPackageNetworkType &&
        currentPackageNetworkType == PackageNetworkType.product) {
      return null;
    }

    bool hasProxy = false;
    bool isCacheApiLog = false;
    String? apiHost;
    String? apiErrorTypeString;
    if (extraLogInfo != null) {
      hasProxy = extraLogInfo['hasProxy'] ?? false;
      apiHost = extraLogInfo["apiHost"];
      isCacheApiLog = extraLogInfo["isCacheApiLog"] ?? false;
      apiErrorTypeString = extraLogInfo["apiErrorType"];
    }
    // 3、网络有代理的时候不通知
    if (hasProxy) {
      return null;
    }

    // 4、不是错误不通知
    if (logLevel != LogLevel.error) {
      return null;
    }

    // 5、可以通知时候，通知到对应的robotKey
    if (isCacheApiLog) {
      return null;
    }
    bool isTimeoutError = ["connectTimeout", "sendTimeout", "receiveTimeout"]
        .contains(apiErrorTypeString);
    if (isTimeoutError) {
      String robotKey_timeout = '9b7e7b8d-b0a3-49a0-9eba-bb8f1111ae55';
      return robotKey_timeout;
    } else {
      if (apiHost == null) {
        return null;
      }
      String? postApiErrorRobotUrl = getRobotUrlByApiHostBlock(apiHost);
      return postApiErrorRobotUrl;
    }
  }

  static Widget _mapDetailWidget(
    LogModel logModel, {
    required void Function(dynamic) jsonViewOnTap,
    required void Function(dynamic) jsonViewOnDoubleTap,
    required void Function(dynamic) jsonViewOnLongPress,
  }) {
    return LogDetailWidget(
      apiLogModel: logModel,
      clickApiLogCellCallback: ({
        required BuildContext context,
        int? section,
        int? row,
        required LogModel bLogModel,
      }) {
        String detailLogJsonString = bLogModel.detailMapString;

        Clipboard.setData(ClipboardData(text: detailLogJsonString));
        CJTSToastUtil.showMessage('复制当行到粘贴板成功');
      },
      onPressedClose: () => ApplicationLogViewManager.dismissLogOverlayEntry(
          ApplicationLogViewManager.logDetailOverlayKey),
      jsonViewOnTap: jsonViewOnTap,
      jsonViewOnDoubleTap: jsonViewOnDoubleTap,
      jsonViewOnLongPress: jsonViewOnLongPress,
    );
  }

  // 打印请求各阶段出现的不同等级的日志信息
  // static void logMessage(
  //   LogLevel logLevel, {
  //   required String shortMessage,
  //   required String detailMessage,
  //   dynamic T implements PageLogMoel,
  // }) {

  // }

  static void logMessageWithTackTrace({
    required LogObjectType logType,
    required LogLevel logLevel,
    String? title,
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
    Map<String, dynamic>? extraLogInfo, // log 的 额外信息
    RobotPostType? postType,
    List<String>? mentionedList,
  }) {
    logMessage(
      logType: logType,
      logLevel: logLevel,
      title: title,
      shortMap: shortMap,
      detailMap: detailMap,
      extraLogInfo: extraLogInfo,
      postType: postType,
      mentionedList: mentionedList,
      needTackTrace: false,
    );
  }

  static void logMessage({
    required LogObjectType logType,
    required LogLevel logLevel,
    String? title,
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
    Map<String, dynamic>? extraLogInfo, // log 的 额外信息
    RobotPostType? postType,
    List<String>? mentionedList,
    needTackTrace = true, // ['all']
  }) {
    // 为日志打印加上堆栈信息
    if (needTackTrace) {
      Map<dynamic, dynamic> map = detailMap;
      String? stackTraceStr =
          formatStackTrace(StackTrace.current, stackTraceMethodCount);
      if (stackTraceStr != null && stackTraceStr.isNotEmpty) {
        map.putIfAbsent("stackTrace", () => stackTraceStr);
      }
    }
    _logMessage(
        logType: logType,
        logLevel: logLevel,
        shortMap: shortMap,
        detailMap: detailMap,
        title: title,
        extraLogInfo: extraLogInfo,
        mentionedList: mentionedList);
  }

  static void _logMessage({
    required LogObjectType logType,
    required LogLevel logLevel,
    String? title,
    required Map<dynamic, dynamic> shortMap,
    required Map<dynamic, dynamic> detailMap,
    Map<String, dynamic>? extraLogInfo, // log 的 额外信息
    RobotPostType? postType,
    List<String>? mentionedList, // ['all']
  }) async {
    await _initCompleter.future;

    DateTime dateTime = DateTime.now();

    LogModel logModel = LogModel(
      dateTime: dateTime,
      logType: logType,
      logLevel: logLevel,
      shortMap: shortMap,
      extraLogInfo: extraLogInfo,
      detailLogModel: detailMap,
    );

    if (_logGenerateBlock != null) {
      _logGenerateBlock!(logModel);
    }

    // extraLogInfo ??= {};
    // String serviceValidProxyIp = networkClient.serviceValidProxyIp;
    // extraLogInfo.addAll({
    //   "hasProxy": serviceValidProxyIp != null,
    // });

    bool shouldShowToConsole = LogUtil.shouldPrintToConsoleFunction(
      logType,
      logLevel,
      extraLogInfo: extraLogInfo,
    );
    if (shouldShowToConsole) {
      String consoleLogMessage = logModel.shortMapString;
      LogUtil.printConsoleLog(
        consoleLogMessage,
        stag: LogUtil.desForLogLevel(logLevel),
      );
    }

    bool shouldShowToast = LogUtil.shouldShowToastFunction(
      logType,
      logLevel,
      extraLogInfo: extraLogInfo,
    );
    if (shouldShowToast) {
      CJTSToastUtil.showMessage('发现错误了，快打开日志查看');
    }

    bool shouldShowToPage = LogUtil.shouldShowToPageFunction(
      logType,
      logLevel,
      extraLogInfo: extraLogInfo,
    );
    if (shouldShowToPage) {
      // 页面日志列表里的日志，使用简略信息版，点击详情才查看完整信息版
      DevLogUtil.addLogModel(logModel);
    }

    String? postToWechatRobotKey = LogUtil.postToWechatRobotUrlGetFunction(
      logType,
      logLevel,
      extraLogInfo: extraLogInfo,
    );

    // text.content exceed max length 5120. invalid Request Parameter, hint: [1659003212347280693197827], from ip: 120.42.50.213, more info at https://open.work.weixin.qq.com/devtool/query?e=40058"
    if (postToWechatRobotKey != null && postToWechatRobotKey.isNotEmpty) {
      String customMessage = logModel.detailMapString;

      if (postType == null) {
        bool isLongMessage = customMessage.length > 2000;
        postType = isLongMessage ? RobotPostType.file : RobotPostType.text;
      }

      CommonErrorRobot.posts(
        robotUrls: [postToWechatRobotKey],
        postType: postType,
        mentionedList: mentionedList,
        title: title,
        customMessage: customMessage,
      );
    }
  }

  static String? formatStackTrace(StackTrace? stackTrace, int methodCount) {
    List<String> lines = stackTrace
        .toString()
        .split('\n')
        .where(
          (line) =>
              !_discardDeviceStacktraceLine(line) &&
              !_discardWebStacktraceLine(line) &&
              !_discardBrowserStacktraceLine(line) &&
              line.isNotEmpty,
        )
        .toList();
    List<String> formatted = [];

    for (int count = 0; count < min(lines.length, methodCount); count++) {
      var line = lines[count];
      if (count < stackTraceBeginIndex) {
        continue;
      }
      if (!line.contains("asynchronous suspension")) {
        formatted.add('#$count   ${line.replaceFirst(RegExp(r'#\d+\s+'), '')}');
      }
    }

    if (formatted.isEmpty) {
      return null;
    } else {
      return formatted.join('\n');
    }
  }

  static bool _discardDeviceStacktraceLine(String line) {
    var match = _deviceStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    final segment = match.group(2)!;
    if (segment.startsWith('package:flutter_log_with_env') ||
        segment.startsWith('package:flutter_buried_point') ||
        segment.startsWith('dart:') ||
        segment.startsWith('package:app_devtool_framework') ||
        segment.startsWith('package:flutter_network_kit')) {
      return true;
    }
    return false;
  }

  static bool _discardWebStacktraceLine(String line) {
    var match = _webStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    final segment = match.group(1)!;
    if (segment.startsWith('packages/flutter_log_with_env') ||
        segment.startsWith('package/flutter_log_with_env') ||
        segment.startsWith('package/flutter_buried_point') ||
        segment.startsWith('package/app_devtool_framework') ||
        segment.startsWith('package/flutter_network_kit') ||
        segment.startsWith('dart-sdk/lib')) {
      return true;
    }
    return false;
  }

  static bool _discardBrowserStacktraceLine(String line) {
    var match = _browserStackTraceRegex.matchAsPrefix(line);
    if (match == null) {
      return false;
    }
    final segment = match.group(1)!;
    if (segment.startsWith('package:flutter_log_with_env') ||
        segment.startsWith('package:flutter_buried_point') ||
        segment.startsWith('dart:') ||
        segment.startsWith('package:app_devtool_framework') ||
        segment.startsWith('package:flutter_network_kit')) {
      return true;
    }
    return false;
  }

  // 将危险信息发送信息到企业微信
  static String robotKey_dangerous = '5bdd6832-cfae-4aeb-96d0-fc49aff3fff4';
  static Future<bool> postToWeCom({
    String? title,
    required String customMessage,
  }) async {
    String? stackTraceStr =
        formatStackTrace(StackTrace.current, stackTraceMethodCount);

    String postMessage = "$stackTraceStr\n$customMessage";
    if (postMessage.length > 4096) {
      postMessage = postMessage.substring(0, 4000);
    }

    return CommonErrorRobot.posts(
      robotUrls: [robotKey_dangerous],
      postType: RobotPostType.file,
      mentionedList: [],
      title: title,
      customMessage: postMessage,
    );
  }
}

abstract class PageLogMoel {
  String shortMessage();
  String detailMessage();
}
