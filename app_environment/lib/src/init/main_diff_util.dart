/*
 * @Author: dvlproad
 * @Date: 2022-04-21 18:58:00
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 18:29:24
 * @Description: 不同包的差异数据
 */
import 'package:flutter/foundation.dart';
import 'package:flutter_environment/flutter_environment.dart';
import '../data_manager/packageType_page_data_bean.dart' show PackageTargetType;

class DiffPackageBean {
  PackageType packageType;
  String des;
  String bestNetworkDes;
  PackageTargetType packageTargetType;

  DiffPackageBean({
    @required this.packageType,
    @required this.des,
    @required this.bestNetworkDes,
    @required this.packageTargetType,
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
