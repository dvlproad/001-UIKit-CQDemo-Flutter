/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-20 18:33:37
 * @Description: 环境初始化类
 */
import 'package:flutter_environment/flutter_environment.dart';

import './init/environment_datas_util.dart';
import './init/main_diff_util.dart';
import './init/packageType_page_data_bean.dart' show PackageTargetType;

class EnvManagerUtil {
  /************************* environment 环境设置 *************************/
  // network
  static Future<Null> initNetworkEnvironmentManager(
      PackageType packageType) async {
    await _initEnvShouldExitWhenChangeNetworkEnv();

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
    } else if (packageType == PackageType.product) {
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

  // proxy
  static Future<Null> initProxyEnvironmentManager(
      PackageType packageType) async {
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
    return ProxyPageDataManager().getCurrentProxyIdAndModels(
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

  // 是否是生产网络环境
  static bool get isProductNetwork {
    return currentPackageType == PackageType.product;
  }

  /// 获取包当前的网络环境(初始的时候有网络环境，使用过程中可切换网络环境)
  static PackageType get currentPackageType {
    if (!NetworkPageDataManager().hasInitCompleter) {
      print(
          "Error:NetworkPageDataManager初始化未完成，无法正确获取网络环境，请确保执行完了 NetworkPageDataManager().initWithDefaultNetworkIdAndModels");
    }
    String currentApiHost =
        NetworkPageDataManager().selectedNetworkModel.apiHost;
    if (currentApiHost == TSEnvironmentDataUtil.apiHost_product) {
      return PackageType.product;
    } else if (currentApiHost == TSEnvironmentDataUtil.apiHost_preProduct) {
      return PackageType.preproduct;
    } else if (currentApiHost == TSEnvironmentDataUtil.apiHost_dev1) {
      return PackageType.develop1;
    } else if (currentApiHost == TSEnvironmentDataUtil.apiHost_dev2) {
      return PackageType.develop2;
    } else {
      throw Exception("Error:获取包当前的网络环境错误，请检查");
    }
  }

  // 是否是生产包
  static bool get isProductPackage {
    return MainDiffUtil.packageType == PackageType.product;
  }

  // 是否是蒲公英上的包
  static bool get isPackageTargetPgyer {
    return MainDiffUtil.packageTargetType == PackageTargetType.pgyer;
  }

  static Future<bool> _isProduct() async {
    await NetworkPageDataManager().initCompleter.future;
    return NetworkPageDataManager().selectedNetworkModel.apiHost ==
        TSEnvironmentDataUtil.apiHost_product;
  }
}
