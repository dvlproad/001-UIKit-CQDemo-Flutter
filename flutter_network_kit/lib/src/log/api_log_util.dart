/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:09:10
 * @Description: 打印网络日志的工具类
 */
import 'dart:async';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_network/flutter_network.dart';
import './bean/api_describe_bean.dart';
import './util/api_describe_util.dart';
import '../networkStatus/network_status_manager.dart';

typedef LogMessageBlock = void Function({
  required LogObjectType logType,
  required LogLevel logLevel,
  String? title,
  required Map<String, dynamic> shortMap,
  required Map<String, dynamic> detailMap,
  Map<String, dynamic>? extraLogInfo, // log 的 额外信息
  RobotPostType? postType,
  List<String>? mentionedList,
});

class LogApiUtil {
  static Completer _initCompleter = Completer<String>();

  static LogMessageBlock? _logMessageBlock;
  static set logMessageBlock(LogMessageBlock? logMessageBlock) {
    _logMessageBlock = logMessageBlock;
    _initCompleter.complete('log初始化完成，后续 logMessage 才可以正常使用回调判断如何打印log');
  }

  // 打印请求各阶段出现的不同等级的日志信息
  static void logApiInfo(
    NetOptions apiInfo,
    ApiProcessType apiProcessType, {
    ApiEnvInfo? apiEnvInfo,
  }) async {
    await _initCompleter.future;

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

    ApiLogLevel apiLogLevel = apiMessageModel.apiLogLevel;

    LogLevel logLevel = _getLogLevel(apiLogLevel);

    Map<String, dynamic> extraLogInfo = {}; // log 的 额外信息
    extraLogInfo.addAll({
      "isCacheApiLog": isCacheApiLog,
    });

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

    LogObjectType logObjectType = LogObjectType.api_app;
    if (isCacheApiLog) {
      logObjectType = LogObjectType.api_cache;
    }
    if (apiPath.contains('bi/sendMessage')) {
      logObjectType = LogObjectType.api_buriedPoint;
    }

    extraLogInfo.addAll({
      "apiHost": apiHost,
    });
    if (apiInfo.errOptions != null) {
      extraLogInfo.addAll({
        "apiErrorType": apiInfo.errOptions!.type.toString().split('.').last,
      });
    }

    // logHeaderTitle
    String customMessage = '';
    customMessage += 'connectionStatus:${connectionStatus.toString()}';
    if (serviceValidProxyIp != null && serviceValidProxyIp.isNotEmpty) {
      customMessage += '\n(附:该使用者当前有添加$serviceValidProxyIp代理)';
    }
    customMessage += '\n${apiMessageModel.logHeaderString}';
    extraLogInfo.addAll({"logHeaderTitle": customMessage});

    // String logHeaderTitle = apiMessageModel.logHeaderString;
    // extraLogInfo.addAll({
    //   "logHeaderTitle": logHeaderTitle,
    // });

    //要上报的必须是完整信息，不能是日志列表里的简略信息

    Map<String, dynamic> shortMap = apiMessageModel.shortLogJsonMap;
    shortMap.addAll({
      "connectionStatus": 'connectionStatus:${connectionStatus.toString()}'
    });

    Map<String, dynamic> detailMap = apiMessageModel.detailLogJsonMap;

    // 需要通过其path判断接口负责人
    // logFotterMessage
    ApiErrorDesBean apiErrorDesBean =
        ApiDescirbeUtil.apiDescriptionBeanByApiPath(apiPath);
    extraLogInfo.addAll({"logFotterMessage": apiErrorDesBean.des});
    List<String> mentionedList = apiErrorDesBean.allPids();

    String title = '';
    RobotPostType postType; // 日志等级(决定上报方式:超时的请求错误上报使用文件折叠,其他用纯文本铺开)
    if (apiLogLevel == ApiLogLevel.error_other) {
      postType = RobotPostType.text;
    } else if (apiLogLevel == ApiLogLevel.error_timeout) {
      postType = RobotPostType.file;

      if (apiMessageModel.errorType != null) {
        String errorTypeString =
            apiMessageModel.errorType.toString().split('.').last;
        title += "[$errorTypeString]";
      }
    } else if (apiLogLevel == ApiLogLevel.response_success ||
        apiLogLevel == ApiLogLevel.response_warning) {
      postType = RobotPostType.file;
      // title += "statusCode:${apiMessageModel.statusCode}_businessCode:${apiMessageModel.businessCode}";
      title += "[code:${apiMessageModel.businessCode}]";
    } else {
      postType = RobotPostType.file;
    }
    title += "$apiPath";

    _logMessageBlock!(
      logType: logObjectType,
      logLevel: logLevel,
      title: title,
      shortMap: shortMap,
      detailMap: detailMap,
      extraLogInfo: extraLogInfo,
      postType: postType,
      mentionedList: mentionedList,
    );
  }

  static void logCancelApi(String api) async {
    await _initCompleter.future;

    String message =
        '该请求必须登录后才能调用,但上层业务缺少判断给调用了,为防止报401错误,导致界面上弹出token不能不空的toast,底层直接将该请求请求代码return取消掉(若不需要登录,请在白名单headerAuthorizationWhiteList中添加;若要去掉此行警告提示,请上层业务判断是否登录了)';

    _logMessageBlock!(
      logType: LogObjectType.api_app,
      logLevel: LogLevel.warning,
      title: '此时token为空，且该请求又不在token为空可继续请求的白名单中,估直接放弃请求',
      shortMap: {
        "api": api,
        "message": message,
      },
      detailMap: {
        "api": api,
        "message": message,
      },
      extraLogInfo: null,
      postType: null,
      mentionedList: null,
    );
  }

  static void logNetworkStatus({
    required NetworkType oldConnectionStatus,
    required NetworkType curConnectionStatus,
  }) async {
    await _initCompleter.future;

    _logMessageBlock!(
      logType: LogObjectType.monitor_network,
      logLevel: LogLevel.success,
      title: null,
      shortMap: {
        "curConnectionStatus": curConnectionStatus.toString().split('.').last,
      },
      detailMap: {
        "oldConnectionStatus": oldConnectionStatus.toString().split('.').last,
        "curConnectionStatus": curConnectionStatus.toString().split('.').last,
      },
      extraLogInfo: null,
      postType: null,
      mentionedList: null,
    );
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
