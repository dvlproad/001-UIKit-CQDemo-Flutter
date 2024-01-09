import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit_adapt.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';

import 'package:permission_handler/permission_handler.dart';

class PermissionsManager {
  static GlobalKey<NavigatorState>? globalKey;
  static bool hintHasShown = false;
  //获取相册权限
  static Future<bool> photos() async {
    var permissionList = <Permission>[];
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) >= 33) {
        permissionList.add(Permission.photos);
        permissionList.add(Permission.videos);
      } else {
        permissionList.add(Permission.storage);
      }
    } else {
      permissionList.add(Permission.photos);
    }
    showPermissionHintDialog(
        content:
            "当您使用APP时，会在发布愿望单添加图片或视频、更换头像、私信(用户、店铺容服、平台客服等）、各海报保存、时访问您的相册权限",
        permissionList: permissionList);
    var status = await permissionList.request();
    _closePermissionHintDialog();
    for (var element in permissionList) {
      var isGranted = status[element]?.isGranted ?? false;
      var isLimited = status[element]?.isLimited ?? false;
      if (!isGranted && !isLimited) {
        return false;
      }
    }
    return true;
  }

  //获取相机权限
  static Future<bool> camera() async {
    showPermissionHintDialog(
        content:
            "当您使用APP时，会在发布愿望单添加图片或视频、更换头像、私信（用户、店铺客服、平台客服等）、等使用扫一扫、真人头像验证和人脸验证时访问您的相机权限。",
        permissionList: [Permission.camera]);
    var status = await Permission.camera.request();
    _closePermissionHintDialog();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> storage() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) < 33) {
        showPermissionHintDialog(
            content:
                "当您使用APP时，会在发布愿望单添加图片或视频、更换头像、私信(用户、店铺容服、平台客服等）、各海报保存、时访问您的相册权限",
            permissionList: [Permission.storage]);
        var status = await Permission.storage.request();
        _closePermissionHintDialog();
        return status.isGranted;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  //没有麦克风权限
  static Future<bool> microphone() async {
    showPermissionHintDialog(
        content: "当您使用APP时，会在下单添加语音礼物寄语时访问您的语音权限。",
        permissionList: [Permission.microphone]);
    var status = await Permission.microphone.request();
    _closePermissionHintDialog();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }

  // 访问音乐、音频
  static Future<bool> audio() async {
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt) < 33) {
        return true;
      }
      showPermissionHintDialog(
          content: "当您使用APP时，会在发布愿望单添加图片或视频时访问您的音频权限。",
          permissionList: [Permission.audio]);
      var status = await Permission.audio.request();
      _closePermissionHintDialog();
      if (status.isGranted) {
        return true;
      } else {
        return false;
      }
    } else {
      return true;
    }
  }

  /// 打开app设置
  static Future<void> openLocationAppSettings() async {
    await openAppSettings();
  }

  // 发起定位授权申请，如果没授权过或者设置为下次询问（允许一次）则会弹系统窗
  // 如果用户直接设置为拒绝/永不，则不会弹系统窗，需要自己弹一个框去跳转手机系统里面的权限设置
  static Future<bool> requestLocationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.locationWhenInUse,
    ].request();

    final serviceStatus = Permission.locationWhenInUse.serviceStatus;
    final isLocationServiceEnabled = await serviceStatus.isEnabled;
    if (statuses[Permission.locationWhenInUse] == PermissionStatus.granted &&
        isLocationServiceEnabled) {
      return true;
    }
    return false;
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

  static Future<bool> checkCarmePermissions(
      {bool shouldToastError = false}) async {
    bool camera = await PermissionsManager.camera();
    if (!camera) {
      await showPermissionDialog(title: "无法使用摄像头，请在手机应用权限管理中打开摄像头权限");
      if (shouldToastError) {
        ToastUtil.showMessage("抱歉！相机权限未开启！");
      }
      return false;
    } else {
      bool microphone = await PermissionsManager.microphone();
      if (!microphone) {
        await showPermissionDialog(title: "无法使用麦克风，请在手机应用权限管理中打开麦克风权限");

        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> checkOnlyCarmePermissions(
      {shouldShowDialog = true,
      bool shouldPop = true,
      bool shouldToastError = false}) async {
    bool camera = await PermissionsManager.camera();
    if (!camera) {
      if (shouldShowDialog) {
        await showPermissionDialog(
            title: "无法使用摄像头，请在手机应用权限管理中打开摄像头权限",
            shouldPop: shouldPop,
            cancel: () {
              if (shouldToastError) {
                ToastUtil.showMessage("抱歉！相机权限未开启！");
              }
            });
      }
      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkOnlyMicroPhonePermissions() async {
    bool microphone = await PermissionsManager.microphone();
    if (!microphone) {
      await showPermissionDialog(title: "无法使用麦克风，请在手机应用权限管理中打开麦克风权限");

      return false;
    } else {
      return true;
    }
  }

  static Future<bool> checkOnlyAudioPermissions() async {
    bool microphone = await PermissionsManager.audio();
    if (!microphone) {
      await showPermissionDialog(title: "无法访问设备上的音乐和音频，请在手机应用权限管理中打开相关权限");

      return false;
    } else {
      return true;
    }
  }

  static Future<bool> cameraDeniedShowDialog() async {
    var isDenied = await Permission.camera.isDenied;
    if (isDenied) {
      await showPermissionDialog(
          title: "无法使用摄像头，请在手机应用权限管理中打开摄像头权限",
          shouldPop: true,
          cancel: () {
            ToastUtil.showMessage("抱歉！相机权限未开启！");
          });
      return false;
    }
    return true;
  }

  /// 仅获取当前权限状态
  static Future<bool> getLocationIsAllow() async {
    return await Permission.locationWhenInUse.isGranted &&
        await Permission.locationWhenInUse.serviceStatus.isEnabled;
  }

  /// 用户是否拒绝
  static Future<bool> getLocationIsPermanentlyDenied() async {
    return await Permission.locationWhenInUse.isPermanentlyDenied;
  }

  /// 用户是否拒绝
  static Future<bool> getLocationIsDenied() async {
    return await Permission.locationWhenInUse.isDenied;
  }

  /// 检测定位权限，未授权会调起权限弹窗
  /// @ showDialog 定位权限被禁止时是否展示跳转App设置的弹窗
  static Future<bool> checkLocationPermission({bool showDialog = true}) async {
    bool allowLocation = await getLocationIsAllow();
    if (allowLocation) {
      return true;
    }
    showPermissionHintDialog(
        content: "当您使用APP时，会在内容推荐、愿望单定位、编辑资料和编辑收货信息时访问您的位置权限。");
    allowLocation = await requestLocationPermission();
    _closePermissionHintDialog();
    if (!allowLocation && showDialog) {
      await showPermissionDialog(
          title: "无法获取定位信息",
          content: "当您使用APP时，会在内容推荐、愿望单定位、编辑资料和编辑收货信息时访问您的位置权限。");
    }
    return allowLocation;
  }

  static Future showPermissionHintDialog(
      {List<Permission>? permissionList, String? content}) async {
    if (Platform.isIOS) {
      return null;
    }
    for (Permission element in permissionList ?? []) {
      bool isGranted = await element.isGranted;
      if (isGranted) {
        return null;
      }
    }

    if (PermissionsManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 PermissionsManager.globalKey = GlobalKey<NavigatorState>();');
    }
    BuildContext? context = _getBuildContext();
    if (context == null) {
      return null;
    }
    hintHasShown = true;
    // ignore: use_build_context_synchronously
    showDialog(
      context: context,
      builder: (context) => Container(
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            margin: EdgeInsets.all(30.w_pt_cj),
            padding: EdgeInsets.all(20.w_pt_cj),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(10.w_pt_cj),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "权限使用说明",
                  style: BoldTextStyle(
                    color: const Color(0xFF404040),
                    fontSize: 16.w_pt_cj,
                  ),
                ),
                SizedBox(
                  height: 10.h_pt_cj,
                ),
                Text(
                  content ?? '',
                  style: TextStyle(
                    color: const Color(0xFF8B8B8B),
                    fontSize: 13.w_pt_cj,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
    return context;
  }

  static showPermissionDialog(
      {String? title,
      String? content,
      bool shouldPop = true,
      void Function()? cancel}) async {
    if (PermissionsManager.globalKey == null) {
      throw Exception(
          'Error:请先在main.dart中设置 PermissionsManager.globalKey = GlobalKey<NavigatorState>();');
    }
    BuildContext? context = _getBuildContext();
    if (context == null) {
      return;
    }
    await showDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title ?? ''),
        content: Text(content ?? ''),
        actions: [
          TextButton(
            child: const Text("取消"),
            onPressed: () {
              if (cancel != null) {
                cancel();
              }
              Navigator.pop(context, false);
            },
          ),
          TextButton(
            child: const Text("前往设置"),
            onPressed: () async {
              await openAppSettings();
              if (shouldPop) {
                // ignore: use_build_context_synchronously
                Navigator.maybePop(context);
              }
            },
          )
        ],
      ),
    );
  }

  static BuildContext? _getBuildContext() {
    return PermissionsManager.globalKey?.currentContext;
  }

  static _closePermissionHintDialog() {
    if (_getBuildContext() != null && hintHasShown) {
      hintHasShown = false;
      Navigator.pop(_getBuildContext()!);
    }
  }
}
