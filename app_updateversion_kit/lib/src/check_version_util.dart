import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

// common
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
// pgyer
import 'package:pgyer_updateversion_kit/pgyer_updateversion_kit.dart';

// system
import 'package:app_network/app_network.dart' show ResponseModel;
import './system/check_version_system_util.dart';
import './system/version_system_bean.dart';

class CheckVersionUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static late GlobalKey<State<StatefulWidget>> _navigatorKey;

  static bool isUsePygerVersion = false; // 是否使用蒲公英上的版本

  static void initPyger(
    UpdateAppType pgyerAppType,
    GlobalKey<State<StatefulWidget>> globalKey,
  ) {
    isUsePygerVersion = true;
    PygerUtil.init(
      pgyerAppType: pgyerAppType,
    );
    _navigatorKey = globalKey;

    if (_navigatorKey == null) {
      throw Exception('Warning:请先设置CheckVersionUtil.initPyger');
    }
  }

  static void initSytem(GlobalKey<State<StatefulWidget>> globalKey) {
    isUsePygerVersion = false;
    _navigatorKey = globalKey;
    if (_navigatorKey == null) {
      throw Exception('Warning:请先设置CheckVersionUtil.initSytem');
    }
  }

  static Future checkVersion({
    bool isManualCheck = false, // 是否是手动检查，手动检查即使点击取消，也应该弹窗
  }) async {
    if (_navigatorKey.currentContext == null) {
      throw Exception('Warning:navigatorKey!.currentContext不能为空');
    }

    BuildContext context = _navigatorKey.currentContext!;

    late ResponseModel responseModel;
    if (isUsePygerVersion == true) {
      responseModel = await PygerUtil.getVersion();
    } else {
      responseModel = await CheckVersionSystemUtil.getVersion();
    }

    if (responseModel.isSuccess != true) {
      // ToastUtil.showMsg("Error:版本检查请求失败:${responseModel.message}", context);
      return;
    }

    if (responseModel.result == null) {
      return;
    }
    VersionBaseBean bean = responseModel.result;

    bool _shouldShow = await shouldShow(bean, isManualCheck);
    if (_shouldShow != true) {
      return;
    }

    // 有新版本
    String newVersion = bean.newVersion;

    String buildNumber = bean.buildNumber;
    String? updateLog = await bean.updateContent;
    String downloadUrl = bean.downloadUrl;
    bool forceUpdate = bean.forceUpdate;
    CheckVersionCommonUtil.showUpdateView(
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
        cancelShowVersion(bean);
      },
    );
  }

  static Future<bool> shouldShow(
    VersionBaseBean? bean,
    bool isManualCheck,
  ) async {
    if (bean == null) {
      return false;
    }

    // 新版本可能确实是新的情况下：
    ServiceVersionCompareResult compareResult =
        await CheckVersionCommonUtil.checkNeedShowUpdateView(
      bean.version,
      bean.buildNumber,
      isManualCheck,
      isServiceNeedForceUpdate: bean.forceUpdate,
    );

    if (compareResult == ServiceVersionCompareResult.noNew) {
      if (isManualCheck == true) {
        // 手动检查才弹提示
        String message = '当前已是最新版本';
        ToastUtil.showMessage(message);
      }
      return false;
    }

    if (compareResult == ServiceVersionCompareResult.newButNoShow) {
      return false;
    }

    return true;
  }

  // 之前对升级弹窗点击取消，后续不再弹出的那些版本号
  static void cancelShowVersion<T extends VersionBaseBean>(T bean) async {
    if (isUsePygerVersion == true) {
      CheckVersionSystemUtil.cancelShowVersion(bean);
    } else {
      PygerUtil.cancelShowVersion(bean);
    }
  }
}
