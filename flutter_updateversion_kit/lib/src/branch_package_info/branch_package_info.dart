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

  BranchPackageInfo({
    this.appName,
    this.packageName,
    this.version,
    this.buildNumber,
    this.buildCreateTime,
    this.buildBranceName,
    this.buildBranceFeature,
  });

  static BranchPackageInfo nullPackageInfo = BranchPackageInfo(
    appName: '',
    packageName: '',
    version: '',
    buildNumber: '',
    buildCreateTime: '',
    buildBranceName: '',
    buildBranceFeature: '',
  );

  String fullPackageDes() {
    String _fullPackageDes = '';
    _fullPackageDes += "V$version($buildNumber)";
    _fullPackageDes += '生成时间:$buildCreateTime';
    _fullPackageDes += '来源分支:$buildBranceName';
    _fullPackageDes += '功能涵盖:$buildBranceFeature';

    return _fullPackageDes;
  }

  static Future<BranchPackageInfo> fromPlatform() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // version:1.02.25/development_1.0.0_fix_abcdef
    // iOS bulidNumber:1022 \ Android versionCode:11021022
    // 此包的版本及来源分支：
    List<String> versionComponents = packageInfo.version.split('/');
    String realVersion = versionComponents[0];
    // 此包的来源分支
    String fromBranceName =
        versionComponents.length > 1 ? versionComponents[1] : '';

    String branceFeature = '';
    // DefaultAssetBundle.of();
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle.loadString(
          "packages/flutter_updateversion_kit/assets/data/app_info.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode
        fromBranceName = data['brance'];

        Map<String, dynamic> currentBranceMap;
        List brances = data['brances'];
        for (Map<String, dynamic> branceMap in brances) {
          String branceName = branceMap['name'];
          if (branceName == fromBranceName) {
            currentBranceMap = branceMap;
            break;
          }
        }

        if (currentBranceMap != null) {
          branceFeature = currentBranceMap['des'];
        }
      }
    } catch (e) {
      print('app_info.json文件内容获取失败,可能未存在或解析过程出错');
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
    );
  }
}
