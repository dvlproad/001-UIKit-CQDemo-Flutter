/*
 * @Author: dvlproad
 * @Date: 2022-04-21 18:58:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 18:29:24
 * @Description: 不同包的差异数据
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_environment/flutter_environment.dart';
import './environment_datas_util.dart';
import './packageType_page_data_bean.dart' show PackageTargetType;

class DiffPackageBean {
  PackageType packageType;
  String des;
  String bestNetworkDes;

  DiffPackageBean({
    @required this.packageType,
    @required this.des,
    @required this.bestNetworkDes,
  });

  DiffPackageBean.fromJson(dynamic json) {
    packageType = json['packageType'];
    des = json["des"];
    bestNetworkDes = json["bestNetworkDes"];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map['packageType'] = packageType;
    map["des"] = des;
    map["bestNetworkDes"] = bestNetworkDes;
  }

  bool get isProduct {
    return packageType == PackageType.product;
  }
}

class MainDiffUtil {
  static PackageType packageType;
  static PackageTargetType packageTargetType;

  static init({
    @required PackageType m_packageEnvType,
    @required PackageTargetType m_packageTargetType,
  }) {
    packageType = m_packageEnvType;
    packageTargetType = m_packageTargetType;
  }

  static DiffPackageBean diffPackageBean() {
    return diffPackageBeanByType(packageType);
  }

  static List<Map<String, dynamic>> PackageInfoMaps = [
    {
      "packageType": PackageType.develop1,
      "des": '开发包',
      "bestNetworkDes": TSEnvironmentDataUtil.networkModel_dev1.name,
    },
    {
      "packageType": PackageType.preproduct,
      "des": '测试包',
      "bestNetworkDes": TSEnvironmentDataUtil.networkModel_preProduct.name,
    },
    {
      "packageType": PackageType.product,
      "des": '生产包',
      "bestNetworkDes": TSEnvironmentDataUtil.networkModel_product.name,
    },
  ];

  static DiffPackageBean _diffPackageBean_dev = DiffPackageBean(
    packageType: PackageType.develop1,
    des: '开发包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_dev1.name,
  );

  static DiffPackageBean _diffPackageBean_preproduct = DiffPackageBean(
    packageType: PackageType.preproduct,
    des: '测试包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_preProduct.name,
  );

  static DiffPackageBean _diffPackageBean_product = DiffPackageBean(
    packageType: PackageType.product,
    des: '生产包',
    bestNetworkDes: TSEnvironmentDataUtil.networkModel_product.name,
  );

  static DiffPackageBean diffPackageBeanByType(PackageType _platformState) {
    if (_platformState == PackageType.develop1) {
      return _diffPackageBean_dev;
    } else if (_platformState == PackageType.develop2) {
      return _diffPackageBean_dev;
    } else if (_platformState == PackageType.preproduct) {
      return _diffPackageBean_preproduct;
    } else if (_platformState == PackageType.product) {
      return _diffPackageBean_product;
    } else {
      return _diffPackageBean_product;
    }
  }
}
