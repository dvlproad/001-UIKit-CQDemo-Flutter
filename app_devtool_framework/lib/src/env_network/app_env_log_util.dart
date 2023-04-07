// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:app_environment/app_environment.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';

import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_robot_base/flutter_robot_base.dart';

class AppEnvLogUtil {
  static final Completer _initCompleter = Completer<String>();
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
      AppLogUtil.logMessage(
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
    AppLogUtil.init(
      tolerantRobotKey: myRobotKey,
      originPackageNetworkType: originPackageNetworkType,
      originPackageTargetType: originPackageTargetType,
      currentNetworkTypeGetBlock: () {
        PackageNetworkType currentNetworkType =
            NetworkPageDataManager().selectedNetworkModel.type;
        return currentNetworkType;
      },
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
      isForceNoUploadEnvGetBlock: () {
        /// 上报企业微信的处理：上架包不上报企业微信，内测包和测试包可以
        PackageTargetType currentTargetType =
            PackageTargetPageDataManager().selectedTargetModel.type;
        PackageNetworkType currentNetworkType =
            NetworkPageDataManager().selectedNetworkModel.type;
        if (currentTargetType == PackageTargetType.formal &&
            currentNetworkType == PackageNetworkType.product) {
          return true;
        }

        return false;
      },
      getRobotUrlByApiHostBlock: (String apiHost) {
        return ApiPostUtil.getRobotUrlByApiHost(apiHost);
      },
    );

    _initCompleter.complete('log初始化完成，后续 logMessage 才可以正常使用回调判断如何打印log');
    _initApiErrorRobots();
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
}
