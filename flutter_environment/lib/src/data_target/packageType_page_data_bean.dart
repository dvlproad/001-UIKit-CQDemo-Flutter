/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-11-23 14:35:10
 * @Description: 代理的数据模型
 */
import 'package:flutter/foundation.dart';

/*
/// 发布的功能类型
enum PackageFeatureType {
  formal, // 正式功能-发布到AppleStore
  inner, // 内测功能-发布到TestFlight、蒲公英
}
*/

/// 发布到的平台大类型(该平台的功能类型和人群类型固定，从而决定了调用检查更新的方法)
enum PackageTargetType {
  formal, // 正式包的发布平台-AppleStore
  inner, // 内测包的发布平台-TestFlight
  dev, // 开发包的发布平台
}

class PackageTargetModel {
  PackageTargetType type;
  String name; // 平台名称
  String shortName; // 平台简称
  String des;
  bool check;

  PackageTargetModel({
    required this.type,
    required this.name,
    required this.shortName,
    required this.des,
    this.check = false,
  });

  String get envId {
    return type.toString().split('.').last;
  }

  static PackageTargetType getTargetTypeByString(String targetTypeString) {
    Iterable<PackageTargetType> values = [
      PackageTargetType.formal, // 正式包的发布平台-AppleStore
      PackageTargetType.inner, // 内测包的发布平台-TestFlight
      PackageTargetType.dev, // 开发包的发布平台
    ];
    PackageTargetType targetType = values.firstWhere((type) {
      return type.toString().split('.').last == targetTypeString;
    }, orElse: () {
      return PackageTargetType.formal; // 正式包的发布平台-AppleStore
    });

    return targetType;
  }

  static PackageTargetModel targetModelByType(PackageTargetType targetType) {
    if (targetType == PackageTargetType.formal) {
      return PackageTargetModel(
        type: targetType,
        name: "AppStore发布平台",
        shortName: 'AS',
        des: "AppStore人群(公测功能+调用内部版本检查)",
      );
    } else if (targetType == PackageTargetType.inner) {
      return PackageTargetModel(
        type: targetType,
        name: "TestFlight发布平台",
        shortName: 'TF',
        des: "铂爵大楼人群(内测功能+调用内部版本检查)",
      );
    } else {
      return PackageTargetModel(
        type: targetType,
        name: "蒲公英发布平台",
        shortName: '蒲',
        des: "15楼开发人群(内测功能+调用外部版本检查)",
      );
    }
  }

  // json 与 model 转换
  factory PackageTargetModel.fromJson(Map<String, dynamic> json) {
    return PackageTargetModel(
      type: json['type'],
      name: json['name'],
      shortName: json['shortName'],
      des: json['des'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "type": this.type,
      "name": this.name,
      "shortName": this.shortName,
      "des": this.des,
    };
  }
}
