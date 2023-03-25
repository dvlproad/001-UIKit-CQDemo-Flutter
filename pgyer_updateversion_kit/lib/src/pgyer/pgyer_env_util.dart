// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-21 18:58:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-26 01:38:35
 * @Description: 不同包的差异数据
 */
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class PgyerAppBean {
  final UpdateAppType pgyerAppType;
  final String des;
  // final String? bestNetworkDes;
  final String downloadUrl;
  final String pygerApiKey;
  final String pygerAppKeyAndroid;
  final String pygerAppKeyIOS;

  PgyerAppBean({
    required this.pgyerAppType,
    required this.des,
    // this.bestNetworkDes,
    required this.downloadUrl,
    required this.pygerApiKey,
    required this.pygerAppKeyAndroid,
    required this.pygerAppKeyIOS,
  });

  // PgyerAppBean.fromJson(dynamic json) {
  //   pgyerAppType = json['pgyerAppType '];
  //   des = json["des"];
  //   bestNetworkDes = json["bestNetworkDes"];
  //   downloadUrl = json["downloadUrl"];
  //   pygerApiKey = json["pygerApiKey"];
  //   pygerAppKeyAndroid = json["pygerAppKeyAndroid"];
  //   pygerAppKeyIOS = json["pygerAppKeyIOS"];
  // }

  // Map<String, dynamic> toJson() {
  //   Map<String, dynamic> map = {};
  //   map['pgyerAppType '] = pgyerAppType;
  //   map["des"] = des;
  //   map["bestNetworkDes"] = bestNetworkDes;
  //   map["downloadUrl"] = downloadUrl;
  //   map["pygerApiKey"] = pygerApiKey;
  //   map["pygerAppKeyAndroid"] = pygerAppKeyAndroid;
  //   map["pygerAppKeyIOS"] = pygerAppKeyIOS;

  //   return map;
  // }

  bool get isProduct {
    return pgyerAppType == UpdateAppType.product;
  }
}

class PgyerEnvUtil {
  static List<Map<String, dynamic>> packageInfoMaps = [
    {
      "pgyerAppType ": UpdateAppType.develop1,
      "des": '开发包',
      // "bestNetworkDes": TSEnvironmentDataUtil.networkModel_dev1.name,
      "downloadUrl": 'https://www.pgyer.com/Jzqc',
      "pygerApiKey": 'a6f5a92ffe5f43677c5580de3e1e0d99',
      "pygerAppKeyAndroid": '251b74df1a3bd5fe7395fba154938aa1',
      "pygerAppKeyIOS": '0b534e9b77ec8708318a99b6061749de',
    },
    {
      "pgyerAppType ": UpdateAppType.preproduct,
      "des": '测试包',
      // "bestNetworkDes": TSEnvironmentDataUtil.networkModel_preProduct.name,
      "downloadUrl": 'https://www.pgyer.com/bjtkewish',
      "pygerApiKey": 'a6f5a92ffe5f43677c5580de3e1e0d99',
      "pygerAppKeyAndroid": '0ff51c2519a23078fac1f8e8ea1bbdef',
      "pygerAppKeyIOS": '3aa46e5f75c648922bb2450ac2da7909',
    },
    {
      "pgyerAppType ": UpdateAppType.product,
      "des": '生产包',
      // "bestNetworkDes": TSEnvironmentDataUtil.networkModel_product.name,
      "downloadUrl": 'https://www.pgyer.com/app_bj',
      "pygerApiKey": 'da2bc35c7943aa78e66ee9c94fdd0824',
      "pygerAppKeyAndroid": '70fda79d944eeb6797961db785f8d2b8',
      "pygerAppKeyIOS": '5f84348a16bef907dc0ea977deb249ab',
    },
  ];

  static final PgyerAppBean _diffPackageBean_dev = PgyerAppBean(
    pgyerAppType: UpdateAppType.develop1,
    des: '开发包',
    // bestNetworkDes: TSEnvironmentDataUtil.networkModel_dev1.name,
    downloadUrl: 'https://www.pgyer.com/Jzqc',
    pygerApiKey: 'a6f5a92ffe5f43677c5580de3e1e0d99',
    pygerAppKeyAndroid: '251b74df1a3bd5fe7395fba154938aa1',
    pygerAppKeyIOS: '0b534e9b77ec8708318a99b6061749de',
  );

  static final PgyerAppBean _diffPackageBean_preproduct = PgyerAppBean(
    pgyerAppType: UpdateAppType.preproduct,
    des: '测试包',
    // bestNetworkDes: TSEnvironmentDataUtil.networkModel_preProduct.name,
    downloadUrl: 'https://www.pgyer.com/bjtkewish',
    pygerApiKey: 'a6f5a92ffe5f43677c5580de3e1e0d99',
    pygerAppKeyAndroid: '0ff51c2519a23078fac1f8e8ea1bbdef',
    pygerAppKeyIOS: '3aa46e5f75c648922bb2450ac2da7909',
  );

  static final PgyerAppBean _diffPackageBean_product = PgyerAppBean(
    pgyerAppType: UpdateAppType.product,
    des: '生产包',
    // bestNetworkDes: TSEnvironmentDataUtil.networkModel_product.name,
    downloadUrl: 'https://www.pgyer.com/app_bj',
    pygerApiKey: 'da2bc35c7943aa78e66ee9c94fdd0824',
    pygerAppKeyAndroid: '70fda79d944eeb6797961db785f8d2b8',
    pygerAppKeyIOS: '5f84348a16bef907dc0ea977deb249ab',
  );

  static PgyerAppBean diffPackageBeanByType(UpdateAppType platformState) {
    if (platformState == UpdateAppType.develop1) {
      return _diffPackageBean_dev;
    } else if (platformState == UpdateAppType.develop2) {
      return _diffPackageBean_dev;
    } else if (platformState == UpdateAppType.preproduct) {
      return _diffPackageBean_preproduct;
    } else if (platformState == UpdateAppType.product) {
      return _diffPackageBean_product;
    } else {
      return _diffPackageBean_product;
    }
  }
}
