// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-06-11 02:39:42
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-08-10 17:56:59
 * @Description: 公共参数获取帮助类
 */
import 'dart:io' show Platform;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:android_id/android_id.dart';

class CommonParamsHelper {
  static double? monitor_latitude;
  static double? monitor_longitude;
  static String? monitor_uid;
  // 渠道名称
  static String? channelName;
  // 包信息
  static PackageInfo? packageInfo;
  // 是否模拟器
  static bool? isEmulator;

  /// 是否已经同意隐私协议
  static bool hasAgreePrivacy = false;

  static const storage = FlutterSecureStorage();
  static const _flutterDeviceIdStorageKey = "flutter_device_id_storage_key";

  static final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  static const String _deviceIdPrefix = "WISH-";

  static String? _wishDeviceId;
  static String? _dynamicDeviceId;

  /// 获取缓存的设备id，优先获取存储在keyChain中的值
  static Future<String> getDeviceId() async {
    if (_wishDeviceId?.isNotEmpty == true &&
        _wishDeviceId?.contains(_deviceIdPrefix) == true) {
      return _wishDeviceId!;
    }
    String deviceId = "";
    try {
      deviceId = await storage.read(key: _flutterDeviceIdStorageKey) ?? "";
      if (deviceId.isNotEmpty && deviceId.contains(_deviceIdPrefix)) {
        _wishDeviceId = deviceId;
        return deviceId;
      }
    } on PlatformException catch (_) {
      // Workaround for https://github.com/mogol/flutter_secure_storage/issues/43
      await storage.deleteAll();
    }
    return await _getDeviceIdFromPlugin();
  }

  /// 获取会变化的设备id，iOS为 UUID，安卓为androidId
  static Future<String> getDynamicDeviceId() async {
    if (_dynamicDeviceId == null || _dynamicDeviceId?.isEmpty == true) {
      _dynamicDeviceId = await _getDeviceIdFromPlugin();
    }
    return _dynamicDeviceId!;
  }

  /// 直接从Plugin获取deviceId
  static Future<String> _getDeviceIdFromPlugin() async {
    String deviceId = "";
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      deviceId = _deviceIdPrefix + (iosInfo.identifierForVendor ?? '');
    } else {
      if (hasAgreePrivacy) {
        try {
          const androidIdPlugin = AndroidId();
          deviceId = await androidIdPlugin.getId() ?? '';
          deviceId = _deviceIdPrefix + deviceId;
        } on PlatformException {
          deviceId = 'FailToGetAndroidId';
        }
      } else {
        deviceId = "NotAgreePrivacy";
      }
    }
    if (deviceId.isNotEmpty &&
        deviceId != "FailToGetAndroidId" &&
        deviceId != "NotAgreePrivacy") {
      _wishDeviceId = deviceId;
      await storage.write(key: _flutterDeviceIdStorageKey, value: deviceId);
    }
    return deviceId;
  }

  static Future<Map<String, dynamic>> commonHeaderParams({
    required String appFeatureType,
    String? channel,
  }) async {
    // isEmulator ??= await IsEmulatorUtil.isRunningOnEmulator();
    packageInfo ??= await PackageInfo.fromPlatform();
    channelName ??= channel;
    // String appName = packageInfo.appName;
    // String packageName = packageInfo.packageName;
    String packageVersion = packageInfo!.version;
    String packagebuildNumber = packageInfo!.buildNumber;
    String deviceId = await CommonParamsHelper.getDeviceId();
    String dynamicDeviceId = await CommonParamsHelper.getDynamicDeviceId();

    Map<String, dynamic> commonHeaderParams = {
      'version': packageVersion,
      'buildNumber': packagebuildNumber,
      'platform': Platform.isIOS ? "iOS" : "Android",
      'appType': 'wish',
      'appFeatureType': appFeatureType,
      'packageChannel': channelName,
      'deviceId': deviceId,
      'dynamicDeviceId': dynamicDeviceId,
    };

    return commonHeaderParams;
  }

  static Future<Map<String, dynamic>> monitor_bodyCommonFixedParams(
      {String? channel}) async {
    packageInfo ??= await PackageInfo.fromPlatform();
    channelName ??= channel;

    String appName = packageInfo!.appName;
    String packageName = packageInfo!.packageName;
    String packageVersion = packageInfo!.version;
    String packagebuildNumber = packageInfo!.buildNumber;

    // [device_info_plus 信息整理](https://www.csdn.net/tags/NtzaQgzsNDY0ODAtYmxvZwO0O0OO0O0O.html)
    String uuid = await getDeviceId();
    String systemName = '';
    String systemVersion = '';
    String brand = '';
    String model = '';
    String machine = '';
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await _deviceInfo.iosInfo;
      debugPrint('Running on ${iosInfo.utsname.machine}'); // e.g. "iPod7,1"
      systemName = iosInfo.systemName ?? '';
      systemVersion = iosInfo.systemVersion ?? '';
      brand = iosInfo.model ?? '';
      model = iosInfo.model ?? '';
      machine = iosInfo.utsname.machine ?? '';
    } else {
      AndroidDeviceInfo androidInfo = await _deviceInfo.androidInfo;
      debugPrint('Running on ${androidInfo.model ?? ''}'); // e.g. "Moto G (4)"
      // String incremental = androidInfo.version.incremental; // 手机具体的固件型号/Ui版本
      systemName = androidInfo.version.baseOS ?? '';
      systemVersion = androidInfo.version.release ?? '';
      brand = "${androidInfo.brand ?? ''}${androidInfo.model ?? ''}"; // 手机品牌加型号
      model = androidInfo.model ?? '';
      // machine = androidInfo.utsname.machine;
    }
    if (brand.length > 200) {
      brand = brand.substring(0, 200);
    }
    if (model.length > 200) {
      model = model.substring(0, 200);
    }

    MediaQueryData mediaQuery =
        MediaQueryData.fromWindow(window); // 需 import 'dart:ui';
    // EdgeInsets padding = mediaQuery.padding;
    // padding = padding.copyWith(bottom: mediaQuery.viewPadding.top);
    // double bottomHeight = padding.top;
    double screenWidth = mediaQuery.size.width;
    double screenHeight = mediaQuery.size.height;

    double devicePixelRatio = window.devicePixelRatio; //获取设备像素比；
    // window.physicalSize; //获取屏幕尺寸；还有其他。。。

    // ConnectivityResult connectionStatus =
    //     await Connectivity().checkConnectivity();
    // String connectionStatusString = connectionStatus.toString().split('.').last;

    // String timezone = DateTime.now().timeZoneName;
    // String timezone = await FlutterNativeTimezone.getLocalTimezone();

    Map<String, dynamic> commonBodyParams = {
      "app_id": packageName,
      "app_name": appName,
      'app_version': packageVersion,
      'app_buildNumber': packagebuildNumber,
      'packageChannel': channelName,

      'platform': Platform.isIOS ? "iOS" : "Android",
      'lib': Platform.isIOS ? "iOS" : "Android",
      'systemName': systemName,
      'lib_version': systemVersion,
      'lib_method': 'code', // 埋点方式:固定值为code
      'lib_source': 1, // 埋点来源 1.愿望屋；2.喜欢屋

      // 'manufacturer': '设备制造商', // 设备制造商
      'brand': brand, // 设备品牌
      'model': model, // 设备型号
      'os': machine, // 操作系统
      // 'os_version': '操作系统版本', // 操作系统版本
      'screen_width': screenWidth,
      'screen_height': screenHeight,
      'screen_devicePixelRatio': devicePixelRatio,
      'device_id':
          uuid, // 设备ID Android 端主要取 Android ID ，iOS 端先尝试获取 IDFA，如果获取不到，则取 IDFV
      'geo_coordinate_system': 'bd09ll', // 坐标系(iOS 端默认为 WGS84, Android 端需要手动传入)
    };

    return commonBodyParams;
  }

  static Future<Map<String, dynamic>> monitor_bodyCommonChangeParams() async {
    ConnectivityResult connectionStatus =
        await Connectivity().checkConnectivity();
    String connectionStatusString = connectionStatus.toString().split('.').last;

    // String timezone = DateTime.now().timeZoneName;
    String timezone = await FlutterNativeTimezone.getLocalTimezone();
    Duration timezoneOffset = DateTime.now().timeZoneOffset;
    int timezoneOffsetMinutes = timezoneOffset.inMinutes;

    Map<String, dynamic> commonBodyParams = {
      // 'referrer_title': '前一个页面标题', // 前一个页面标题
      // 'carrier': 'SIM 卡的运营商名称', // SIM 卡的运营商名称，如果 Android 没有获取 READ_PHONE_STATE 权限，或者未插卡，则无法获取运营商名称；如果 iOS 未插卡，则无法获取运营商名称
      'network_type': connectionStatusString, // 网络类型
      'timezone': timezone, // 时区偏移量 App 或系统的时区
      'timezone_offset': timezoneOffsetMinutes, // 时区偏移值(单位分钟)
      'latitude': monitor_latitude ?? 0.0,
      'longitude': monitor_longitude ?? 0.0,
      "request_time": DateTime.now().millisecondsSinceEpoch, // 单次上报生成时间，精确到毫秒
    };

    // 用户唯一标识(用户没有登录时，客户端自动生成唯一标识)
    // 埋点 monitor_uid:后台定死，该值只能是userId，而不能自己定义个标识,且没登录的时候不传
    if (monitor_uid != null) {
      commonBodyParams.addAll({'account_id': monitor_uid});
    }

    return commonBodyParams;
  }
}
