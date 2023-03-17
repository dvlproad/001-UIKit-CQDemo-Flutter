/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 20:36:10
 * @Description: 代理的数据模型
 */
import 'package:flutter/foundation.dart';

enum PackageTargetType {
  pgyer, // 蒲公英
  formal, // 正式环境-TestFlight、AppleStore
}

class PackageTargetModel {
  String envId;
  String name; // 网络代理的名称
  bool check;

  PackageTargetModel({
    @required this.envId,
    @required this.name,
    this.check = false,
  });

  static PackageTargetModel get pgyerTargetModel {
    return PackageTargetModel(
      envId: 'pgyer',
      name: '内测(蒲公英)',
    );
  }

  static PackageTargetModel get formalTargetModel {
    return PackageTargetModel(
      envId: 'formal',
      name: '外测(官网)',
    );
  }

  PackageTargetType get type {
    PackageTargetType packageTargetType =
        PackageTargetModel.getTargetType(envId);

    return packageTargetType;
  }

  static PackageTargetType getTargetType(String envId) {
    Iterable<PackageTargetType> values = [
      PackageTargetType.pgyer, // 蒲公英
      PackageTargetType.formal, // 正式环境-TestFlight、AppleStore
    ];
    PackageTargetType packageTargetType = values.firstWhere((type) {
      return type.toString().split('.').last == envId;
    }, orElse: () {
      return null;
    });

    return packageTargetType;
  }

  // json 与 model 转换
  factory PackageTargetModel.fromJson(Map<String, dynamic> json) {
    return PackageTargetModel(
      envId: json['envId'],
      name: json['name'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "envId": this.envId,
      "name": this.name,
    };
  }
}
