/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-19 03:38:08
 * @Description: 环境初始化类
 */

import 'dart:io';
import 'package:flutter_environment/flutter_environment.dart';

import './init/environment_datas_util.dart';

import './check_update/env_page_util.dart';

import './eventbus/dev_tool_eventbus.dart';
import './env_extension_bean.dart';

class EnvManagerUtil {
  static late PackageNetworkType _originPackageNetworkType;
  static late PackageTargetType _originPackageTargetType;

  /************************* environment 环境设置 *************************/
  static bool hasInitCompleter_Env = false;
  static init_target_network_proxy({
    required PackageTargetType originPackageTargetType,
    required PackageNetworkType originPackageNetworkType,
  }) async {
    // 环境初始化
    // network:api host
    await EnvManagerUtil.initNetworkEnvironmentManager(
        originPackageNetworkType);
    await NetworkPageDataManager().initCompleter.future;
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    // proxy:
    await EnvManagerUtil.initProxyEnvironmentManager(originPackageNetworkType);
    await ProxyPageDataManager().initCompleter.future;
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;

    // target:
    await EnvManagerUtil.initPackageTargetManager(
        originPackageNetworkType, originPackageTargetType);
    await PackageTargetPageDataManager().initCompleter.future;
    PackageTargetModel selectedTargetModel =
        PackageTargetPageDataManager().selectedTargetModel;

    hasInitCompleter_Env = true;
    devtoolEventBus.fire(DevtoolEnvironmentInitCompleteEvent());
  }

  // network
  static Future<Null> initNetworkEnvironmentManager(
      PackageNetworkType packageNetworkType) async {
    _originPackageNetworkType = packageNetworkType;

    _initEnvShouldExitWhenChangeNetworkEnv();

    String defaultNetworkId_whenNull;
    bool canUseCacheNetwork;
    if (packageNetworkType == PackageNetworkType.develop1) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId1;
      canUseCacheNetwork = true;
    } else if (packageNetworkType == PackageNetworkType.develop2) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.developNetworkId2;
      canUseCacheNetwork = true;
    } else if (packageNetworkType == PackageNetworkType.test1) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.testNetworkId1;
      canUseCacheNetwork = true;
    } else if (packageNetworkType == PackageNetworkType.preproduct) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.preproductNetworkId;
      canUseCacheNetwork = true;
    } else if (packageNetworkType == PackageNetworkType.product) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.productNetworkId;
      canUseCacheNetwork = false;
    } else {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.productNetworkId;
      canUseCacheNetwork = false;
    }
    return NetworkPageDataManager().initWithDefaultNetworkIdAndModels(
      networkModels_whenNull: TSEnvironmentDataUtil.getEnvNetworkModels(),
      defaultNetworkId: defaultNetworkId_whenNull,
      canUseCacheNetwork: canUseCacheNetwork,
    );
  }

  static Future<Null> initPackageTargetManager(
    PackageNetworkType packageNetworkType,
    PackageTargetType packageTargetType,
  ) async {
    _originPackageTargetType = packageTargetType;

    String defaultPackageTargetId_whenNull =
        packageTargetType.toString().split('.').last;

    bool canUseCachePackageTarget;
    if (packageNetworkType == PackageNetworkType.product) {
      canUseCachePackageTarget = false;
    } else {
      canUseCachePackageTarget = true;
    }

    List<PackageTargetModel> packageTargetModels_whenNull = [
      PackageTargetModel.targetModelByType(PackageTargetType.formal),
      PackageTargetModel.targetModelByType(PackageTargetType.inner),
      PackageTargetModel.targetModelByType(PackageTargetType.dev),
    ];

    return PackageTargetPageDataManager()
        .initWithDefaultPackageTargetIdAndModels(
      packageTargetModels_whenNull: packageTargetModels_whenNull,
      defaultPackageTargetId_whenNull: defaultPackageTargetId_whenNull,
      canUseCachePackageTarget: canUseCachePackageTarget,
    );
  }

  // proxy
  static Future<Null> initProxyEnvironmentManager(
      PackageNetworkType packageNetworkType) async {
    bool canUseCacheProxy = false;
    if (packageNetworkType == PackageNetworkType.develop1) {
      canUseCacheProxy = true;
    } else if (packageNetworkType == PackageNetworkType.develop2) {
      canUseCacheProxy = true;
    } else if (packageNetworkType == PackageNetworkType.test1) {
      canUseCacheProxy = true;
    } else if (packageNetworkType == PackageNetworkType.preproduct) {
      canUseCacheProxy = true;
    } else {
      canUseCacheProxy = false;
    }
    return ProxyPageDataManager().getCurrentProxyIdAndModels(
      TSEnvironmentDataUtil.getEnvProxyModels(),
      TSEnvironmentDataUtil.noneProxykId,
      canUseCacheProxy,
    );
  }

  /// 切换环境的时候要否应该退出 app
  static void _initEnvShouldExitWhenChangeNetworkEnv() {
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

  static PackageNetworkType get originPackageNetworkType =>
      _originPackageNetworkType;

  static PackageTargetModel get packageDefaultTargetModel {
    return PackageTargetModel.targetModelByType(_originPackageTargetType);
  }

  static TSEnvNetworkModel get packageDefaultNetworkModel {
    return TSEnvNetworkModelExtension.networkModelByType(
        _originPackageNetworkType);
  }

  static PackageTargetType get originPackageTargetType =>
      _originPackageTargetType;

  /// 获取target类型对应的人群
  static String packageTargetString(PackageTargetType targetType) {
    PackageTargetModel targetModel =
        PackageTargetModel.targetModelByType(targetType);
    String targetDes = "${targetModel.name}";
    return "${targetModel.envId}_${targetModel.name}";
  }

  /// 获取包当前的网络环境(初始的时候有网络环境，使用过程中可切换网络环境)
  static TSEnvNetworkModel get packageCurrentNetworkModel {
    if (!NetworkPageDataManager().hasInitCompleter) {
      print(
          "Error:NetworkPageDataManager初始化未完成，无法正确获取网络环境，请确保执行完了 NetworkPageDataManager().initWithDefaultNetworkIdAndModels");
    }
    TSEnvNetworkModel currentNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;

    return currentNetworkModel;
  }

  static PackageTargetModel get packageCurrentTargetModel =>
      PackageTargetPageDataManager().selectedTargetModel;

  static String appTargetNetworkString({bool containLetter = true}) {
    String originTargetNetworkDes = _originTargetNetworkString(
      containLetter: containLetter,
    );
    String currentTargetNetworkDes = _currentTargetNetworkString(
      containLetter: containLetter,
    );
    String appTargetNetworkDes = '';
    appTargetNetworkDes += '${originTargetNetworkDes}';
    if (EnvManagerUtil.isCurrentEqualOrigin != true) {
      appTargetNetworkDes += "->${currentTargetNetworkDes}";
    }

    return appTargetNetworkDes;
  }

  /// 包的"原始"功能+网络类型
  static String _originTargetNetworkString({bool containLetter = true}) {
    String originPackage = '';
    originPackage += _getPackageTargetNetworkString(
      _originPackageTargetType,
      _originPackageNetworkType,
    );

    if (containLetter == true) {
      originPackage +=
          "_${_originPackageTargetType.toString().split('.').last}";
      originPackage +=
          "_${_originPackageNetworkType.toString().split('.').last}";
    }
    return originPackage;
  }

  /// 包的"当前"功能+网络类型
  static String _currentTargetNetworkString({bool containLetter = true}) {
    String currentPackage = '';

    PackageTargetType currentTargetType =
        EnvManagerUtil.packageCurrentTargetModel.type;
    PackageNetworkType currentNetworkType =
        EnvManagerUtil.packageCurrentNetworkModel.type;
    currentPackage += _getPackageTargetNetworkString(
      currentTargetType,
      currentNetworkType,
    );

    if (containLetter == true) {
      currentPackage += "_${currentTargetType.toString().split('.').last}";
      currentPackage += "_${currentNetworkType.toString().split('.').last}";
    }

    return currentPackage;
  }

  /// 包的当前环境是否完全等于初始环境(因为中间可以且网络环境和内外测功能)
  static bool get isCurrentEqualOrigin {
    PackageTargetType targetType =
        EnvManagerUtil.packageCurrentTargetModel.type;
    PackageNetworkType networkType =
        EnvManagerUtil.packageCurrentNetworkModel.type;

    if (targetType == _originPackageTargetType &&
        networkType == _originPackageNetworkType) {
      return true;
    } else {
      return false;
    }
  }

  static String _getPackageTargetNetworkString(
    PackageTargetType targetType,
    PackageNetworkType networkType,
  ) {
    if (networkType == PackageNetworkType.product) {
      if (targetType == PackageTargetType.formal) {
        if (Platform.isIOS) {
          return "AppStore 生产包";
        } else {
          return "待加固成AppStore渠道 生产包";
        }
      } else if (targetType == PackageTargetType.inner) {
        if (Platform.isIOS) {
          return "内测于铂爵大楼(官网+TestFlight) 生产包";
        } else {
          return "内测于铂爵大楼(官网) 生产包";
        }
      } else {
        return "内测于 蒲公英 生产包"; // 开发人群
      }
    } else if (networkType == PackageNetworkType.preproduct) {
      return "预生产包";
    } else if (networkType == PackageNetworkType.test1) {
      return "测试包";
    } else {
      return "开发包";
    }
  }

  // 初始是否是生产包
  static bool get isPackageNetworkProduct {
    return _originPackageNetworkType == PackageNetworkType.product;
  }

  // 初始是否是蒲公英上的包
  static bool get isPackageTargetDev {
    return _originPackageTargetType == PackageTargetType.dev;
  }

  static Future<bool> _isProduct() async {
    await NetworkPageDataManager().initCompleter.future;
    return NetworkPageDataManager().selectedNetworkModel.apiHost ==
        TSEnvironmentDataUtil.apiHost_product;
  }
}
