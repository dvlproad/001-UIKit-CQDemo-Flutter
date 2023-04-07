// ignore_for_file: depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

// common
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
// inner 内测功能

// formal 正式的外测功能
import 'package:app_network/app_network.dart';
import './system/check_version_system_util.dart';

import 'package:flutter_log_with_env/flutter_log_with_env.dart';
import 'package:device_info_plus/device_info_plus.dart';

class CheckVersionUtil {
  // 设置 app 的 navigatorKey(用来处理悬浮按钮的展示)
  static late GlobalKey<State<StatefulWidget>> _navigatorKey;
  static bool _useOtherVersionApi = false; // 是否使用其他版本检查接口(蒲公英)
  static void initVersion(
    GlobalKey<State<StatefulWidget>> globalKey, {
    bool useOtherVersionApi = false,
  }) {
    _useOtherVersionApi = useOtherVersionApi;
    _navigatorKey = globalKey;
    if (_navigatorKey == null) {
      throw Exception('Warning:请先设置CheckVersionUtil.initVersion');
    }
  }

  static Future checkVersion({
    bool isManualCheck = false, // 是否是手动检查，手动检查即使点击取消，也应该弹窗
    String? Function(String realServiceVersion)?
        changeServiceVersionBlock, // 改变后台返回的版本号，用于模拟在此版本后，发了一个新版本时候的检查更新弹窗是否可用的功能
    String? Function(String realServiceBuildNumber)?
        changeServiceBuildNumberBlock, // 改变后台返回的版本号，用于模拟在此版本后，发了一个新版本时候的检查更新弹窗是否可用的功能
  }) async {
    if (_navigatorKey.currentContext == null) {
      // throw Exception('Warning:navigatorKey!.currentContext不能为空');
      debugPrint('Warning:navigatorKey!.currentContext不能为空');
      return;
    }

    BuildContext context = _navigatorKey.currentContext!;

    late ResponseModel responseModel;
    if (_useOtherVersionApi == true) {
      responseModel = ResponseModel(
        statusCode: -100,
        message: '请补充其他版本控制的接口',
      );
      AppLogUtil.logMessage(
        logType: LogObjectType.api_app,
        logLevel: LogLevel.warning,
        shortMap: {
          "message": '版本检查代码出错了，请补充其他版本控制的接口',
        },
        detailMap: {
          "message": '版本检查代码出错了，请补充其他版本控制的接口',
        },
      );
    } else {
      responseModel = await CheckVersionSystemUtil.getVersion();
    }

    if (responseModel.isSuccess != true) {
      // ToastUtil.showMessage("Error:版本检查请求失败:${responseModel.message}");
      return;
    }

    if (responseModel.result == null) {
      return;
    }
    VersionBaseBean bean = responseModel.result;
    if (changeServiceVersionBlock != null) {
      String? newServiceVersion = changeServiceVersionBlock(bean.version);
      if (newServiceVersion != null && newServiceVersion.isNotEmpty) {
        bean.version = newServiceVersion;
      }
    }
    if (changeServiceBuildNumberBlock != null) {
      String? newServiceBuildNumber =
          changeServiceBuildNumberBlock(bean.buildNumber);
      if (newServiceBuildNumber != null && newServiceBuildNumber.isNotEmpty) {
        bean.buildNumber = newServiceBuildNumber;
      }
    }

    bool shouldShow = await checkShouldShow(bean, isManualCheck,
        noNewPrompt: bean.noNewPrompt);
    if (shouldShow != true) {
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
      notNowBlock: () async {
        final deviceInfo = DeviceInfoPlugin();
        final params = Map<String, String>();
        if (Platform.isIOS) {
          IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
          params["deviceId"] = iosInfo.identifierForVendor ?? '';
        } else {
          AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
          params["deviceId"] = androidInfo.id ?? '';
        }
        params["buildNo"] = buildNumber;
        params["versionNo"] = bean.version;
        AppNetworkManager()
            .post("/config/check-version/close", customParams: params);
      },
    );
  }

  static Future<bool> checkShouldShow(
    VersionBaseBean? bean,
    bool isManualCheck, {
    String? noNewPrompt,
  }) async {
    if (bean == null) {
      return false;
    }

    // 新版本可能确实是新的情况下：
    ServiceVersionCompareResult compareResult =
        await CheckVersionCommonUtil.checkNeedShowUpdateView(
      bean.version,
      bean.buildNumber,
      isManualCheck,
      buildHaveNewVersion: bean.buildHaveNewVersion,
      isServiceNeedForceUpdate: bean.forceUpdate,
    );

    if (compareResult == ServiceVersionCompareResult.noNew) {
      if (isManualCheck == true) {
        // 手动检查才弹提示
        ToastUtil.showMessage(noNewPrompt ?? '当前是最新版本~');
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
    if (_useOtherVersionApi == true) {
      CheckVersionSystemUtil.cancelShowVersion(bean);
    } else {
      debugPrint("警告⚠️：'Error:请补充内测功能3'");
    }
  }
}
