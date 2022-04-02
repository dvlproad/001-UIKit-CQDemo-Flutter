import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

import '../dev_util.dart';
import './environment_datas_util.dart';
import './package_environment_util.dart';
import './main_diff_util.dart';
export './main_diff_util.dart' show PackageType;

import './log_init.dart';
import './env_init.dart';

class DevToolInit {
  // static String apiHost;
  static String webHost;
  static String gameHost;

  static initWithGlobalKey(
    @required GlobalKey globalKey,
    PackageType packageType, {
    @required void Function() logoutHandleWhenExitAppByChangeNetwork,
    String userApiToken,
    String Function() userDescribeBlock,
    @required void Function() userNeedReloginHandle, // 需要重新登录时候，执行的操作
  }) {
    // 设置打包环境
    MainDiffUtil.packageType = packageType;

    Future.delayed(const Duration(milliseconds: 000), () {
      // 这里的适当延迟，只是为了修复 main() 的第一方法就执行这里的init方法，导致内部执行到 SharedPreferences prefs = await SharedPreferences.getInstance(); 的时候会发生错误
      // 其他情况不用延迟
      _init(
        packageType,
        currentUserApiToken: userApiToken,
        packageUserDescribeBlock: userDescribeBlock,
        userReloginHandle: userNeedReloginHandle,
      );
    });
    _initView(
      globalKey,
      packageType,
      tryLogoutHandle: logoutHandleWhenExitAppByChangeNetwork,
    );
  }

  static _init(
    PackageType packageType, {
    String currentUserApiToken,
    String Function() packageUserDescribeBlock,
    @required void Function() userReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();

    // 网络环境相关
    String packageVersion = packageInfo.version;
    _initNetwork(
      packageType,
      packageVersion: packageVersion,
      currentUserApiToken: currentUserApiToken,
      needReloginHandle: userReloginHandle,
    );

    // log 设置
    String packageDescribe =
        '【${MainDiffUtil.diffPackageBean().des}_${packageInfo.fullPackageDescribe}】';
    _initLog(
      packageType,
      packageDescribe: packageDescribe,
      userDescribeBlock: packageUserDescribeBlock,
    );
  }

  // 如何输出 log 的设置
  static _initLog(
    PackageType packageType, {
    String packageDescribe,
    String Function() userDescribeBlock,
  }) async {
    LogInit.init(
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
      isProductPackageBlock: () {
        return packageType == PackageType.product;
      },
      isProductNetworkBlock: () {
        return EnvInit.isProduct;
      },
    );
    LogInit.initApiErrorRobots();
  }

  static _initView(
    GlobalKey globalKey,
    PackageType packageType, {
    @required void Function() tryLogoutHandle, // 尝试退出登录,仅在切换环境需要退出登录的时候调用
  }) {
    // 开发工具弹窗
    bool shouldShowDevTool = false;
    ImageProvider floatingToolImageProvider; // 悬浮按钮上的图片

    String floatingToolTextDefaultEnv =
        MainDiffUtil.diffPackageBean().des.substring(0, 1); // 悬浮按钮上的文本:此包的默认环境
    if (packageType == PackageType.develop1 ||
        packageType == PackageType.develop2 ||
        packageType == PackageType.preproduct) {
      shouldShowDevTool = true;
    }
    DevUtil.init(
      navigatorKey: globalKey,
      floatingToolImageProvider: floatingToolImageProvider,
      floatingToolTextDefaultEnv: floatingToolTextDefaultEnv,
      updateNetworkCallback: (bNetworkModel) {
        NetworkManager.changeOptions(baseUrl: bNetworkModel.apiHost);
        //apiHost = bNetworkModel.apiHost;
        webHost = bNetworkModel.webHost;
        gameHost = bNetworkModel.gameHost;
      },
      logoutHandleWhenExitAppByChangeNetwork: tryLogoutHandle,
      updateProxyCallback: (bProxyModel) {
        NetworkManager.changeProxy(bProxyModel.proxyIp);
      },
      onPressTestApiCallback: (TestApiScene testApiScene) {
        // 测试环境改变之后，网络请求是否生效
        NetworkKit.post(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
          },
        ).then((value) {
          debugPrint('测试的网络请求结束');
        });
      },
    );
    if (shouldShowDevTool) {
      Future.delayed(const Duration(milliseconds: 3000), () {
        DevUtil.showDevFloatingWidget();
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
  static _initNetwork(
    PackageType packageType, {
    @required String packageVersion,
    @required String currentUserApiToken,
    @required void Function() needReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    // network:api host
    await EnvInit.initNetworkEnvironmentManager(packageType);
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    ApplicationDraggableManager.updateDevToolFloatingIconOverlayEntry(
        selectedNetworkModel.shortName); // 添加当前环境标识
    String baseUrl = selectedNetworkModel.apiHost;
    // network:api token
    String token = currentUserApiToken;
    // network:api commonParams
    Map<String, dynamic> commonParams = {
      'version': packageVersion,
    };
    NetworkKit.start(
      baseUrl: baseUrl,
      token: token,
      commonParams: commonParams,
      allowMock: true,
      mockApiHost: TSEnvironmentDataUtil.apiHost_mock,
      needReloginHandle: needReloginHandle,
    );
    // network:webHost+gameHost
    webHost = selectedNetworkModel.webHost;
    gameHost = selectedNetworkModel.gameHost;

    // proxy:
    await EnvInit.initProxyEnvironmentManager(packageType);
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;
    NetworkManager.changeProxy(selectedProxyModel.proxyIp);

    // check network+proxy+mock
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      PackageEnvironmentUtil.checkShouldResetNetwork(); //检查包的环境
    });
  }

  // 是否是生产环境
  static bool get isProduct => EnvInit.isProduct;
}
