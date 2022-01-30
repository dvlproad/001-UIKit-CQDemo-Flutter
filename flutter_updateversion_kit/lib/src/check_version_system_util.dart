import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_network/flutter_network.dart';
import 'dart:io' show Platform;
import 'dart:convert' as convert;

import './version_bean.dart';
export './version_bean.dart';

import './check_version_common_util.dart';
export './check_version_common_util.dart' show ServiceVersionCompareResult;

class CheckVersionSystemUtil {
  // 之前对升级弹窗点击取消，后续不再弹出的那些版本号
  static void cancelShowVersion(VersionBean bean) async {
    CheckVersionCommonUtil.addCancelShowVersion(bean.version, bean.buildNumber);
  }

  ///版本检查:蒲公英
  static Future<VersionBean> getVersion({CancelToken cancelToken}) async {
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

  static Future<ServiceVersionCompareResult> checkNeedShowUpdateView(
    VersionBean bean,
    bool isManualCheck,
  ) async {
    return CheckVersionCommonUtil.checkNeedShowUpdateView(
      bean.version,
      bean.buildNumber,
      isManualCheck,
    );
  }
}
