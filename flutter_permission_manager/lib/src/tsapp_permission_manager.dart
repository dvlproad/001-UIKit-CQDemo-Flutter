// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2024-03-15 09:58:33
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-19 17:48:26
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_permission_manager/flutter_permission_manager.dart';

class PermissionsManager extends BasePermissionsManager {
  PermissionsManager._() {
    String publishFeatureText = "发布XXX添加图片或视频";
    String photoPermissionText =
        "当您使用APP时，会在$publishFeatureText、更换头像、私信(用户、店铺容服、平台客服等）、各海报保存、时访问您的相册权限";

    String cameraPermissionText =
        "当您使用APP时，会在$publishFeatureText、更换头像、私信（用户、店铺客服、平台客服等）、等使用扫一扫、真人头像验证和人脸验证时访问您的相机权限。";

    String storagePermissionText =
        "当您使用APP时，会在$publishFeatureText、更换头像、私信(用户、店铺容服、平台客服等）、各海报保存、时访问您的相册权限";

    String microphonePermissionText = "当您使用APP时，会在下单添加语音礼物寄语时访问您的语音权限。";

    String audioPermissionText = "当您使用APP时，会在$publishFeatureText时访问您的音频权限。";

    String locationPermissionText =
        "当您使用APP时，会在内容推荐、愿望单定位、编辑资料和编辑收货信息时访问您的位置权限。";
    setupPermissionText(
      photo: photoPermissionText,
      camera: cameraPermissionText,
      storage: storagePermissionText,
      microphone: microphonePermissionText,
      audio: audioPermissionText,
      location: locationPermissionText,
    );
  }
  static final PermissionsManager _instance = PermissionsManager._();
  factory PermissionsManager() => _instance;

  static initGlobalKey(GlobalKey<NavigatorState>? globalKey) {
    BasePermissionsManager.globalKey = globalKey;
  }

  /// 重写
  @override
  showMessage(String message) {
    debugPrint("这是权限库输出的内容:$message");
  }

  static Future<bool> photos_app() async {
    return PermissionsManager().photos();
  }

  //获取相机权限
  static Future<bool> camera_app() async {
    return PermissionsManager().camera();
  }

  static Future<bool> storage_app() async {
    return PermissionsManager().storage();
  }

  //没有麦克风权限
  static Future<bool> microphone_app() async {
    return PermissionsManager().microphone();
  }

  // 访问音乐、音频
  static Future<bool> audio_app() async {
    return PermissionsManager().audio();
  }

  /// 打开app设置
  static Future<void> openLocationAppSettings_app() async {
    return PermissionsManager().openLocationAppSettings();
  }

  // 发起定位授权申请，如果没授权过或者设置为下次询问（允许一次）则会弹系统窗
  // 如果用户直接设置为拒绝/永不，则不会弹系统窗，需要自己弹一个框去跳转手机系统里面的权限设置
  static Future<bool> requestLocationPermission_app() async {
    return PermissionsManager().requestLocationPermission();
  }

  static Future<bool> checkPhotoPermissions_app() async {
    return PermissionsManager().checkPhotoPermissions();
  }

  static Future<bool> checkCarmePermissions_app(
      {bool shouldToastError = false}) async {
    return PermissionsManager()
        .checkCarmePermissions(shouldToastError: shouldToastError);
  }

  static Future<bool> checkOnlyCarmePermissions_app(
      {shouldShowDialog = true,
      bool shouldPop = true,
      bool shouldToastError = false}) async {
    return PermissionsManager().checkOnlyCarmePermissions(
      shouldShowDialog: shouldShowDialog,
      shouldPop: shouldPop,
      shouldToastError: shouldToastError,
    );
  }

  static Future<bool> checkOnlyMicroPhonePermissions_app() async {
    return PermissionsManager().checkOnlyMicroPhonePermissions();
  }

  static Future<bool> checkOnlyAudioPermissions_app() async {
    return PermissionsManager().checkOnlyAudioPermissions();
  }

  static Future<bool> cameraDeniedShowDialog_app() async {
    return PermissionsManager().cameraDeniedShowDialog();
  }

  /// 仅获取当前权限状态
  static Future<bool> getLocationIsAllow_app() async {
    return PermissionsManager().getLocationIsAllow();
  }

  /// 用户是否拒绝
  static Future<bool> getLocationIsPermanentlyDenied_app() async {
    return PermissionsManager().getLocationIsPermanentlyDenied();
  }

  /// 用户是否拒绝
  static Future<bool> getLocationIsDenied_app() async {
    return PermissionsManager().getLocationIsDenied();
  }

  /// 检测定位权限，未授权会调起权限弹窗
  /// @ showDialog 定位权限被禁止时是否展示跳转App设置的弹窗
  static Future<bool> checkLocationPermission_app(
      {bool showDialog = true}) async {
    return PermissionsManager().checkLocationPermission(showDialog: showDialog);
  }
}
