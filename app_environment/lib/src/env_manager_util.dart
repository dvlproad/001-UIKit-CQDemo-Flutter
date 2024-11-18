/*
 * @Author: dvlproad
 * @Date: 2024-03-15 22:53:54
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-11-18 21:06:04
 * @Description: 
 */

import 'dart:io';

import 'package:flutter_environment_kit/flutter_environment_kit.dart';

import 'environment_datas_util.dart';

class AppEnvSingleton extends BaseEnvironmentSingleton {
  AppEnvSingleton._();
  static final AppEnvSingleton _instance = AppEnvSingleton._();
  factory AppEnvSingleton() => _instance;

  @override
  Future initWithDefaultNetworkIdAndModels(
    PackageNetworkType packageNetworkType,
  ) {
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
    } else if (packageNetworkType == PackageNetworkType.test2) {
      defaultNetworkId_whenNull = TSEnvironmentDataUtil.testNetworkId2;
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

  @override
  Future initWithDefaultProxyIdAndModels(
    PackageNetworkType packageNetworkType,
  ) {
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

  @override
  String getPackageTargetNetworkString(
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
}
