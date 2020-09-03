import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  //获取相机权限
  static Future<bool> photos(BuildContext context) async {
    var status = await [Permission.storage, Permission.photos].request();

    if (status[Permission.storage].isGranted &&
        status[Permission.photos].isGranted) {
      return true;
    } else {
      return false;
    }
  }

  //获取相机权限
  static Future<bool> camera(BuildContext context) async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  //没有麦克风权限
  static Future<bool> microphone(BuildContext context) async {
    var status = await Permission.microphone.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  //授权定位
  static Future<bool> location(BuildContext context) async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkPhotoPermissions(BuildContext context) async {
    bool camera = await PermissionsManager.photos(context);
    if (!camera) {
      await PermissionsManager.showPermissionDialog(
          context, "无法获取相册数据,请在手机应用权限管理中打开1440的照片权限", "");

      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkCarmePermissions(BuildContext context) async {
    bool camera = await PermissionsManager.camera(context);
    if (!camera) {
      await PermissionsManager.showPermissionDialog(
          context, "无法使用摄像头，请在手机应用权限管理中打开1440的摄像头权限", "");

      return false;
    } else {
      bool camera = await PermissionsManager.microphone(context);
      if (!camera) {
        await PermissionsManager.showPermissionDialog(
            context, "无法使用麦克风，请在手机应用权限管理中打开1440的麦克风权限", "");

        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> checkLocationPermissions(BuildContext context) async {
    bool camera = await PermissionsManager.location(context);
    if (!camera) {
      await PermissionsManager.showPermissionDialog(context, "无法获取定位信息", "");

      return false;
    } else {
      return true;
    }
  }

  static showPermissionDialog(
      BuildContext context, String title, String content) async {
    await showDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: [
                FlatButton(
                  child: Text("取消"),
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                ),
                FlatButton(
                    child: Text("前往设置"),
                    onPressed: () async {
                      await openAppSettings();
                      Navigator.maybePop(context);
                    })
              ],
            ));
  }
}
