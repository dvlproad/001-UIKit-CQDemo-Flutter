import 'dart:io';
import 'dart:ui';

// import 'package:c1440_app/app_top_notifier.dart';
// import 'package:c1440_app/data/account/account_manager.dart';
// import 'package:c1440_app/data/sp/sp_util.dart';

// import 'package:c1440_app/modules/playlist_detail_page/playlist_detail_bean.dart';
// import 'package:c1440_app/router/routes.dart';
// import 'package:c1440_app/service/service_method.dart';
// import 'package:c1440_app/service/service_url.dart';
// import 'package:c1440_app/util/time_util.dart';
import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_network/flutter_network.dart';
// import 'package:umeng_analytics_plugin/umeng_analytics_plugin.dart';

// import 'adbanner_bean.dart';
// import 'gps_bean.dart';
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
        isson: result['isson'],
        downloadUrl: result['downloadUrl'],
      );

      return bean;
    });
  }

  ///版本检查:蒲公英
  Future<VersionBean> checkPgyerVersion() async {
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
    return await NetworkUtil.postRequestUrl(
      'https://www.pgyer.com/apiv2/app/check',
      customParams: {
        "buildVersion": appVersion,
        "bundleID": appBundleID,
        "source": platformName,
        // "channel": channel ?? "official",
        "_api_key": 'da2bc35c7943aa78e66ee9c94fdd0824',
        "appKey": '75d83cbf952b69e203fb58f0116f3976',
      },
      cancelToken: cancelToken,
    ).then((ResponseModel responseModel) {
      Map result = responseModel.result;
      VersionBean bean = VersionBean.fromParams(
        version: result['version'],
        isson: result['isson'],
        downloadUrl: result['downloadUrl'],
      );

      return bean;
    });
  }
}
