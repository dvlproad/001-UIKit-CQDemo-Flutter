import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' show rootBundle; // 用于使用 rootBundle
import 'dart:convert' show json; // 用于使用json.decode

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

  final String brancesRecordTime; // 分支记录更新时间
  final List featureBranchMaps; // 需求分支数组
  final List
      nocodeBranceMaps; // 不编码的分支(master\development\dev_all\dev_will_publish)

  final String historyRecordTime; // 线上版本记录更新时间
  final List historyVersionMaps; // 线上版本记录数组

  BranchPackageInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
    this.buildCreateTime,
    this.brancesRecordTime,
    this.buildBranceName,
    this.buildBranceFeature,
    this.buildDefaultEnv,
    this.featureBranchMaps,
    this.nocodeBranceMaps,
    this.historyRecordTime,
    this.historyVersionMaps,
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
    brancesRecordTime: '',
    featureBranchMaps: [],
    nocodeBranceMaps: [],
    historyRecordTime: '',
    historyVersionMaps: [],
  );

  String fullPackageDes() {
    String _fullPackageDes = '';
    _fullPackageDes += "V$version($buildNumber)";
    _fullPackageDes += '生成时间:$buildCreateTime';
    _fullPackageDes += '来源分支:$buildBranceName';
    _fullPackageDes += '功能涵盖:$buildBranceFeature';

    return _fullPackageDes;
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
    // 此包的版本及来源分支：
    List<String> versionComponents = packageInfo.version.split('/');
    String realVersion = versionComponents[0];
    String buildDefaultEnv = '';
    // 此包的来源分支
    String fromBranceName =
        versionComponents.length > 1 ? versionComponents[1] : '';

    String branceFeature = '';
    // DefaultAssetBundle.of();
    String brancesRecordTime = '';
    List nocodeBrances =
        []; // 不编码的分支(master\development\dev_all\dev_will_publish)
    List featureBrances = []; // 需求分支
    String historyRecordTime = '';
    List historyVersions = [];
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle.loadString(
          "packages/flutter_updateversion_kit/assets/data/app_info.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        // 打包的默认环境
        buildDefaultEnv = data['package_default_env'];

        // 当前分支信息
        fromBranceName = data['package_from_brance'];
        // 所有分支信息
        brancesRecordTime = data['brances_record_time'];
        Map<String, dynamic> currentBranceMap;
        featureBrances = data['feature_brances'];
        nocodeBrances = data['nocode_brances'];
        if (currentBranceMap == null) {
          for (Map<String, dynamic> branceMap in featureBrances) {
            String branceName = branceMap['name'];
            if (branceName == fromBranceName) {
              currentBranceMap = branceMap;
              break;
            }
          }
        }
        if (currentBranceMap == null) {
          for (Map<String, dynamic> branceMap in nocodeBrances) {
            String branceName = branceMap['name'];
            if (branceName == fromBranceName) {
              currentBranceMap = branceMap;
              break;
            }
          }
        }

        if (currentBranceMap != null) {
          branceFeature = currentBranceMap['des'];
        }

        // 版本记录信息
        historyRecordTime = data['history_record_time'];
        historyVersions = data['history_versions'];
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('app_info.json文件内容获取失败,可能未存在或解析过程出错');
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
        List<String> realVersionComponents = realVersion.split('.');
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
      version: realVersion,
      buildNumber: packageInfo.buildNumber,
      buildBranceName: fromBranceName,
      buildCreateTime: buildCreateTime,
      buildBranceFeature: branceFeature,
      buildDefaultEnv: buildDefaultEnv,
      brancesRecordTime: brancesRecordTime,
      featureBranchMaps: featureBrances,
      nocodeBranceMaps: nocodeBrances,
      historyRecordTime: historyRecordTime,
      historyVersionMaps: historyVersions,
    );
  }
}
