import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:app_network/app_network.dart';
import 'package:app_log/app_log.dart';
import 'package:app_updateversion_kit/app_updateversion_kit.dart';
import 'package:app_environment/app_environment.dart';

import '../dev_util.dart';
import '../apns_util.dart';

import '../eventbus/dev_tool_eventbus.dart';

import './dev_common_params.dart';

class DevToolInit {
  // static String apiHost;
  static String webHost;
  static String gameHost;

  static Future initWithGlobalKey(
    @required GlobalKey globalKey,
    PackageType originPackageType,
    PackageTargetType originPackageTargetType, {
    @required void Function() logoutHandleWhenExitAppByChangeNetwork,
    String userApiToken,
    String Function() userDescribeBlock,
    @required void Function() userNeedReloginHandle, // 需要重新登录时候，执行的操作
    void Function(BuildContext bContext) onFloatingToolDoubleTap,
  }) async {
    // 设置打包环境
    MainDiffUtil.init(
      m_packageEnvType: originPackageType,
      m_packageTargetType: originPackageTargetType,
    );

    await _initNetworkAndProxy(
      originPackageType,
      originPackageTargetType,
      globalKey: globalKey,
      tryLogoutHandle: logoutHandleWhenExitAppByChangeNetwork,
      currentUserApiToken: userApiToken,
      packageUserDescribeBlock: userDescribeBlock,
      userReloginHandle: userNeedReloginHandle,
    );

    await PackageTargetEnvUtil.initPackageTargetManager(
        originPackageType, originPackageTargetType);

    PackageTargetModel selectedPackageTargetModel =
        PackageTargetPageDataManager().selectedPackageTargetModel;
    PackageTargetType selectedPackageTargetType =
        selectedPackageTargetModel.type;

    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    // log 设置(含如何输出等)
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String packageDescribe =
        '【${MainDiffUtil.diffPackageBean().des}_${packageInfo.fullPackageDescribe}】';
    AppLogUtil.init(
      originPackageType: originPackageType,
      originPackageTargetType: originPackageTargetType,
      packageDescribe: packageDescribe,
      userDescribeBlock: userDescribeBlock,
    );

    _initDebugTool(
      globalKey,
      originEnvNetworkType: originPackageType,
      currentEnvNetworkModel: selectedNetworkModel,
      originPackageTargetType: originPackageTargetType,
      currentPackageTargetType: selectedPackageTargetType,
      onFloatingToolDoubleTap: onFloatingToolDoubleTap,
    );
    // }

    // 检查更新
    _initCheckVersion(originPackageType, selectedPackageTargetType, globalKey);
  }

  static _initNetworkAndProxy(
    PackageType originPackageType,
    PackageTargetType packageTargetType, {
    @required GlobalKey globalKey,
    @required void Function() tryLogoutHandle, // 尝试退出登录,仅在切换环境需要退出登录的时候调用
    String currentUserApiToken,
    String Function() packageUserDescribeBlock,
    @required void Function() userReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();

    // 环境初始化
    // 设置打包环境
    MainDiffUtil.packageType = originPackageType;

    // network:api host
    await EnvManagerUtil.initNetworkEnvironmentManager(originPackageType);
    await NetworkPageDataManager().initCompleter.future;
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    PackageType currentPackageType = EnvManagerUtil.currentPackageType;

    // proxy:
    await EnvManagerUtil.initProxyEnvironmentManager(originPackageType);
    await ProxyPageDataManager().initCompleter.future;
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;

    hasInitCompleter_Env = true;
    devtoolEventBus.fire(DevtoolEnvironmentInitCompleteEvent());

    String packageVersion = packageInfo.version;
    await _initNetwork(
      originPackageType,
      selectedNetworkModel: selectedNetworkModel,
      selectedProxyModel: selectedProxyModel,
      packageVersion: packageVersion,
      currentUserApiToken: currentUserApiToken,
      needReloginHandle: userReloginHandle,
    );

    // 网络环境相关：环境切换界面
    EnvPageUtil.initWithPage(
      navigatorKey: globalKey,
      updateNetworkCallback: (bNetworkModel) {
        AppNetworkKit.changeOptions(bNetworkModel);
        //apiHost = bNetworkModel.apiHost;
        webHost = bNetworkModel.webHost;
        gameHost = bNetworkModel.gameHost;
      },
      logoutHandleWhenExitAppByChangeNetwork: tryLogoutHandle,
      updateProxyCallback: (bProxyModel) {
        AppNetworkKit.changeProxy(bProxyModel.proxyIp);
      },
      onPressTestApiCallback: (TestApiScene testApiScene) {
        // 测试环境改变之后，网络请求是否生效
        AppNetworkKit.post(
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
  }

  static _initDebugTool(
    GlobalKey globalKey, {
    @required PackageType originEnvNetworkType,
    @required TSEnvNetworkModel currentEnvNetworkModel,
    @required PackageTargetType originPackageTargetType,
    @required PackageTargetType currentPackageTargetType,
    void Function(BuildContext bContext) onFloatingToolDoubleTap,
  }) {
    // 开发工具弹窗
    bool shouldShowDevTool = false;
    if (originEnvNetworkType == PackageType.develop1 ||
        originEnvNetworkType == PackageType.develop2 ||
        originEnvNetworkType == PackageType.preproduct) {
      shouldShowDevTool = true;
    }
    ImageProvider floatingToolImageProvider; // 悬浮按钮上的图片
    String floatingToolTextNetworkNameOrigin =
        MainDiffUtil.diffPackageBean().des.substring(0, 1); // 悬浮按钮上的文本:此包的默认环境

    String floatingToolTextTargetNameOrigin = '';
    if (originPackageTargetType == PackageTargetType.formal) {
      floatingToolTextTargetNameOrigin = '外';
    } else if (originPackageTargetType == PackageTargetType.pgyer) {
      floatingToolTextTargetNameOrigin = '内';
    }

    String floatingToolTextTargetNameCurrent = '';
    if (currentPackageTargetType == PackageTargetType.formal) {
      floatingToolTextTargetNameCurrent = '外';
    } else if (currentPackageTargetType == PackageTargetType.pgyer) {
      floatingToolTextTargetNameCurrent = '内';
    }

    DevUtil.init(
      navigatorKey: globalKey,
      floatingToolImageProvider: floatingToolImageProvider,
      floatingToolTextNetworkNameOrigin: floatingToolTextNetworkNameOrigin,
      floatingToolTextNetworkNameCurrent: currentEnvNetworkModel.shortName,
      floatingToolTextTargetNameOrigin: floatingToolTextTargetNameOrigin,
      floatingToolTextTargetNameCurrent: floatingToolTextTargetNameCurrent,
      onFloatingToolDoubleTap: onFloatingToolDoubleTap,
      overlayEntryShouldShowIfNil: shouldShowDevTool,
    );
  }

  static _initCheckVersion(
    PackageType originPackageType,
    PackageTargetType selectedPackageTargetType,
    GlobalKey<State<StatefulWidget>> globalKey,
  ) async {
    if (selectedPackageTargetType == PackageTargetType.pgyer) {
      UpdateAppType pgyerAppType;
      if (originPackageType == PackageType.develop1) {
        pgyerAppType = UpdateAppType.develop1;
      } else if (originPackageType == PackageType.develop2) {
        pgyerAppType = UpdateAppType.develop2;
      } else if (originPackageType == PackageType.preproduct) {
        pgyerAppType = UpdateAppType.preproduct;
      } else if (originPackageType == PackageType.product) {
        pgyerAppType = UpdateAppType.product;
      } else {
        pgyerAppType = UpdateAppType.product;
      }
      CheckVersionUtil.initPyger(pgyerAppType, globalKey);
    } else {
      CheckVersionUtil.initSytem(globalKey);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      CheckVersionUtil.checkVersion();
    });
  }

  // 配置网络
  static bool hasInitCompleter_Env = false;
  static _initNetwork(
    PackageType originPackageType, {
    @required TSEnvNetworkModel selectedNetworkModel,
    @required TSEnvProxyModel selectedProxyModel,
    @required String packageVersion,
    @required String currentUserApiToken,
    @required void Function() needReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    // network:api host
    String baseUrl = selectedNetworkModel.apiHost;
    // network:api token
    String token = currentUserApiToken;
    // network:api commonParams

    Map<String, dynamic> commonHeaderParams =
        await CommonParamsHelper.commonHeaderParams();

    Map<String, dynamic> monitorCommonBodyParams = {};
    Map<String, dynamic> monitorPublicParamsMap =
        await CommonParamsHelper.fixedCommonParams();
    String monitorPublicParamsString =
        FormatterUtil.convert(monitorPublicParamsMap, 0);
    monitorCommonBodyParams.addAll({
      "DataHubId": selectedNetworkModel.monitorDataHubId,
      "Public": monitorPublicParamsString,
    });

    AppNetworkKit.start(
      commonHeaderParams: commonHeaderParams,
      baseUrl: baseUrl,
      monitorBaseUrl: selectedNetworkModel.monitorApiHost,
      token: token,
      commonBodyParams: {},
      monitorCommonBodyParams: monitorCommonBodyParams,
      allowMock: true,
      mockApiHost: TSEnvironmentDataUtil.apiHost_mock,
      needReloginHandle: needReloginHandle,
    );
    // network:webHost+gameHost
    webHost = selectedNetworkModel.webHost;
    gameHost = selectedNetworkModel.gameHost;

    // proxy:
    AppNetworkKit.changeProxy(selectedProxyModel.proxyIp);

    // check network+proxy+mock
    Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      PackageEnvironmentUtil.checkShouldResetNetwork(); //检查包的环境
    });
  }

  // 是否是生产网络环境
  static bool get isProductNetwork {
    if (!hasInitCompleter_Env) {
      throw Exception("Error:网络库环境初始化未完成，无法正确获取网络环境，请确保执行完了 _initNetwork");
    }
    return EnvManagerUtil.isProductNetwork;
  }

  // 是否是生产包
  static bool get isProductPackage {
    return EnvManagerUtil.isProductPackage;
  }

  // 是否是蒲公英上的包
  static bool get isPackageTargetPgyer {
    return EnvManagerUtil.isPackageTargetPgyer;
  }
}
