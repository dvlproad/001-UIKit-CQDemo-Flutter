import 'dart:io';
import 'dart:async';
import 'package:meta/meta.dart';

import 'package:flutter/material.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
export 'package:flutter_environment/flutter_environment.dart'
    show
        TSEnvNetworkModel,
        TSEnvProxyModel,
        PackageTargetModel,
        NetworkPageDataManager,
        ProxyPageDataManager,
        PackageTargetPageDataManager,
        ApiManager;

/// 测试API的场景类型
enum TestApiScene {
  changeNetworkEnv,
  changeProxyEnv,
  changeShouldMock,
}

class EnvPageUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static late GlobalKey _navigatorKey;

  // 定义 navigatorKey 属性的 get 和 set 方法
  static GlobalKey get navigatorKey => _navigatorKey;

  static late void Function(TSEnvNetworkModel bNetworkModel)
      _updateNetworkCallback;
  static late void Function()
      _logoutHandleWhenExitAppByChangeNetwork; // 尝试退出登录,仅在切换环境需要退出登录的时候调用
  static late void Function(TSEnvProxyModel bProxyModel) _updateProxyCallback;
  static void Function(TestApiScene testApiScene)? _onPressTestApiCallback;

  static void initWithPage({
    required GlobalKey navigatorKey,
    required void Function(TSEnvNetworkModel bNetworkModel)
        updateNetworkCallback,
    required void Function() logoutHandleWhenExitAppByChangeNetwork,
    required Function(TSEnvProxyModel bProxyModel) updateProxyCallback,
    void Function(TestApiScene testApiScene)? onPressTestApiCallback,
  }) {
    _navigatorKey = navigatorKey; // ①悬浮按钮的显示功能需要

    _updateNetworkCallback = updateNetworkCallback;
    _logoutHandleWhenExitAppByChangeNetwork =
        logoutHandleWhenExitAppByChangeNetwork;
    _updateProxyCallback = updateProxyCallback;
    _onPressTestApiCallback = onPressTestApiCallback;
  }

  static Future goChangeEnvironmentNetwork(BuildContext context) {
    return EnvironmentUtil.goChangeEnvironmentNetwork(
      context,
      onPressTestApiCallback: () {
        if (_onPressTestApiCallback != null) {
          _onPressTestApiCallback!(TestApiScene.changeNetworkEnv);
        }
      },
      updateNetworkCallback: (bNetworkModel, {required bool shouldExit}) {
        changeEnv(bNetworkModel, shouldExit, context: context);
      },
    );
  }

  static Future goChangeEnvironmentTarget(BuildContext context) {
    return EnvironmentUtil.goChangeEnvironmentTarget(
      context,
      updateTargetCallback: (PackageTargetModel bTargetModel) {
        changePackageTarget(bTargetModel, context: context);
      },
    );
  }

  static Future goChangeEnvironmentProxy(BuildContext context) {
    return EnvironmentUtil.goChangeEnvironmentProxy(
      context,
      onPressTestApiCallback: () {
        if (_onPressTestApiCallback != null) {
          _onPressTestApiCallback!(TestApiScene.changeProxyEnv);
        }
      },
      updateProxyCallback: (TSEnvProxyModel bProxyModel) {
        changeProxyTo(bProxyModel);
      },
    );
  }

  static void changeProxyToNone() {
    TSEnvProxyModel proxyModel = TSEnvProxyModel.noneProxyModel();
    changeProxyTo(proxyModel);
  }

  static void changeProxyTo(TSEnvProxyModel proxyModel) {
    /// ①修改代理环境_页面数据
    ProxyPageDataManager().addOrUpdateEnvProxyModel(newProxyModel: proxyModel);

    /// ②修改代理环境_SDK数据
    _updateProxyCallback(proxyModel);
  }

  static void changeEnv(
    TSEnvNetworkModel bNetworkModel,
    bool shouldExit, {
    required BuildContext context,
  }) {
    /// ①修改网络环境_页面数据
    NetworkPageDataManager().updateNetworkPageSelectedData(bNetworkModel);

    /// ②修改网络环境_SDK数据
    _updateNetworkCallback(bNetworkModel);

    /// ③修改网络环境_更改完数据后，是否退出应用
    if (shouldExit == true) {
      exitApp(context);
    }
  }

  static void changePackageTarget(
    PackageTargetModel packageTargetModel, {
    required BuildContext context,
  }) {
    /// ①修改网络环境_页面数据
    PackageTargetPageDataManager()
        .updatePackageTargetPageSelectedData(packageTargetModel);

    /// ②修改网络环境_SDK数据

    /// ③修改网络环境_更改完数据后，是否退出应用
    exitApp(context);
  }

  static void exitApp(BuildContext context) {
    if (_logoutHandleWhenExitAppByChangeNetwork != null) {
      _logoutHandleWhenExitAppByChangeNetwork();
    } else {
      throw Exception("切换环境，需要退出app，但你没尝试优先退出登录");
    }

    // Future.delayed(const Duration(milliseconds: 500), () {
    LoadingUtil.showDongingTextInContext(
      context,
      '退出中...',
      milliseconds: 500,
      completeBlock: () {
        // [Flutter如何有效地退出程序](https://zhuanlan.zhihu.com/p/191052343)
        exit(0); // 需要 import 'dart:io';
        // SystemNavigator.pop(); // 该方法在iOS中并不适用。需要  import 'package:flutter/services.dart';
      },
    );
  }

  static Future goChangeApiMock(BuildContext context) {
    return EnvironmentUtil.goChangeApiMock(
      context,
      onPressTestApiCallback: () {
        if (_onPressTestApiCallback != null) {
          _onPressTestApiCallback!(TestApiScene.changeShouldMock);
        }
      },
    );
  }

  /// 更新悬浮按钮上的数据
  static void updateFloatingTool({
    ImageProvider? imageProvider, // 悬浮按钮上的图片
    String? envText, // 悬浮按钮上的文本:此包的默认环境
    String? targetText, // 悬浮按钮上的文本:此包的发布网站
    required String currentNetworkName, // 悬浮按钮上的文本:此包的当前网络环境
  }) {
    if (currentNetworkName != null) {
      ApplicationDraggableManager.updateDevToolFloatingIconOverlayEntry(
        currentNetworkName,
      );
    }
  }
}
