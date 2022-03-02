import 'dart:math';
import './branch_package_info/branch_package_info.dart';
export './branch_package_info/branch_package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 服务器的版本与本地版本的比较结果
enum ServiceVersionCompareResult {
  noNew, // 不是新版本
  newButNoShow, // 是新版本但不显示
  newAndShow, // 是新版本且展示
}

class CheckVersionCommonUtil {
  static String cancelShowVersionsKey =
      'cancelShowVersionsKey'; // 之前对升级弹窗点击取消，后续不再弹出的那些版本号

  // 清空
  static Future<bool> removeAllCancelShowVersions() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(cancelShowVersionsKey);
  }

  // 添加对升级弹窗点击取消，后续不再弹出的那些版本号
  static Future<bool> addCancelShowVersion(
    String serviceVersion,
    String serviceBuildNumber,
  ) async {
    String versionId = '${serviceVersion}(${serviceBuildNumber})';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cancelShowVersions =
        prefs.getStringList(cancelShowVersionsKey) ?? [];

    if (cancelShowVersions.contains(versionId) == false) {
      //cancelShowVersions.add(versionId);
      cancelShowVersions.insert(0, versionId);
    }
    return prefs.setStringList(cancelShowVersionsKey, cancelShowVersions);
  }

  // 获取点击跳过，不再提示更新的版本
  static Future<List<String>> getCancelShowVersion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cancelShowVersions =
        prefs.getStringList(cancelShowVersionsKey) ?? [];

    return cancelShowVersions;
  }

  static Future<ServiceVersionCompareResult> checkNeedShowUpdateView(
    String serviceVersion,
    String serviceBuildNumber,
    bool isManualCheck,
  ) async {
    BranchPackageInfo packageInfo = await BranchPackageInfo.fromPlatform();
    String appVersion = packageInfo.version;

    int currentVersionValue = getVersionValue(appVersion);
    int newVersionValue = getVersionValue(serviceVersion);

    bool hasNewVersion = newVersionValue > currentVersionValue;
    if (hasNewVersion == false && newVersionValue == currentVersionValue) {
      int currentVersionBuildNumber = getVersionValue(packageInfo.buildNumber);
      int newVersionBuildNumber = getVersionValue(serviceBuildNumber);

      hasNewVersion = newVersionBuildNumber > currentVersionBuildNumber;
    }

    // 没有新版本的情况：
    if (hasNewVersion == false) {
      return ServiceVersionCompareResult.noNew;
    }

    // 有新版本的情况下：
    ServiceVersionCompareResult compareResult =
        await getCompareResultWhenHasNewVersion(
            serviceVersion, serviceBuildNumber, isManualCheck);

    return compareResult;
  }

  // 在有新版本的情况，判断某个版本是否要弹出弹窗
  static Future<ServiceVersionCompareResult> getCompareResultWhenHasNewVersion(
    String serviceVersion,
    String serviceBuildNumber,
    bool isManualCheck,
  ) async {
    String currrentNewVersionId = '${serviceVersion}(${serviceBuildNumber})';
    // 有新版本的情况下：
    // 如果是手动检查，那一定展示
    if (isManualCheck == true) {
      return ServiceVersionCompareResult.newAndShow;
    }

    // 如果是程序启动，自动检查的，那需要判断新版本要不要弹出
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> cancelShowVersions =
        prefs.getStringList(cancelShowVersionsKey);

    ServiceVersionCompareResult compareResult =
        ServiceVersionCompareResult.newAndShow;
    if (cancelShowVersions != null) {
      if (cancelShowVersions.contains(currrentNewVersionId) == true) {
        compareResult = ServiceVersionCompareResult.newButNoShow;
      }
    }

    return compareResult;
  }

  // 获取 版本号version后者buildNumber 的数值
  static int getVersionValue(String appVersion) {
    if (appVersion == null) {
      return 0;
    }
    List<String> versionList = appVersion.split(".");

    // if (versionList.length >= 3) {
    //   versionList = versionList.sublist(0, 3);
    // }
    // int versionValue = int.parse(versionList[0]) * 10000 +
    //     int.parse(versionList[1]) * 100 +
    //     int.parse(versionList[2]) * 1;

    int count = versionList.length;
    int versionValue = 0;
    for (var i = 0; i < count; i++) {
      String versionComponent = versionList[i];
      int versionComponentValue =
          int.parse(versionComponent) * pow(10, 2 * (count - 1 - i));
      versionValue += versionComponentValue;
    }

    return versionValue;
  }
}
