import 'package:dio/dio.dart';
import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'dart:convert' as convert;

import './version_bean.dart';
export './version_bean.dart';

class PygerUtil {
  ///版本检查:蒲公英
  static Future<VersionBean> checkPgyerVersion() async {
    String platformName = "";
    if (Platform.isIOS) {
      platformName = 'ios';
    } else if (Platform.isAndroid) {
      platformName = 'android';
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appBundleID = packageInfo.packageName;
    String appVersion = packageInfo.version;
    int buildBuildVersion = int.parse(packageInfo.buildNumber);

    String url = 'https://www.pgyer.com/apiv2/app/check';
    Map<String, dynamic> customParams = {
      "_api_key": "da2bc35c7943aa78e66ee9c94fdd0824",
      "appKey": '5e34747de524873d74a10cda1967c56b',
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
    Map result = responseObject['data'];
    print('蒲公英请求结果:result=${result.toString()}');
    bool hasNew = result['buildHaveNewVersion']; //是否有新版本

    if (hasNew == false) {
      print('没有新版本');
      return null;
    } else {
      // 新版本 version_buildId
      String buildVersion = result['buildVersion']; //版本号, 默认为1.0
      String buildNumber = result['buildBuildVersion']; // 蒲公英生成的用于区分历史版本的build号

      //应用更新说明
      String updteContent = result['buildUpdateDescription'];
      if (updteContent.isEmpty) {
        updteContent = '更新说明省略';
      }

      //应用安装地址
      String downloadURL = result['downloadURL'];

      print(
          '版本:$buildVersion\_$buildNumber已更新\n更新内容:updteContent\n下载地址:$downloadURL');

      VersionBean bean = VersionBean.fromParams(
        version: buildVersion,
        buildNumber: buildNumber,
        updateLog: updteContent,
        downloadUrl: downloadURL,
      );
      return bean;
    }
  }
}
