import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  static GlobalKey<NavigatorState> globalKey;

  //获取相册权限
  static Future<bool> photos() async {
    var permissionList = <Permission>[];
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if (info.version.sdkInt >= 33) {
        permissionList.add(Permission.photos);
        permissionList.add(Permission.videos);
      } else {
        permissionList.add(Permission.storage);
      }
    } else {
      permissionList.add(Permission.photos);
    }

    var status = await permissionList.request();
    for(var element in permissionList){
      if (!status[element].isGranted && !status[element].isLimited) {
        return false;
      }
    }
    return true;
  }

  //获取相机权限
  static Future<bool> camera() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  //没有麦克风权限
  static Future<bool> microphone() async {
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  //授权定位
  static Future<bool> location() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkPhotoPermissions() async {
    bool photo = await PermissionsManager.photos();
    if (!photo) {
      await showPermissionDialog(title: "无法获取相册数据,请在手机应用权限管理中打开照片权限");

      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkCarmePermissions() async {
    bool camera = await PermissionsManager.camera();
    if (!camera) {
      await showPermissionDialog(title: "无法使用摄像头，请在手机应用权限管理中打开摄像头权限");

      return false;
    } else {
      bool camera = await PermissionsManager.microphone();
      if (!camera) {
        await showPermissionDialog(title: "无法使用麦克风，请在手机应用权限管理中打开麦克风权限");

        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> checkLocationPermissions() async {
    bool camera = await PermissionsManager.location();
    if (!camera) {
      await showPermissionDialog(title: "无法获取定位信息");

      return false;
    } else {
      return true;
    }
  }

  static showPermissionDialog({String title, String content}) async {
    if (PermissionsManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 PermissionsManager.globalKey = GlobalKey<NavigatorState>();');
    }
    BuildContext context = PermissionsManager.globalKey.currentContext;

    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(content ?? ''),
        actions: [
          TextButton(
            child: Text("取消"),
            onPressed: () {
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: Text("前往设置"),
            onPressed: () async {
              await openAppSettings();
              Navigator.maybePop(context);
            },
          )
        ],
      ),
    );
  }
}
