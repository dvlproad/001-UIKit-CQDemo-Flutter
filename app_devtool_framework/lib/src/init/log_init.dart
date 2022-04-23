import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:app_environment/app_environment.dart';

class LogInit {
  static init({
    @required String packageDescribe,
    String Function() userDescribeBlock,
    @required bool Function() isProductPackageBlock,
    @required bool Function() isProductNetworkBlock,
  }) async {
    // 如何输出 log 的设置
    LogUtil.init(
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
      printToConsoleBlock: (logLevel, {Map extraLogInfo}) {
        return false;
      },
      showToPageBlock: (logLevel, {Map extraLogInfo}) {
        return true;
      },
      postToWechatBlock: (logLevel, {Map extraLogInfo}) {
        bool shouldPostApiError = false; // 是否应该上报到企业微信
        // String serviceValidProxyIp = NetworkManager.serviceValidProxyIp;
        bool hasProxy = false;
        if (extraLogInfo != null) {
          hasProxy = extraLogInfo['hasProxy'] ?? false;
        }
        if (logLevel == LogLevel.error) {
          // 如果环境是生产环境，但包却不是生产包，则异常先不进行上报
          bool isProductNetwork = isProductNetworkBlock();
          bool isProductPackage = isProductPackageBlock();
          if (isProductNetwork) {
            if (!isProductPackage) {
              return false;
            }
          }

          ComplieMode complieMode = ComplieModeUtil.getCompileMode();
          if (complieMode == ComplieMode.debug) {
            if (hasProxy) {
              // debug 且有代理的时候，如果发生错误，是否通知到企业微信
              shouldPostApiError = false;
            } else {
              shouldPostApiError = false;
            }
          } else {
            shouldPostApiError = true;
          }
        }
        return shouldPostApiError;
      },
    );
  }

  static initApiErrorRobots() {
    String myRobotUrl =
        'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=e3c3f7f1-5d03-42c5-8c4a-a3d25d7a8587'; // 单个人测试用的
    String apiErrorRobotUrl_dev2 =
        'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=de1d8e9d-2d28-4f58-8e66-5fd71fa3d170'; // api异常监控-dev2专属
    String apiErrorRobotUrl_dev1 =
        'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=f49ee9a3-8199-4c1a-9d5c-23c95aa7a3ba'; // api异常监控-dev1专属
    String apiErrorRobotUrl_tke =
        'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=fb5d5015-87b3-4f6a-8e06-04cbef1c3893'; // api异常监控-tke专属
    String apiErrorRobotUrl_product =
        'https://qyapi.weixin.qq.com/cgi-bin/webhook/send?key=7f3cc810-5a60-46ed-a752-1105d38aae54'; // api异常监控-生产专属

    RobotBean robotBean_mock = RobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_mock,
      pushToWechatRobots: [
        myRobotUrl,
      ],
    );
    RobotBean robotBean_dev1 = RobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_dev1,
      pushToWechatRobots: [
        apiErrorRobotUrl_dev1,
      ],
    );
    RobotBean robotBean_dev2 = RobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_dev2,
      pushToWechatRobots: [
        apiErrorRobotUrl_dev2,
      ],
    );

    RobotBean robotBean_preproduct = RobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_preProduct,
      pushToWechatRobots: [
        apiErrorRobotUrl_tke,
      ],
    );
    RobotBean robotBean_product = RobotBean(
      errorApiHost: TSEnvironmentDataUtil.apiHost_product,
      pushToWechatRobots: [
        apiErrorRobotUrl_product,
      ],
    );

    ApiErrorRobot.apiErrorRobots = [
      robotBean_mock,
      robotBean_dev1,
      robotBean_dev2,
      robotBean_preproduct,
      robotBean_product,
    ];
  }
}
