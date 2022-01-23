import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:dio/dio.dart';

import 'package:package_info/package_info.dart';
import 'dart:io' show Platform;
import 'dart:convert' as convert;

class TSDioHomePage extends StatefulWidget {
  @override
  _TSNetworkHomePageState createState() => _TSNetworkHomePageState();
}

class _TSNetworkHomePageState extends State<TSDioHomePage> {
  CancelToken cancelToken;
  void dispose() {
    cancelToken?.cancel();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dio'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('蒲公英:Pyger'),
              onTap: () {
                checkPgyerVersion();
              },
            ),
          ],
        ),
      ),
    );
  }

  ///版本检查:蒲公英
  Future<Map> checkPgyerVersion() async {
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
      CJTSToastUtil.showMessage('没有新版本');
    } else {
      String buildVersion = result['buildVersion']; //版本号, 默认为1.0
      String buildBuildVersion = result['buildBuildVersion'];

      String updteContent = result['buildUpdateDescription']; //应用更新说明
      if (updteContent.isEmpty) {
        updteContent = '更新说明省略';
      }
      CJTSToastUtil.showMessage(
          '$buildVersion\_$buildBuildVersion已更新\n$updteContent');
    }
    return result;
  }
}
