import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'dart:io' show Platform;
import 'dart:convert' as convert;

import './version_pyger_bean.dart';
export './version_pyger_bean.dart';

import './check_version_common_util.dart';
export './check_version_common_util.dart' show ServiceVersionCompareResult;

class PygerUtil {
  // 之前对升级弹窗点击取消，后续不再弹出的那些版本号
  static void cancelShowVersion(VersionPygerBean bean) async {
    CheckVersionCommonUtil.addCancelShowVersion(bean.version, bean.buildNumber);
  }

  ///版本检查:蒲公英
  static Future<VersionPygerBean> getVersion() async {
    String platformName = "";
    String appKey = "";
    if (Platform.isIOS) {
      platformName = 'ios';
      appKey = "3aa46e5f75c648922bb2450ac2da7909";
    } else if (Platform.isAndroid) {
      platformName = 'android';
      appKey = "0ff51c2519a23078fac1f8e8ea1bbdef";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    String url = 'https://www.pgyer.com/apiv2/app/check';
    Map<String, dynamic> customParams = {
      "_api_key": "a6f5a92ffe5f43677c5580de3e1e0d99",
      "appKey": appKey,
      "buildVersion": appVersion,
      "buildBuildVersion": buildBuildVersion,
    };
    Options options = Options(
      contentType: "application/x-www-form-urlencoded",
    );

    CancelToken cancelToken = CancelToken();

    Dio dio = Dio();

    Response response = await dio.post(
      url,
      data: customParams,
      options: options,
      cancelToken: cancelToken,
    );

    Map responseObject = response.data;
    if (responseObject['code'] != 0) {
      String errorMessage = responseObject['message'];
      print('蒲公英请求失败:errorMessage=$errorMessage');
      return null;
    }

    Map result = responseObject['data'];
    //print('蒲公英请求结果:result=${result.toString()}');
    bool hasNew = result['buildHaveNewVersion']; //是否有新版本

    if (hasNew == false) {
      //print('没有新版本');
      return null;
    } else {
      // 新版本 version_buildId
      String buildVersion = result['buildVersion']; // 版本号, 默认为1.0
      String buildNumber = result['buildVersionNo']; // 上传包的版本编号，默认为1 (即编译的版本号)
      String buildBuildVersion =
          result['buildBuildVersion']; // 蒲公英生成的用于区分历史版本的build号
      bool buildHaveNewVersion = result['buildHaveNewVersion'];

      //应用更新说明
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion =
          "您当前的版本为${packageInfo.version}(${packageInfo.buildNumber})";
      String newVersion = '检查到有新版本$buildVersion($buildNumber)';
      String updteDescription = result['buildUpdateDescription'];
      if (updteDescription.isEmpty) {
        updteDescription = '更新说明略';
      }
      // String updateContent = '$currentVersion\n$newVersion\n$updteDescription';
      List<String> lineStrings = [currentVersion, newVersion, updteDescription];
      String updateContent = _getNewLineString(lineStrings);

      //应用安装地址
      String downloadURL = result['downloadURL'];

      // print(
      //     '版本:$buildVersion\_$buildNumber已更新\n更新内容:updteContent\n下载地址:$downloadURL');

      VersionPygerBean bean = VersionPygerBean.fromParams(
        version: buildVersion,
        buildNumber: buildNumber,
        buildNumberInPyger: buildBuildVersion,
        buildHaveNewVersion: buildHaveNewVersion,
        updateLog: updateContent,
        downloadUrl: downloadURL,
      );
      return bean;
    }
  }

  static String _getNewLineString(List<String> lineStrings) {
    StringBuffer sb = new StringBuffer();
    for (String line in lineStrings) {
      sb.write(line + "\n");
    }
    return sb.toString();
  }

  static Future<ServiceVersionCompareResult> checkNeedShowUpdateView(
    VersionPygerBean bean,
    bool isManualCheck,
  ) async {
    bool hasNewVersion = bean.buildHaveNewVersion;

    // 没有新版本的情况：
    if (hasNewVersion == false) {
      return ServiceVersionCompareResult.noNew;
    }

    // 新版本可能确实是新的情况下：
    return CheckVersionCommonUtil.checkNeedShowUpdateView(
      bean.version,
      bean.buildNumber,
      isManualCheck,
    );
  }

  ///获取App所有版本:蒲公英
  static Future<VersionPygerBean> getPgyerHistoryVersions() async {
    String platformName = "";
    String appKey = "";
    if (Platform.isIOS) {
      platformName = 'ios';
      appKey = "3aa46e5f75c648922bb2450ac2da7909";
    } else if (Platform.isAndroid) {
      platformName = 'android';
      appKey = "0ff51c2519a23078fac1f8e8ea1bbdef";
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    String buildBuildVersion = packageInfo.buildNumber;

    String url = 'https://www.pgyer.com/apiv2/app/builds';
    Map<String, dynamic> customParams = {
      "_api_key": "a6f5a92ffe5f43677c5580de3e1e0d99",
      "appKey": appKey,
      "buildKey": 'com.bojue.wish',
      "page": 3, //(选填) 历史版本分页页数
    };
    Options options = Options(
      contentType: "application/x-www-form-urlencoded",
    );

    CancelToken cancelToken = CancelToken();

    Dio dio = Dio();

    Response response = await dio.post(
      url,
      data: customParams,
      options: options,
      cancelToken: cancelToken,
    );

    Map responseObject = response.data;
    if (responseObject['code'] != 0) {
      String errorMessage = responseObject['message'];
      print('蒲公英请求失败:errorMessage=$errorMessage');
      return null;
    }

    Map result = responseObject['data'];
    print('蒲公英请求结果:result=${result.toString()}');

    // VersionPygerBean bean = VersionPygerBean.fromParams(
    //   version: buildVersion,
    //   buildNumber: buildNumber,
    //   updateLog: updteContent,
    //   downloadUrl: downloadURL,
    // );
    return null;
  }
}
