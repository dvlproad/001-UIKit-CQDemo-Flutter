/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-28 19:01:30
 * @Description: 打印网络日志的工具类
 */
import 'package:meta/meta.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_network/flutter_network.dart';
import './bean/api_describe_bean.dart';
import './util/api_post_util.dart';
import '../networkStatus/network_status_manager.dart';

class LogApiUtil {
  // 打印请求各阶段出现的不同等级的日志信息
  static void logApiInfo(
    NetOptions apiInfo,
    ApiProcessType apiProcessType, {
    ApiEnvInfo? apiEnvInfo,
  }) {
    ApiMessageModel apiMessageModel =
        ApiInfoGetter.apiMessageModel(apiInfo, apiProcessType);
    bool isCacheApiLog = apiMessageModel.isCacheApiLog ?? false;

    String apiFullUrl = apiInfo.fullUrl;
    String apiPath = apiInfo.reqOptions.path;
    int index = apiFullUrl.indexOf(apiPath);
    if (index == -1) {
      print("Error:计算出错啦，肯定是你前面fullUrl计算出错了");
    }
    String apiHost = apiFullUrl.substring(0, index);

    DateTime dateTime = apiMessageModel.dateTime;
    // String dateTimeString = dateTime.toString().substring(5, 19);
    String apiShortMessage = apiMessageModel.shortMessage;

    ApiLogLevel apiLogLevel = apiMessageModel.apiLogLevel;

    LogLevel logLevel = _getLogLevel(apiLogLevel);

    Map<String, dynamic> extraLogInfo = {}; // log 的 额外信息
    String? serviceValidProxyIp;
    if (apiEnvInfo != null) {
      serviceValidProxyIp = apiEnvInfo.serviceValidProxyIp;
      extraLogInfo.addAll({
        "hasProxy": serviceValidProxyIp != null,
      });
    }

    extraLogInfo.addAll({
      "logApiProcessType": apiProcessType, // 用于区分api日志是要显示哪个阶段(因为已合并成一个模型)
    });
    extraLogInfo.addAll({
      "logApiPath": apiPath, // 临时增加此参数作为测试时候只打印某条接口的日志
    });

    NetworkType connectionStatus = NetworkStatusManager().connectionStatus;
    extraLogInfo.addAll({
      "connectionStatus": connectionStatus.toString(),
    });

    apiShortMessage += '\nconnectionStatus:${connectionStatus.toString()}';
    if (LogUtil.shouldPrintToConsoleFunction(
      LogObjectType.api,
      logLevel,
      extraLogInfo: extraLogInfo,
    )) {
      String consoleLogMessage = apiShortMessage;
      LogUtil.printConsoleLog(
        consoleLogMessage,
        stag: LogUtil.desForLogLevel(logLevel),
      );
    }

    if (LogUtil.shouldShowToPageFunction(
      LogObjectType.api,
      logLevel,
      extraLogInfo: extraLogInfo,
    )) {
      // 页面日志列表里的日志，使用简略信息版，点击详情才查看完整信息版
      String pageLogMessage = apiShortMessage;
      DevLogUtil.addLogModel(
        dateTime: dateTime,
        logType: LogObjectType.api,
        logLevel: logLevel,
        logTitle: '',
        logText: pageLogMessage,
        logInfo: extraLogInfo,
        detailLogModel: apiInfo,
      );
    }

    extraLogInfo.addAll({
      "apiHost": apiHost,
    });
    if (apiInfo.errOptions != null) {
      extraLogInfo.addAll({
        "apiErrorType": apiInfo.errOptions!.type.toString().split('.').last,
      });
    }
    String? robotUrl = LogUtil.postToWechatRobotUrlGetFunction(
      LogObjectType.api,
      logLevel,
      extraLogInfo: extraLogInfo,
    );
    if (robotUrl != null && robotUrl.isNotEmpty) {
      if (isCacheApiLog == true) {
        return; // api请求缓存数据过程中的日志 即使错误页不需要上包
      }

      if (apiFullUrl != null) {
        ApiPostUtil.postApiError(
          robotUrls: [robotUrl],
          apiPath: apiPath,
          apiMessageModel: apiMessageModel,
          serviceValidProxyIp: serviceValidProxyIp,
          connectionStatus: connectionStatus,
        );
      }
    }
  }

  static LogLevel _getLogLevel(ApiLogLevel apiLogLevel) {
    if (apiLogLevel == ApiLogLevel.error_timeout ||
        apiLogLevel == ApiLogLevel.error_other) {
      return LogLevel.error;
    } else if (apiLogLevel == ApiLogLevel.response_warning) {
      return LogLevel.warning;
    } else if (apiLogLevel == ApiLogLevel.response_success) {
      return LogLevel.success;
    } else {
      return LogLevel.normal;
    }
  }
}
