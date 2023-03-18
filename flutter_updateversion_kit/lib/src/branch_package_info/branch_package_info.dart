import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle; // 用于使用 rootBundle
import 'dart:convert' show json; // 用于使用json.decode
import './dev_branch_bean.dart';
import './history_version_bean.dart';
import './pgyer_bean.dart';

class BranchPackageInfo {
  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS, `versionName` on Android.
  final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  final String buildNumber;

  final String buildCreateTime; // 此包的生成时间
  final String buildBranceName; // 此包的来源分支
  final String buildBranceFeature; // 此包来源分支的涵盖功能

  final String buildDefaultEnv; // 此包打包时候使用的默认环境
  final String buildDescription; // 此包打包时候填写的说明信息

  final List<DevBranchBean> buildContainBranchs; // 此包打包时候包含的分支信息

  final String brancesRecordTime; // 分支记录更新时间
  final List<DevBranchBean> featureBranchBeans; // 需求分支数组
  final List<DevBranchBean>
      nocodeBranceBeans; // 不编码的分支(master\development\dev_all\dev_will_publish)

  final String historyRecordTime; // 线上版本记录更新时间
  final List<HistoryVersionBean> historyVersionBeans; // 线上版本记录数组

  final PackResultModel? packResultModel; // 打包结果信息的模型

  BranchPackageInfo({
    required this.appName,
    required this.packageName,
    required this.version,
    required this.buildNumber,
    required this.buildCreateTime,
    required this.brancesRecordTime,
    required this.buildBranceName,
    required this.buildBranceFeature,
    required this.buildDefaultEnv,
    required this.buildDescription,
    required this.buildContainBranchs,
    required this.featureBranchBeans,
    required this.nocodeBranceBeans,
    required this.historyRecordTime,
    required this.historyVersionBeans,
    this.packResultModel,
  });

  static BranchPackageInfo nullPackageInfo = BranchPackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildCreateTime: '',
    buildBranceName: '',
    buildBranceFeature: '',
    buildDefaultEnv: '',
    buildDescription: '',
    buildContainBranchs: [],
    brancesRecordTime: '',
    featureBranchBeans: [],
    nocodeBranceBeans: [],
    historyRecordTime: '',
    historyVersionBeans: [],
  );

  String fullPackageDes() {
    String _fullPackageDes = '';
    _fullPackageDes += "V$version($buildNumber)";
    _fullPackageDes += '生成时间:$buildCreateTime';
    _fullPackageDes += '来源分支:$buildBranceName';
    _fullPackageDes += '功能涵盖:$buildBranceFeature';

    return _fullPackageDes;
  }

  String getBuildContainBranchsDescription({
    required bool showBranchName,
  }) {
    return DevBranchBeanUtil.getDescription(
      branchBeans: buildContainBranchs,
      showBranchName: showBranchName,
    );
  }

  // 包、平台、分支及版本等相关信息
  String get fullPackageDescribe {
    String platformName = "";
    if (Platform.isIOS) {
      platformName = 'iOS';
    } else if (Platform.isAndroid) {
      platformName = 'Android';
    }

    String fullPackageDescribe = '';
    if (buildDefaultEnv.isNotEmpty && buildDefaultEnv != 'package unknow env') {
      fullPackageDescribe += '${buildDefaultEnv}_';
    }
    fullPackageDescribe +=
        '${buildBranceName}($buildBranceFeature)_${platformName}_V$version($buildNumber)';

    return fullPackageDescribe;
  }

  /// 判断是否为Debug模式
  static bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }

  static Future<BranchPackageInfo> fromPlatform() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version:1.02.25/development_1.0.0_fix_abcdef
    // iOS bulidNumber:1022 \ Android versionCode:11021022
    // 此包的版本：
    String realVersion = packageInfo.version;
    String buildDefaultEnv = '';
    // 此包的来源分支
    String fromBranceName = 'unkonw';
    String buildDescription = 'unknow';

    PackResultModel? packResultModel;
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle.loadString(
          "packages/flutter_updateversion_kit/assets/data/app_info.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        // 打包的默认环境
        buildDefaultEnv = data['package_default_env'] ?? '';
        // 此包打包时候填写的说明信息
        buildDescription = data['package_update_des'] ?? '';

        // 当前分支信息
        fromBranceName = data['package_from_brance'] ?? '';

        Map<String, dynamic>? packageResultMap = data['package_result'];
        if (packageResultMap != null) {
          packResultModel = PackResultModel.fromJson(packageResultMap);
        }
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('app_info.json文件内容获取失败,可能未存在或解析过程出错');
      }
    }

    List<DevBranchBean> buildContainBranchs = [];

    String branceFeature = '';
    // DefaultAssetBundle.of();
    String brancesRecordTime = '';
    List<DevBranchBean> nocodeBrances =
        []; // 不编码的分支(master\development\dev_all\dev_will_publish)
    List<DevBranchBean> featureBrances = []; // 需求分支
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle.loadString(
          "packages/flutter_updateversion_kit/assets/data/app_branch_info.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        if (data['package_merger_branchs'] != null) {
          for (var json in data['package_merger_branchs']) {
            buildContainBranchs.add(DevBranchBean.fromJson(json));
          }
        }

        // 所有分支信息
        brancesRecordTime = data['brances_record_time'] ?? '';
        DevBranchBean? currentBranceBean;

        if (data['feature_brances'] != null) {
          for (var json in data['feature_brances']) {
            featureBrances.add(DevBranchBean.fromJson(json));
          }
        }

        if (data['nocode_brances'] != null) {
          for (var json in data['nocode_brances']) {
            nocodeBrances.add(DevBranchBean.fromJson(json));
          }
        }

        if (currentBranceBean == null) {
          for (DevBranchBean branceBean in featureBrances) {
            String? branceName = branceBean.name;
            if (branceName == fromBranceName) {
              currentBranceBean = branceBean;
              break;
            }
          }
        }
        if (currentBranceBean == null) {
          for (DevBranchBean branceBean in nocodeBrances) {
            String? branceName = branceBean.name;
            if (branceName == fromBranceName) {
              currentBranceBean = branceBean;
              break;
            }
          }
        }

        if (currentBranceBean != null) {
          branceFeature = currentBranceBean.description;
        }
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('app_branch_info.json文件内容获取失败,可能未存在或解析过程出错');
      }
    }

    String historyRecordTime = '';
    List<HistoryVersionBean> historyVersionBeans = [];
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle.loadString(
          "packages/flutter_updateversion_kit/assets/data/app_history_version.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        // 版本记录信息
        // historyRecordTime = data['history_record_time'] ?? '';

        if (data['history_versions'] != null) {
          for (var json in data['history_versions']) {
            historyVersionBeans.add(HistoryVersionBean.fromJson(json));
          }
          if (historyVersionBeans.isNotEmpty) {
            historyRecordTime = historyVersionBeans.first.onlineTime;
          }
        }
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('app_history_version.json文件内容获取失败,可能未存在或解析过程出错');
      }
    }

    // 此包的生成时间
    String buildCreateTime = '';
    String buildNumber = packageInfo.buildNumber;
    if (buildNumber.length >= 4) {
      String bulidMonth;
      String bulidDay;
      if (buildNumber.length >= 8) {
        // Android肯定是8位
        String bulidMMdd = buildNumber.substring(0, 4);
        bulidMonth = bulidMMdd.substring(0, 2);
        bulidDay = bulidMMdd.substring(2, 4);
      } else {
        List<String> realVersionComponents = packageInfo.version.split('.');
        bulidMonth = realVersionComponents[1];
        bulidDay = realVersionComponents[2];
      }

      String bulidHHmm = buildNumber.substring(buildNumber.length - 4);
      String bulidHour = bulidHHmm.substring(0, 2);
      String buildMinute = bulidHHmm.substring(2, 4);
      buildCreateTime = '$bulidMonth/$bulidDay $bulidHour:$buildMinute';
    }

    if (Platform.isAndroid) {
    } else {}

    return BranchPackageInfo(
      appName: packageInfo.appName,
      packageName: packageInfo.packageName,
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      buildBranceName: fromBranceName,
      buildCreateTime: buildCreateTime,
      buildBranceFeature: branceFeature,
      buildDefaultEnv: buildDefaultEnv,
      buildDescription: buildDescription,
      buildContainBranchs: buildContainBranchs,
      brancesRecordTime: brancesRecordTime,
      featureBranchBeans: featureBrances,
      nocodeBranceBeans: nocodeBrances,
      historyRecordTime: historyRecordTime,
      historyVersionBeans: historyVersionBeans,
      packResultModel: packResultModel,
    );
  }
}

class PackResultModel {
  final String pgyerOwner;
  final String pgyerKey;
  final PgyerChannelConfigModel? pgyerChannelConfigModel;

  PackResultModel({
    required this.pgyerOwner,
    required this.pgyerKey,
    this.pgyerChannelConfigModel,
  });

  static PackResultModel fromJson(Map<String, dynamic> json) {
    String pgyerOwner = json["shoudUploadToPgyerOwner"] ?? '';
    String pgyerKey = json["shoudUploadToPgyerKey"] ?? '';

    PgyerChannelConfigModel? pgyerChannelConfigModel;
    if (json["pgyer_branch_config"] != null) {
      pgyerChannelConfigModel =
          PgyerChannelConfigModel.fromJson(json["pgyer_branch_config"]);
    }

    return PackResultModel(
      pgyerOwner: pgyerOwner,
      pgyerKey: pgyerKey,
      pgyerChannelConfigModel: pgyerChannelConfigModel,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["shoudUploadToPgyerOwner"] = this.pgyerOwner;
    data["shoudUploadToPgyerKey"] = this.pgyerKey;

    if (pgyerChannelConfigModel != null) {
      data["pgyer_branch_config"] = this.pgyerChannelConfigModel!.toJson();
    }

    return data;
  }
}
