import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import './version_bean.dart';
import './udpate_version_page.dart';

void checkVersionBean(VersionBean bean, BuildContext context) async {
  bool hasNewVersion = await checkVersion(bean);
  if (hasNewVersion == false) {
    return;
  }

  // 有新版本
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return UpdateVersionPage(
        versionBean: bean,
      );
    },
  );
}

Future<bool> checkVersion(VersionBean bean) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;
  List<String> currentVersionList = appVersion.split(".");
  if (currentVersionList.length >= 3) {
    currentVersionList = currentVersionList.sublist(0, 3);
  }
  int currentVersionValue = getVersionValue(appVersion);
  int newVersionValue = getVersionValue(bean.version);

  bool hasNew = newVersionValue > currentVersionValue;
  if (hasNew == false && newVersionValue == currentVersionValue) {
    hasNew = int.parse(bean.buildNumber) > int.parse(packageInfo.buildNumber);
  }
  return hasNew;
}

int getVersionValue(String appVersion) {
  List<String> versionList = appVersion.split(".");
  if (versionList.length >= 3) {
    versionList = versionList.sublist(0, 3);
  }
  int versionValue = int.parse(versionList[0]) * 10000 +
      int.parse(versionList[1]) * 100 +
      int.parse(versionList[2]) * 1;

  return versionValue;
}
