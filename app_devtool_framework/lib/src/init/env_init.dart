import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';

import './environment_datas_util.dart';
import './main_diff_util.dart';
export './main_diff_util.dart' show PackageType;

class EnvInit {
  /************************* environment 环境设置 *************************/
  // network
  static Future initNetworkEnvironmentManager(PackageType packageType) async {
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
  static Future initProxyEnvironmentManager(PackageType packageType) async {
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

  // 是否是生产环境
  static bool get isProduct =>
      NetworkPageDataManager().selectedNetworkModel.apiHost ==
      TSEnvironmentDataUtil.apiHost_product;
}
