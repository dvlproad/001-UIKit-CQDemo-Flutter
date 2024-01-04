/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-16 14:31:21
 * @Description: 不同网络环境下包含各属性值的模型
 */

import 'package:flutter_environment_base/flutter_environment_base.dart';
import './init/environment_datas_util.dart';

extension NetworkType on TSEnvNetworkModel {
  /*
  PackageNetworkType get type {
    PackageNetworkType networkEnvType = _getNetworkEnvType(this.envId);

    return networkEnvType;
  }

  PackageNetworkType _getNetworkEnvType(String envId) {
    Iterable<PackageNetworkType> values = [
      PackageNetworkType.develop1, // 开发环境1
      PackageNetworkType.develop2, // 开发环境2
      PackageNetworkType.preproduct, // 预生产环境
      PackageNetworkType.product, // 正式环境
    ];
    PackageNetworkType networkEnvType = values.firstWhere((type) {
      return type.toString().split('.').last == envId;
    }, orElse: () {
      return PackageNetworkType.product; // 正式环境
    });

    return networkEnvType;
  }
  */
}

class TSEnvNetworkModelExtension {
  static TSEnvNetworkModel networkModelByType(PackageNetworkType networkType) {
    if (networkType == PackageNetworkType.product) {
      return TSEnvironmentDataUtil.networkModel_product;
    } else if (networkType == PackageNetworkType.preproduct) {
      return TSEnvironmentDataUtil.networkModel_preProduct;
    } else if (networkType == PackageNetworkType.test1) {
      return TSEnvironmentDataUtil.networkModel_test1;
    } else if (networkType == PackageNetworkType.test2) {
      return TSEnvironmentDataUtil.networkModel_test2;
    } else if (networkType == PackageNetworkType.develop1) {
      return TSEnvironmentDataUtil.networkModel_dev1;
    } else if (networkType == PackageNetworkType.develop2) {
      return TSEnvironmentDataUtil.networkModel_dev2;
      // } else if (networkType == PackageNetworkType.mock) {
      //   return TSEnvironmentDataUtil.networkModel_mock;
    } else {
      return TSEnvironmentDataUtil.networkModel_product;
    }
  }
}
