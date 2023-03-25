// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';

import 'package:app_updateversion_kit/app_updateversion_kit.dart';
import 'package:app_environment/app_environment.dart';
import 'package:app_service_user/app_service_user.dart';

import 'package:app_global_config/app_global_config.dart';

import '../env_network/app_env_log_util.dart';
import '../env_network/app_env_network_util.dart';

import '../dev_util.dart';

class DevToolInit {
  // static String apiHost;
  static String webHost = NetworkPageDataManager().selectedNetworkModel.webHost;
  static String gameHost =
      NetworkPageDataManager().selectedNetworkModel.gameHost;

  static Future<void> initWithGlobalKey(
    GlobalKey<NavigatorState> globalKey,
    PackageNetworkType originPackageNetworkType,
    PackageTargetType originPackageTargetType, {
    required void Function() logoutHandleWhenExitAppByChangeNetwork,
    String? userApiToken,
    required String channelName,
    required String Function() logUserDescribeBlock, // 给log使用的用户描述
    required void Function() userNeedReloginHandle, // 需要重新登录时候，执行的操作
    void Function(BuildContext bContext)? onFloatingToolDoubleTap,
  }) async {
    // 设置打包环境
    await _initNetworkAndProxy(
      originPackageNetworkType,
      originPackageTargetType,
      globalKey: globalKey,
      channelName: channelName,
      tryLogoutHandle: logoutHandleWhenExitAppByChangeNetwork,
      currentUserApiToken: userApiToken,
      userReloginHandle: userNeedReloginHandle,
    );

    PackageTargetModel selectedTargetModel =
        PackageTargetPageDataManager().selectedTargetModel;
    PackageTargetType selectedPackageTargetType = selectedTargetModel.type;

    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    // log 设置(含如何输出等)
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String packageDescribe = '【';
    packageDescribe += '${EnvManagerUtil.appTargetNetworkString(
      containLetter: true,
    )}';
    packageDescribe += '_${packageInfo.fullPackageDescribe}';
    packageDescribe += '】';
    AppEnvLogUtil.init(
      originPackageNetworkType: originPackageNetworkType,
      originPackageTargetType: originPackageTargetType,
      packageDescribe: packageDescribe,
      userDescribeBlock: logUserDescribeBlock,
    );

    _initDebugTool(
      globalKey,
      originEnvNetworkType: originPackageNetworkType,
      currentEnvNetworkModel: selectedNetworkModel,
      originPackageTargetType: originPackageTargetType,
      currentPackageTargetModel: selectedTargetModel,
      onFloatingToolDoubleTap: onFloatingToolDoubleTap,
    );
    // }

    // 检查更新
    _initCheckVersion(
        originPackageNetworkType, selectedPackageTargetType, globalKey);
  }

  static _initNetworkAndProxy(
    PackageNetworkType originPackageNetworkType,
    PackageTargetType originPackageTargetType, {
    required String channelName,
    required GlobalKey globalKey,
    required void Function() tryLogoutHandle, // 尝试退出登录,仅在切换环境需要退出登录的时候调用
    String? currentUserApiToken,
    required void Function() userReloginHandle, // 需要重新登录时候，执行的操作
  }) async {
    // 配置网络
    await AppNetworkKit.start(
      originPackageNetworkType,
      originPackageTargetType,
      channelName: channelName,
      token: currentUserApiToken,
      needReloginHandle: userReloginHandle,
      forceNoToastStatusCodesGetFunction: () {
        GlobalNetworkConfigBean? globalNetworkConfigBean =
            GlobalConfig.networkConfig();
        if (globalNetworkConfigBean == null) {
          return null;
        }
        return globalNetworkConfigBean.noToastForCodes;
      },
      uidGetBlock: () {
        String? uid = UserInfoManager().userModel.userId;
        if (uid == null) {
          debugPrint("Errror:uid不能为空,请检查，下方先临时赋值，让其通过");
          uid = '0';
        }
        return uid;
      },
    );

    AppNetworkKit.initWithPage(
      navigatorKey: globalKey,
      logoutHandleWhenExitAppByChangeNetwork: tryLogoutHandle,
    );
  }

  static _initDebugTool(
    GlobalKey<NavigatorState> globalKey, {
    required PackageNetworkType originEnvNetworkType,
    required TSEnvNetworkModel currentEnvNetworkModel,
    required PackageTargetType originPackageTargetType,
    required PackageTargetModel currentPackageTargetModel,
    void Function(BuildContext bContext)? onFloatingToolDoubleTap,
  }) {
    // 开发工具弹窗
    bool shouldShowDevTool = false;
    if (originEnvNetworkType == PackageNetworkType.develop1 ||
        originEnvNetworkType == PackageNetworkType.develop2 ||
        originEnvNetworkType == PackageNetworkType.test1 ||
        originEnvNetworkType == PackageNetworkType.preproduct) {
      shouldShowDevTool = true;
    }
    ImageProvider? floatingToolImageProvider; // 悬浮按钮上的图片

    TSEnvNetworkModel originNetworkModel =
        NetworkPageDataManager().originNetworkModel;

    PackageTargetModel originTargetModel =
        EnvManagerUtil.packageDefaultTargetModel;

    DevUtil.init(
      navigatorKey: globalKey,
      floatingToolImageProvider: floatingToolImageProvider,
      floatingToolTextNetworkNameOrigin: originNetworkModel.shortName,
      floatingToolTextNetworkNameCurrent: currentEnvNetworkModel.shortName,
      floatingToolTextTargetNameOrigin: originTargetModel.shortName,
      floatingToolTextTargetNameCurrent: currentPackageTargetModel.shortName,
      onFloatingToolDoubleTap: onFloatingToolDoubleTap,
      overlayEntryShouldShowIfNil: shouldShowDevTool,
    );
  }

  static _initCheckVersion(
    PackageNetworkType originPackageNetworkType,
    PackageTargetType selectedPackageTargetType,
    GlobalKey<State<StatefulWidget>> globalKey,
  ) async {
    if (selectedPackageTargetType == PackageTargetType.dev) {
      CheckVersionUtil.initVersion(globalKey, useOtherVersionApi: true);
    } else {
      CheckVersionUtil.initVersion(globalKey, useOtherVersionApi: false);
    }

    Future.delayed(const Duration(milliseconds: 1000), () {
      CheckVersionUtil.checkVersion();
    });
  }

  // 当前是否是生产网络环境
  static bool get isProductNetwork {
    PackageNetworkType currentPackageNetworkType =
        NetworkPageDataManager().selectedNetworkModel.type;
    return currentPackageNetworkType == PackageNetworkType.product;
  }

  // 初始是否是生产环境包
  static bool get isProductPackage {
    return EnvManagerUtil.isPackageNetworkProduct;
  }

  // 初始是否是蒲公英上的包
  static bool get isPackageTargetDev {
    return EnvManagerUtil.isPackageTargetDev;
  }
}
