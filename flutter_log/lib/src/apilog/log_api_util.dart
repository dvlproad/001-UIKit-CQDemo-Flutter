/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 01:15:52
 * @Description: 打印网络日志的工具类
 */

import '../log/dev_log_util.dart';
import '../log_console/print_console_log_util.dart';
import './api_error_robot.dart';

import '../log_robot/common_error_robot.dart';
import '../log_robot/compile_mode_util.dart';
export '../log_robot/compile_mode_util.dart';

import '../log_util.dart';

class LogApiUtil {
  static void apiError(
    String apiFullUrl,
    String apiMessage, {
    Map extraLogInfo,
    String tag,
  }) {
    LogLevel logLevel = LogLevel.error;
    logApiInfo(apiFullUrl, apiMessage,
        logLevel: logLevel, extraLogInfo: extraLogInfo, tag: tag);
  }

  static void apiNormal(
    String apiFullUrl,
    String apiMessage, {
    Map extraLogInfo,
    String tag,
  }) {
    LogLevel logLevel = LogLevel.normal;
    logApiInfo(apiFullUrl, apiMessage,
        logLevel: logLevel, extraLogInfo: extraLogInfo, tag: tag);
  }

  static void apiSuccess(
    String apiFullUrl,
    String apiMessage, {
    Map extraLogInfo,
    String tag,
  }) {
    LogLevel logLevel = LogLevel.success;
    logApiInfo(apiFullUrl, apiMessage,
        logLevel: logLevel, extraLogInfo: extraLogInfo, tag: tag);
  }

  static void apiWarning(
    String apiFullUrl,
    String apiMessage, {
    Map extraLogInfo,
    String tag,
  }) {
    LogLevel logLevel = LogLevel.warning;
    logApiInfo(apiFullUrl, apiMessage,
        logLevel: logLevel, extraLogInfo: extraLogInfo, tag: tag);
  }

  static void logApiInfo(
    String apiFullUrl,
    String apiMessage, {
    LogLevel logLevel,
    Map extraLogInfo, // 执行api时候的代理等其他信息
    String tag,
  }) {
    /// api 请求的阶段类型
    // enum ApiProcessType {
    //   request, // 请求阶段
    //   error, // 请求失败
    //   response, // 请求成功
    // }
    var apiProcessType;
    String serviceValidProxyIp = '';
    bool isCacheApiLog = false;
    if (extraLogInfo != null) {
      serviceValidProxyIp = extraLogInfo['serviceValidProxyIp'] ?? '';
      isCacheApiLog = extraLogInfo['isCacheApiLog'] ?? false;

      apiProcessType = extraLogInfo['extra_apiProcessType'];
    }

    String apiProcessTypeString;
    if (apiProcessType != null) {
      apiProcessTypeString = apiProcessType.toString();
    }

    if (LogUtil.shouldShowToConsole(logLevel, extraLogInfo)) {
      String consoleLogMessage;

      if (isCacheApiLog == true) {
        if (apiProcessTypeString == "ApiProcessType.request") {
          consoleLogMessage = "======此次api请求会去取缓存数据，而不是实际请求======\n$apiMessage";
        } else {
          consoleLogMessage = "======此次api结果为缓存数据，而不是后台实际结果======\n$apiMessage";
        }
      } else {
        consoleLogMessage = apiMessage;
      }
      PrintConsoleLogUtil.printConsoleLog(
        tag,
        LogUtil.desForLogLevel(logLevel),
        consoleLogMessage,
      );
    }

    if (LogUtil.shouldShowToPage(logLevel, extraLogInfo)) {
      String pageLogMessage;
      if (isCacheApiLog == true) {
        if (apiProcessTypeString == "ApiProcessType.request") {
          pageLogMessage = "======此次api请求会去取缓存数据，而不是实际请求======\n$apiMessage";
        } else {
          pageLogMessage = "======此次api结果为缓存数据，而不是后台实际结果======\n$apiMessage";
        }
      } else {
        pageLogMessage = apiMessage;
      }
      DevLogUtil.addLogModel(
        logLevel: logLevel,
        logTitle: '',
        logText: pageLogMessage,
        logInfo: extraLogInfo,
      );
    }

    if (LogUtil.shouldPostToWechat(logLevel, extraLogInfo)) {
      if (isCacheApiLog == true) {
        return; // api请求缓存数据过程中的日志 即使错误页不需要上包
      }
      if (apiFullUrl != null) {
        ApiErrorRobot.postApiError(
          apiFullUrl,
          apiMessage,
          serviceValidProxyIp: serviceValidProxyIp,
          isCacheApiLog: isCacheApiLog,
        );
      }
    }
  }
}
