import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import '../dev_util.dart';
import './environment_datas_util.dart';
import './package_environment_util.dart';
import './main_diff_util.dart';
export './main_diff_util.dart' show PackageType;

class DevToolInit {
  static initWithGlobalKey(GlobalKey globalKey, PackageType packageType) {
    // 设置打包环境
    MainDiffUtil.packageType = packageType;

    Future.delayed(const Duration(milliseconds: 000), () {
      // 这里的适当延迟，只是为了修复 main() 的第一方法就执行这里的init方法，导致内部执行到 SharedPreferences prefs = await SharedPreferences.getInstance(); 的时候会发生错误
      // 其他情况不用延迟
      _init(packageType);
    });
    _initView(globalKey, packageType);
  }

  static _init(PackageType packageType) {
    // 网络环境相关
    _initNetwork(packageType); // TODO:请求已开始，但网络环境、代理环境等还没配置

    // 如何输出 log 的设置
    LogUtil.init(
      packageDescribe: MainDiffUtil.diffPackageBean().des,
      printToConsoleBlock: (logLevel, {Map extraLogInfo}) {
        return true;
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
          ComplieMode complieMode = ComplieModeUtil.getCompileMode();
          if (complieMode == ComplieMode.debug) {
            if (hasProxy) {
              // debug 且有代理的时候，如果发生错误，是否通知到企业微信
              shouldPostApiError = false;
            } else {
              shouldPostApiError = true;
            }
          } else {
            shouldPostApiError = true;
          }
        }
        return shouldPostApiError;
      },
    );
  }

  static _initView(GlobalKey globalKey, PackageType packageType) {
    // 开发工具弹窗
    bool shouldShowDevTool = false;
    ImageProvider floatingToolImageProvider; // 悬浮按钮上的图片
    String floatingToolText =
        MainDiffUtil.diffPackageBean().des.substring(0, 1); // 悬浮按钮上的文本
    if (packageType == PackageType.develop1 ||
        packageType == PackageType.develop2 ||
        packageType == PackageType.preproduct) {
      shouldShowDevTool = true;
    }
    DevUtil.init(
      navigatorKey: globalKey,
      floatingToolImageProvider: floatingToolImageProvider,
      floatingToolText: floatingToolText,
    );
    if (shouldShowDevTool) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        DevUtil.showDevFloatingWidget(
          showTestApiWidget: false,
        );
      });
    }

    // 检查更新
    CheckVersionUtil.init(
      isPyger: true,
      pygerAppKeyGetBlock: () {
        if (Platform.isAndroid) {
          return MainDiffUtil.diffPackageBean().pygerAppKeyAndroid;
        } else {
          return MainDiffUtil.diffPackageBean().pygerAppKeyIOS;
        }
      },
      downloadUrlGetBlock: () {
        return MainDiffUtil.diffPackageBean().downloadUrl;
      },
    );
    Future.delayed(const Duration(milliseconds: 1000), () {
      CheckVersionUtil.checkVersion();
    });
  }

  // 配置网络
  static _initNetwork(PackageType packageType) async {
    _initApiErrorRobots();

    // network:api host
    await _initNetworkEnvironmentManager(packageType);
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    String baseUrl = selectedNetworkModel.apiHost;
    // network:api token
    String token = 'await UserInfoManager.instance.getToken()';
    // network:api commonParams
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    Map<String, dynamic> commonParams = {
      'version': packageInfo.version,
    };
    NetworkKit.start(
      baseUrl: baseUrl,
      token: token,
      commonParams: commonParams,
      allowMock: true,
      mockApiHost: TSEnvironmentDataUtil.apiHost_mock,
    );
    // network:webHost+gameHost
    DevUtil.changeHost(
      webHost: selectedNetworkModel.webHost,
      gameHost: selectedNetworkModel.gameHost,
    );

    // proxy:
    await _initProxyEnvironmentManager(packageType);
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;
    DevUtil.changeAllProxy(selectedProxyModel.proxyIp);

    // check network+proxy+mock
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      PackageEnvironmentUtil.checkShouldResetNetwork(); //检查包的环境
    });
  }

  static _initApiErrorRobots() {
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

  /************************* environment 环境设置 *************************/
  // network
  static Future _initNetworkEnvironmentManager(PackageType packageType) async {
    _initEnvShouldExitWhenChangeNetworkEnv();

    String defaultNetworkId_whenNull;
    bool canUseCacheNetwork;
    if (packageType == PackageType.develop1) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId1;
      canUseCacheNetwork = true;
    } else if (packageType == PackageType.develop2) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId2;
      canUseCacheNetwork = true;
    } else if (packageType == PackageType.preproduct) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.preproductNetworkId;
      canUseCacheNetwork = true;
    } else {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.productNetworkId;
      canUseCacheNetwork = false;
    }
    await NetworkPageDataManager().getCurrentNetworkIdAndModels(
      networkModels_whenNull: TSEnvironmentDataUtil.getEnvNetworkModels(),
      defaultNetworkId: defaultNetworkId_whenNull,
      canUseCacheNetwork: canUseCacheNetwork,
    );
  }

  // proxy
  static Future _initProxyEnvironmentManager(PackageType packageType) async {
    bool canUseCacheProxy = false;
    if (packageType == PackageType.develop1) {
      canUseCacheProxy = true;
    } else if (packageType == PackageType.develop2) {
      canUseCacheProxy = true;
    } else if (packageType == PackageType.preproduct) {
      canUseCacheProxy = true;
    } else {
      canUseCacheProxy = false;
    }
    await ProxyPageDataManager().getCurrentProxyIdAndModels(
      TSEnvironmentDataUtil.getEnvProxyModels(),
      TSEnvironmentDataUtil.noneProxykId,
      canUseCacheProxy,
    );
  }

  /// 切换环境的时候要否应该退出 app
  static Future _initEnvShouldExitWhenChangeNetworkEnv() {
    EnvironmentUtil.shouldExitWhenChangeNetworkEnv = (
      TSEnvNetworkModel fromNetworkEnvModel,
      TSEnvNetworkModel toNetworkEnvModel,
    ) {
      if (toNetworkEnvModel.envId == TSEnvironmentDataUtil.mockNetworkId) {
        return false;
      }
      return true;
    };
  }
}
