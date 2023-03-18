import 'dart:io' show Platform;
import 'dart:convert' as convert;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:app_environment/app_environment.dart';

import './detail/log_detail_widget.dart';

class AppLogUtil {
  static Completer _initCompleter = Completer<String>();
  static String myRobotKey = 'e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的

  static init({
    required PackageNetworkType originPackageNetworkType,
    required PackageTargetType originPackageTargetType,
    required String packageDescribe,
    required String Function() userDescribeBlock,
  }) async {
    // 如何输出 log 的设置
    LogApiUtil.logMessageBlock = ({
      required LogObjectType logType,
      required LogLevel logLevel,
      String? title,
      required Map<String, dynamic> shortMap,
      required Map<String, dynamic> detailMap,
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
      );
    };
    LogUtil.init(
      tolerantRobotKey: myRobotKey,
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
        /// TODO:正式上生产的时候就不要上报了
        PackageTargetType currentTargetType =
            EnvManagerUtil.packageCurrentTargetModel.type;
        PackageNetworkType currentNetworkType =
            EnvManagerUtil.packageCurrentNetworkModel.type;

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
            logObjectType: logObjectType,
            logLevel: logLevel,
            extraLogInfo: extraLogInfo,
          );
        }

        return null;
      },
      logDetailPageBuilder: (LogModel logModel) {
        if (logModel.detailLogModel is Map) {
          return _mapDetailWidget(logModel);
        } else {
          return Container();
        }
      },
    );

    _initCompleter.complete('log初始化完成，后续 logMessage 才可以正常使用回调判断如何打印log');
    _initApiErrorRobots();
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

  static String? _postToWechatRobotUrl_api({
    required PackageNetworkType originPackageNetworkType,
    required PackageTargetType originPackageTargetType,
    required LogObjectType logObjectType,
    required LogLevel logLevel,
    Map<String, dynamic>? extraLogInfo,
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
    PackageNetworkType currentPackageType =
        EnvManagerUtil.packageCurrentNetworkModel.type;
    // 如果环境是生产环境，但包却不是生产包，则异常先不进行上报
    if (originPackageNetworkType != currentPackageType &&
        currentPackageType == PackageNetworkType.product) {
      return null;
    }

    bool hasProxy = false;
    bool isCacheApiLog = false;
    String? apiHost;
    NetworkErrorType? networkErrorType;
    if (extraLogInfo != null) {
      hasProxy = extraLogInfo['hasProxy'] ?? false;
      apiHost = extraLogInfo["apiHost"];
      isCacheApiLog = extraLogInfo["isCacheApiLog"] ?? false;
      String? apiErrorTypeString = extraLogInfo["apiErrorType"];
      if (apiErrorTypeString != null) {
        networkErrorType =
            NetworkErrorTypeUtil.networkErrorTypeFromString(apiErrorTypeString);
      }
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
    if (networkErrorType == NetworkErrorType.connectTimeout ||
        networkErrorType == NetworkErrorType.sendTimeout ||
        networkErrorType == NetworkErrorType.receiveTimeout) {
      String robotKey_timeout = '9b7e7b8d-b0a3-49a0-9eba-bb8f1111ae55';
      return robotKey_timeout;
    } else {
      if (apiHost == null) {
        return null;
      }
      String? postApiErrorRobotUrl = ApiPostUtil.getRobotUrlByApiHost(apiHost);
      return postApiErrorRobotUrl;
    }
  }

  static Widget _mapDetailWidget(LogModel logModel) {
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
        ToastUtil.showMessage('复制当行到粘贴板成功');
      },
      onPressedClose: () => ApplicationLogViewManager.dismissLogOverlayEntry(
          ApplicationLogViewManager.logDetailOverlayKey),
    );
  }

  static void _initApiErrorRobots() {
    String apiErrorRobotKey_dev2 =
        'de1d8e9d-2d28-4f58-8e66-5fd71fa3d170'; // api异常监控-dev2专属
    String apiErrorRobotKey_dev1 =
        'f49ee9a3-8199-4c1a-9d5c-23c95aa7a3ba'; // api异常监控-dev1专属
    String apiErrorRobotKey_tke =
        'fb5d5015-87b3-4f6a-8e06-04cbef1c3893'; // api异常监控-tke专属
    String apiErrorRobotKey_product =
        '7f3cc810-5a60-46ed-a752-1105d38aae54'; // api异常监控-生产专属

    ApiHostRobotBean robotBean_mock = ApiHostRobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_mock,
      pushToWechatRobots: [
        myRobotKey,
      ],
    );
    ApiHostRobotBean robotBean_dev1 = ApiHostRobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_dev1,
      pushToWechatRobots: [
        apiErrorRobotKey_dev1,
      ],
    );
    ApiHostRobotBean robotBean_dev2 = ApiHostRobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_dev2,
      pushToWechatRobots: [
        apiErrorRobotKey_dev2,
      ],
    );

    ApiHostRobotBean robotBean_preproduct = ApiHostRobotBean(
      errorApiHost: TSEnvironmentDataUtil.networkModel_preProduct.apiHost,
      pushToWechatRobots: [
        apiErrorRobotKey_tke,
      ],
    );
    ApiHostRobotBean robotBean_product = ApiHostRobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_product,
      pushToWechatRobots: [
        apiErrorRobotKey_product,
      ],
    );

    ApiPostUtil.apiErrorRobots = [
      robotBean_mock,
      robotBean_dev1,
      robotBean_dev2,
      robotBean_preproduct,
      robotBean_product,
    ];
  }

  // 打印请求各阶段出现的不同等级的日志信息
  // static void logMessage(
  //   LogLevel logLevel, {
  //   required String shortMessage,
  //   required String detailMessage,
  //   dynamic T implements PageLogMoel,
  // }) {

  // }

  static void logMessage({
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
      ToastUtil.showMessage('发现错误了，快打开日志查看');
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
}

abstract class PageLogMoel {
  String shortMessage();
  String detailMessage();
}
