// ignore_for_file: depend_on_referenced_packages

/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-26 01:26:16
 * @Description: 检查版本的工具类
 */
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:app_network/app_network.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';

class CheckVersionSystemUtil<T extends VersionBaseBean> {
  // 之前对升级弹窗点击取消，后续不再弹出的那些版本号
  static void cancelShowVersion<T extends VersionBaseBean>(T bean) async {
    CheckVersionCommonUtil.addCancelShowVersion(bean.version, bean.buildNumber);
  }

  ///版本检查:蒲公英
  static Future<ResponseModel> getVersion({CancelToken? cancelToken}) async {
    String platform = '';
    if (Platform.isAndroid) {
      platform = 'Android';
    } else {
      platform = 'iOS';
    }
    // String channel = await UmengAnalyticsPlugin.getChannel();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber; // 为了不升级version，也能检测到更新
    final params = {
      // "channel": channel ?? "official",
      'version': version, // 以防后台不从header中取
      'buildNumber': buildNumber, // 以防后台不从header中取
      'platform': platform, // 以防后台不从header中取
    };

    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      MethodChannel methodChannel = const MethodChannel("android_channel_info");
      final map = await methodChannel.invokeMethod("getChannelInfo");
      if (map != null) {
        params["channel"] = map["channel"];
      }
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      params["deviceId"] = androidInfo.id ?? '';
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      params["deviceId"] = iosInfo.identifierForVendor ?? '';
    }

    return AppNetworkManager()
        .get(
      'config/check-version',
      customParams: params,
      // cancelToken: cancelToken,
    )
        .then((ResponseModel responseModel) {
      if (responseModel.isSuccess && responseModel.result != null) {
        dynamic result = responseModel.result;
        // 测试代码
        // result["hasUpdateVersion"] = true;
        // result['lastVersionNo'] = '1.0.1';
        bool? hasNewVersion = result["hasUpdateVersion"];

        String buildNumber = '1';
        if (result['buildNumber'] != null) {
          buildNumber = result['buildNumber'].toString(); // 兼容后台返回int值
        }

        responseModel.result = VersionBaseBean(
          version: result['lastVersionNo'],
          buildNumber: buildNumber,
          buildHaveNewVersion: hasNewVersion,
          updateLog: result['versionMsg'],
          downloadUrl: result['downloadUrl'],
          forceUpdate: result['forceUpdateFlag'] ?? false,
        );
      }
      return responseModel;
    });
  }
}
