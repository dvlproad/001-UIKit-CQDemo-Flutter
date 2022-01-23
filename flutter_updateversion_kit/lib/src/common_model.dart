import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_network/flutter_network.dart';

import './version_bean.dart';
export './version_bean.dart';

class CommonModel {
  // CommonModel _commonModel;

  static final CommonModel _instance = CommonModel._internal();

  factory CommonModel() => _instance;

  // CommonModel get mediaModel => _commonModel;

  CommonModel._internal() {
    // if (_commonModel == null) {
    //   _commonModel = CommonModel();
    // }
  }

  CancelToken cancelToken;

  void dispose() {
    // cancelToken?.cancel();
  }

  int uploadDeviceLastTime = 0;

  ///版本检查
  Future<VersionBean> checkVersion() async {
    String platformName = "";
    if (Platform.isIOS) {
      platformName = 'ios';
    } else if (Platform.isAndroid) {
      platformName = 'android';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    // String channel = await UmengAnalyticsPlugin.getChannel();
    return await NetworkUtil.getRequestUrl(
      'http://121.41.91.92:3000/mock/28/check_version',
      customParams: {
        "version": appVersion,
        "bundleID": appBundleID,
        "source": platformName,
        // "channel": channel ?? "official",
      },
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      Map result = responseModel.result;
      VersionBean bean = VersionBean.fromParams(
        version: result['version'],
        buildNumber: result['buildNumber'],
        updateLog: result['updateLog'],
        downloadUrl: result['downloadUrl'],
      );

      return bean;
    });
  }
}
