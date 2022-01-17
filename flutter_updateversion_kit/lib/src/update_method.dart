import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import './version_bean.dart';
import './udpate_version_page.dart';

void versionUpdateDialog(VersionBean bean, BuildContext context) async {
  bool b = await checkVersion(bean);
  if (b) {
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
}

Future<bool> checkVersion(VersionBean bean) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String appVersion = packageInfo.version;
  List<String> currentVersionList = appVersion.split(".");
  if (currentVersionList.length >= 3) {
    currentVersionList = currentVersionList.sublist(0, 3);
  }
  int currentVersionValue = int.parse(currentVersionList[0]) * 10000 +
      int.parse(currentVersionList[1]) * 100 +
      int.parse(currentVersionList[2]) * 1;

  int newVersionValue = int.parse(bean.version);

  bool hasNew = newVersionValue > currentVersionValue;
  return hasNew;
}
