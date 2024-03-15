// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-15 23:53:20
 * @Description: 环境初始化类
 */

import 'package:flutter_environment_base/flutter_environment_base.dart';

import './eventbus/environment_eventbus.dart';

abstract class EnvironmentProtocol {
  // 初始化时候: network
  Future initWithDefaultNetworkIdAndModels(
    PackageNetworkType packageNetworkType,
  );

  // 初始化时候: proxy
  Future initWithDefaultProxyIdAndModels(
    PackageNetworkType packageNetworkType,
  );

  String getPackageTargetNetworkString(
    PackageTargetType targetType,
    PackageNetworkType networkType,
  );
}

abstract class BaseEnvironmentSingleton implements EnvironmentProtocol {
  late PackageNetworkType _originPackageNetworkType;
  late PackageTargetType _originPackageTargetType;

  /// *********************** environment 环境设置 ************************
  bool hasInitCompleter_Env = false;
  Future<void> init_target_network_proxy({
    required PackageTargetType originPackageTargetType,
    required PackageNetworkType originPackageNetworkType,
  }) async {
    // 环境初始化
    // network:api host

    DateTime networkPageDataInitDateStart = DateTime.now();
    // ResponseDateModel responseDateModel =
    await _initNetworkEnvironmentManager(originPackageNetworkType);
    await NetworkPageDataManager().initCompleter.future;
    DateTime networkPageDataInitDateEnd = DateTime.now();
    // TSEnvNetworkModel selectedNetworkModel = NetworkPageDataManager().selectedNetworkModel;

    // proxy:
    DateTime proxyPageDataInitDateStart = DateTime.now();
    await initWithDefaultProxyIdAndModels(originPackageNetworkType);
    await ProxyPageDataManager().initCompleter.future;
    DateTime proxyPageDataInitDateEnd = DateTime.now();
    // TSEnvProxyModel selectedProxyModel = ProxyPageDataManager().selectedProxyModel;

    // target:
    DateTime targetPageDataInitDateStart = DateTime.now();
    await _initPackageTargetManager(
        originPackageNetworkType, originPackageTargetType);
    await PackageTargetPageDataManager().initCompleter.future;
    DateTime targetPageDataInitDateEnd = DateTime.now();
    // PackageTargetModel selectedTargetModel = PackageTargetPageDataManager().selectedTargetModel;

    hasInitCompleter_Env = true;
    environmentEventBus.fire(
      EnvironmentInitCompleteEvent(
        networkPageDataSpendModel: SpendDateModel(
          startTime: networkPageDataInitDateStart,
          endTime: networkPageDataInitDateEnd,
        ),
        proxyPageDataSpendModel: SpendDateModel(
          startTime: proxyPageDataInitDateStart,
          endTime: proxyPageDataInitDateEnd,
        ),
        targetPageDataSpendModel: SpendDateModel(
          startTime: targetPageDataInitDateStart,
          endTime: targetPageDataInitDateEnd,
        ),
      ),
    );
  }

  // network
  Future<void> _initNetworkEnvironmentManager(
    PackageNetworkType packageNetworkType,
  ) async {
    _originPackageNetworkType = packageNetworkType;

    _initEnvShouldExitWhenChangeNetworkEnv();

    return initWithDefaultNetworkIdAndModels(packageNetworkType);
  }

  Future<void> _initPackageTargetManager(
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

  /// 切换环境的时候要否应该退出 app
  void _initEnvShouldExitWhenChangeNetworkEnv() {
    /*
    EnvironmentUtil.shouldExitWhenChangeNetworkEnv = (
      TSEnvNetworkModel fromNetworkEnvModel,
      TSEnvNetworkModel toNetworkEnvModel,
    ) {
      if (toNetworkEnvModel.envId == TSEnvironmentDataUtil.mockNetworkId) {
        return ChangeEnvPermission.AllowButNeedExit;
      }
      if (toNetworkEnvModel.envId != TSEnvironmentDataUtil.productNetworkId) {
        return ChangeEnvPermission.AllowButNeedExit;
      }
      return ChangeEnvPermission.Forbid;
    };
    */
  }

  PackageNetworkType get originPackageNetworkType => _originPackageNetworkType;

  PackageTargetModel get packageDefaultTargetModel {
    return PackageTargetModel.targetModelByType(_originPackageTargetType);
  }

  // TSEnvNetworkModel get packageDefaultNetworkModel {
  //   return TSEnvNetworkModelExtension.networkModelByType(
  //       _originPackageNetworkType);
  // }

  PackageTargetType get originPackageTargetType => _originPackageTargetType;

  /// 获取target类型对应的人群
  String packageTargetString(PackageTargetType targetType) {
    PackageTargetModel targetModel =
        PackageTargetModel.targetModelByType(targetType);
    return "${targetModel.envId}_${targetModel.name}";
  }

  // /// 获取包当前的网络环境(初始的时候有网络环境，使用过程中可切换网络环境)
  // TSEnvNetworkModel get packageCurrentNetworkModel {
  //   if (!NetworkPageDataManager().hasInitCompleter) {
  //     debugPrint(
  //         "Error:NetworkPageDataManager初始化未完成，无法正确获取网络环境，请确保执行完了 NetworkPageDataManager().initWithDefaultNetworkIdAndModels");
  //   }
  //   TSEnvNetworkModel currentNetworkModel =
  //       NetworkPageDataManager().selectedNetworkModel;

  //   return currentNetworkModel;
  // }

  // PackageTargetModel get packageCurrentTargetModel =>
  //     PackageTargetPageDataManager().selectedTargetModel;

  String appTargetNetworkString({bool containLetter = true}) {
    String originTargetNetworkDes = _originTargetNetworkString(
      containLetter: containLetter,
    );
    String currentTargetNetworkDes = _currentTargetNetworkString(
      containLetter: containLetter,
    );
    String appTargetNetworkDes = '';
    appTargetNetworkDes += originTargetNetworkDes;
    if (isCurrentEqualOrigin != true) {
      appTargetNetworkDes += "->$currentTargetNetworkDes";
    }

    return appTargetNetworkDes;
  }

  /// 包的"原始"功能+网络类型
  String _originTargetNetworkString({bool containLetter = true}) {
    String originPackage = '';
    originPackage += getPackageTargetNetworkString(
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
  String _currentTargetNetworkString({bool containLetter = true}) {
    String currentPackage = '';

    PackageTargetType currentTargetType =
        PackageTargetPageDataManager().selectedTargetModel.type;
    PackageNetworkType currentNetworkType =
        NetworkPageDataManager().selectedNetworkModel.type;
    currentPackage += getPackageTargetNetworkString(
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
  bool get isCurrentEqualOrigin {
    PackageTargetType targetType =
        PackageTargetPageDataManager().selectedTargetModel.type;
    PackageNetworkType networkType =
        NetworkPageDataManager().selectedNetworkModel.type;

    if (targetType == _originPackageTargetType &&
        networkType == _originPackageNetworkType) {
      return true;
    } else {
      return false;
    }
  }

  // 初始是否是生产包
  bool get isPackageNetworkProduct {
    return _originPackageNetworkType == PackageNetworkType.product;
  }

  // 初始是否是蒲公英上的包
  bool get isPackageTargetDev {
    return _originPackageTargetType == PackageTargetType.dev;
  }

  // Future<bool> _isProduct() async {
  //   await NetworkPageDataManager().initCompleter.future;
  //   return NetworkPageDataManager().selectedNetworkModel.apiHost ==
  //       TSEnvironmentDataUtil.apiHost_product;
  // }
}
