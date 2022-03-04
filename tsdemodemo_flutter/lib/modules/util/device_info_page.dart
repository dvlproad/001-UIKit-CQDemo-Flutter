/// [Flutter学习之获取APP基本信息](https://blog.csdn.net/Pillar1066527881/article/details/89176604)
/// [Flutter获取APP信息](https://www.jianshu.com/p/5352d39744f8)
/// [package_info 0.4.1](https://pub.dev/packages/package_info/example)
/// [device_info 0.4.2+4](https://pub.flutter-io.cn/packages/device_info/install)
/// [在flutter中判断平台，获取设备信息](https://segmentfault.com/a/1190000014913010?utm_source=index-hottest)
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_demo_kit/tableview/CJTSSectionTableView.dart';

class TSDeviceInfoPage extends StatefulWidget {
  final String title;

  TSDeviceInfoPage({Key key, this.title}) : super(key: key);

  @override
  _TSDeviceInfoPageState createState() => _TSDeviceInfoPageState();
}

class _TSDeviceInfoPageState extends State<TSDeviceInfoPage> {
  String platformName = '';
  String appName = '';
  String appVersion = '';
  String appBundleID = '';
  String appBuildID = '';

  @override
  void initState() {
    super.initState();

    _getDeviceInfo();
  }

  void _getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if (Platform.isAndroid) {
      platformName = 'android';
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      print(_readAndroidBuildData(androidDeviceInfo).toString());

      appVersion = androidDeviceInfo.version.codename;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      print(_readIosDeviceInfo(iosDeviceInfo).toString());

      platformName = iosDeviceInfo.systemName;
    }

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    appName = packageInfo.appName;
    appBundleID = packageInfo.packageName;
    appVersion = packageInfo.version;
    appBuildID = packageInfo.buildNumber;

    setState(() {});
  }

  Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
    return <String, dynamic>{
      'name': data.name,
      'systemName': data.systemName,
      'systemVersion': data.systemVersion,
      'model': data.model,
      'localizedModel': data.localizedModel,
      'identifierForVendor': data.identifierForVendor,
      'isPhysicalDevice': data.isPhysicalDevice,
      'utsname.sysname:': data.utsname.sysname,
      'utsname.nodename:': data.utsname.nodename,
      'utsname.release:': data.utsname.release,
      'utsname.version:': data.utsname.version,
      'utsname.machine:': data.utsname.machine,
    };
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
    return <String, dynamic>{
      'version.securityPatch': build.version.securityPatch,
      'version.sdkInt': build.version.sdkInt,
      'version.release': build.version.release,
      'version.previewSdkInt': build.version.previewSdkInt,
      'version.incremental': build.version.incremental,
      'version.codename': build.version.codename,
      'version.baseOS': build.version.baseOS,
      'board': build.board,
      'bootloader': build.bootloader,
      'brand': build.brand,
      'device': build.device,
      'display': build.display,
      'fingerprint': build.fingerprint,
      'hardware': build.hardware,
      'host': build.host,
      'id': build.id,
      'manufacturer': build.manufacturer,
      'model': build.model,
      'product': build.product,
      'supported32BitAbis': build.supported32BitAbis,
      'supported64BitAbis': build.supported64BitAbis,
      'supportedAbis': build.supportedAbis,
      'tags': build.tags,
      'type': build.type,
      'isPhysicalDevice': build.isPhysicalDevice,
      'androidId': build.androidId
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _pageWidget(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('DeviceInfo模块'),
    );
  }

  Widget _pageWidget() {
    var sectionModels = [
      {
        'theme': "组件",
        'values': [
          {'title': "platformName(app平台)", 'detailText': platformName},
          {'title': "appName(app名)", 'detailText': appName},
          {'title': "appVersion(app版本号)", 'detailText': appVersion},
          {'title': "appBundleID", 'detailText': appBundleID},
          {'title': "appBuildID(app编译版本号)", 'detailText': appBuildID},
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
