import 'dart:math';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import '../branch_package_info/branch_package_info.dart';
export '../branch_package_info/branch_package_info.dart';
import './udpate_version_page.dart';

// 服务器的版本与本地版本的比较结果
enum ServiceVersionCompareResult {
  noNew, // 不是新版本
  newButNoShow, // 是新版本但不显示
  newAndShow, // 是新版本且展示
}

class CheckVersionCommonUtil {
  static GlobalKey<UpdateVersionPageState> updateVersionPageKey = GlobalKey();

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
    bool isManualCheck, {
    required bool isServiceNeedForceUpdate,
  }) async {
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
      serviceVersion,
      serviceBuildNumber,
      isManualCheck,
      isServiceNeedForceUpdate: isServiceNeedForceUpdate,
    );

    return compareResult;
  }

  // 在有新版本的情况，判断某个版本是否要弹出弹窗
  static Future<ServiceVersionCompareResult> getCompareResultWhenHasNewVersion(
    String serviceVersion,
    String serviceBuildNumber,
    bool isManualCheck, {
    required bool isServiceNeedForceUpdate,
  }) async {
    String currrentNewVersionId = '${serviceVersion}(${serviceBuildNumber})';
    // 有新版本的情况下：
    // 如果是手动检查，那一定展示
    if (isManualCheck == true) {
      return ServiceVersionCompareResult.newAndShow;
    }

    // 如果是程序启动，自动检查的，那需要判断新版本要不要弹出
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cancelShowVersions =
        prefs.getStringList(cancelShowVersionsKey);

    ServiceVersionCompareResult compareResult =
        ServiceVersionCompareResult.newAndShow;
    if (cancelShowVersions != null && isServiceNeedForceUpdate != true) {
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
          int.parse(versionComponent) * pow(10, 2 * (count - 1 - i)).toInt();
      versionValue += versionComponentValue;
    }

    return versionValue;
  }

  static showUpdateView({
    required BuildContext context,
    required bool forceUpdate,
    required String version,
    required String buildNumber,
    required String updateLog,
    required String downloadUrl,
    required void Function() skipUpdateBlock,
  }) {
    if (UpdateVersionPage.isUpdateWindowShowing != true) {
      UpdateVersionPage.isUpdateWindowShowing = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return UpdateVersionPage(
            key: updateVersionPageKey,
            forceUpdate: forceUpdate,
            version: version,
            buildNumber: buildNumber,
            updateLog: updateLog,
            downloadUrl: downloadUrl,
            updateVersionBlock: () async {
              bool goSuccess = await _launcherAppDownloadUrl(downloadUrl);
              if (goSuccess != true) {
                ToastUtil.showMsg("Error:无法打开网页$downloadUrl", context);
              }
            },
            skipUpdateBlock: () {
              if (skipUpdateBlock != null) {
                skipUpdateBlock();
              }
              UpdateVersionPage.isUpdateWindowShowing = false;
            },
            closeUpdateBlock: () {
              UpdateVersionPage.isUpdateWindowShowing = false;
            },
          );
        },
      );
    } else {
      if (updateVersionPageKey.currentState != null) {
        updateVersionPageKey.currentState!.updateData(
          newVersion: version,
          buildNumber: buildNumber,
          updateLog: updateLog,
        );
      }
    }
  }

  static Future<bool> _launcherAppDownloadUrl(String url) async {
    if (url == null) {
      return false;
    }
    if (await canLaunch(url)) {
      return launch(url);
    } else {
      return false;
    }
  }
}
