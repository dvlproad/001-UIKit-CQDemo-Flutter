import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import './check_version_system_util.dart';
import './check_version_pyger_util.dart';
import './version_bean.dart';
import './version_pyger_bean.dart';
import './udpate_version_page.dart';

class CheckVersionUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static GlobalKey navigatorKey;

  static bool isUsePygerVersion; // 是否使用蒲公英上的版本
  static String packageDownloadUrl; // 安装包的下载地址
  static String pygerAppKey; // 应用在蒲公英上的appKey
  static void init({
    @required
        String Function() downloadUrlGetBlock, // 下载地址的获取方法(不同环境的版本有不同的下载地址)
    bool isPyger = false, // 是否使用蒲公英上的版本
    String Function() pygerAppKeyGetBlock, // 蒲公英上的appkey的获取方法
  }) {
    packageDownloadUrl = downloadUrlGetBlock();

    isUsePygerVersion = isPyger;
    if (isPyger) {
      assert(pygerAppKeyGetBlock != null);
      pygerAppKey = pygerAppKeyGetBlock();
    }
  }

  static Future checkVersion({
    bool isManualCheck = false, // 是否是手动检查，手动检查即使点击取消，也应该弹窗
  }) {
    // if (VersionManager.instance.firstSHow) {
    //   VersionManager.instance.setFirstShow(false);
    //    _getAppVersion(context);
    // }

    // launcherPyger();

    // VersionBean bean = VersionBean.fromParams(
    //   version: '10100',
    //   isson: 's..s',
    //   downloadUrl: 'downloadUrl',
    // );
    // versionUpdateDialog(bean, context);

    if (navigatorKey == null) {
      print('Warning:请先设置CheckVersionUtil.navigatorKey=');
      return throw ('Warning:请先设置CheckVersionUtil.navigatorKey=');
    }
    BuildContext context = navigatorKey.currentContext;

    if (isUsePygerVersion == true) {
      return PygerUtil.getVersion(pygerAppKey)
          .then((VersionPygerBean bean) async {
        ServiceVersionCompareResult compareResult =
            await PygerUtil.checkNeedShowUpdateView(bean, isManualCheck);
        if (compareResult == ServiceVersionCompareResult.noNew) {
          if (isManualCheck == true) {
            // 手动检查才弹提示
            String message = '当前已是最新版本';
            ToastUtil.showMsg(message, context);
          }
          return;
        }

        if (compareResult == ServiceVersionCompareResult.newButNoShow) {
          return;
        }

        // 有新版本
        String newVersion =
            '${bean.version}(${bean.buildNumber})\_${bean.buildNumberInPyger}';
        String buildNumber = bean.buildNumber;
        String updateLog = bean.updateLog;
        String downloadUrl = bean.downloadUrl;
        bool forceUpdate = bean.forceUpdate;
        showUpdateView(
          context: context,
          forceUpdate: forceUpdate,
          version: newVersion,
          buildNumber: buildNumber,
          updateLog: updateLog,
          downloadUrl: downloadUrl,
          skipUpdateBlock: () {
            if (isManualCheck == true) {
              // 手动检查，点击取消，不会影响下次是否展示
              return;
            }
            PygerUtil.cancelShowVersion(bean);
          },
        );
      });
    } else {
      return CheckVersionSystemUtil.getVersion().then((VersionBean bean) async {
        ServiceVersionCompareResult compareResult =
            await CheckVersionSystemUtil.checkNeedShowUpdateView(
                bean, isManualCheck);
        if (compareResult == ServiceVersionCompareResult.noNew) {
          if (isManualCheck == true) {
            // 手动检查才弹提示
            String message = '当前已是最新版本';
            ToastUtil.showMsg(message, context);
          }
          return;
        }

        if (compareResult == ServiceVersionCompareResult.newButNoShow) {
          return;
        }

        // 有新版本
        String newVersion = '${bean.version}(${bean.buildNumber})';
        String buildNumber = bean.buildNumber;
        String updateLog = bean.updateLog;
        String downloadUrl = bean.downloadUrl;
        bool forceUpdate = bean.forceUpdate;
        showUpdateView(
          context: context,
          forceUpdate: forceUpdate,
          version: newVersion,
          buildNumber: buildNumber,
          updateLog: updateLog,
          downloadUrl: downloadUrl,
          skipUpdateBlock: () {
            if (isManualCheck == true) {
              // 手动检查，点击取消，不会影响下次是否展示
              return;
            }
            CheckVersionSystemUtil.cancelShowVersion(bean);
          },
        );
      });
    }
  }

  static launcherPyger() async {
    var url = packageDownloadUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'cloud not launcher url';
    }
  }

  static Future showUpdateView({
    BuildContext context,
    bool forceUpdate,
    String version,
    String buildNumber,
    String updateLog,
    String downloadUrl,
    void Function() skipUpdateBlock,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return UpdateVersionPage(
          forceUpdate: forceUpdate,
          version: version,
          buildNumber: buildNumber,
          updateLog: updateLog,
          downloadUrl: downloadUrl,
          updateVersionBlock: () {
            launcherPyger();
          },
          skipUpdateBlock: skipUpdateBlock,
        );
      },
    );
  }
}
