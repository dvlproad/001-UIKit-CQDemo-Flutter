/*
 * @Author: dvlproad
 * @Date: 2024-04-28 13:43:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-21 12:27:29
 * @Description: 头像认证-弹出摄像头的方法
 */
import 'package:flutter/material.dart';
import 'package:flutter_optimize_interacte/flutter_optimize_interacte.dart';

import 'auth_avatar_camera_widget.dart';
import 'auth_avatar_step_widget.dart';

import '../flutter_base_features_adapt.dart';

class AuthAvatarCameraUtil {
  // static goChooseWaitAuthAvatar() {

  // }

  /// 弹出 头像认证的摄像头页面，并回调获得摄像头图片的回调
  static showAvatarCamera({
    required BuildContext context,
    bool useSafeArea = false,
    required String successResultTitle,
    // 对【拍照所得的】图片开始进行人脸识别（开始识别，和识别结果可能分开为两个接口)
    required void Function(String anyImagePath) startAuthTakePhotoHandle,
  }) {
    __showVerifyAvatarCamera(
      context: context,
      useSafeArea: useSafeArea,
      onTapClose: (BuildContext cameraContext) {
        Navigator.pop(cameraContext);
      },
      takePhotoCompleteBlock: (
        cameraContext, {
        required String avatarLocalPath,
      }) async {
        // 弹出 头像认证-3认证状态页：认证中
        _showVerifyStepWidget(
          context,
          status: VerityResult.loading,
          successTitle: successResultTitle,
          onTapReAuth: () {
            showAvatarCamera(
              context: context,
              successResultTitle: successResultTitle,
              startAuthTakePhotoHandle: startAuthTakePhotoHandle,
            );
          },
        );

        /// 对【拍照所得的】图片开始进行人脸识别（开始识别，和识别结果可能分开为两个接口)
        startAuthTakePhotoHandle(avatarLocalPath);
      },
    );
  }

  /// 弹出 头像认证-2摄像头头像拍摄页
  static __showVerifyAvatarCamera({
    required BuildContext context,
    // bool isDismissible = true,
    bool useSafeArea = false,
    required void Function(BuildContext cameraContext) onTapClose,
    required void Function(BuildContext cameraContext,
            {required String avatarLocalPath})
        takePhotoCompleteBlock,
  }) {
    showModalBottomSheet(
      context: context,
      useSafeArea: useSafeArea,
      // isDismissible: isDismissible,
      // enableDrag: enableDrag,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w_pt_cj),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setModalState) {
          return AuthAvatarCameraWidget(
            onTapClose: throttle(() async {
              onTapClose(context);
            }),
            takePhotoCompleteBlock: ({required String avatarLocalPath}) {
              throttle(() async {
                takePhotoCompleteBlock(
                  context,
                  avatarLocalPath: avatarLocalPath,
                );
              });
            },
          );
        },
      ),
    );
  }

  // 弹出 头像认证-3认证状态页(认证中、认证成功、认证失败)
  static _showVerifyStepWidget(
    BuildContext context, {
    required VerityResult status,
    // 成功时候，按钮显示的文案(用于提醒用户接下去的是什么操作，PS:只有success和failure才有按钮)
    required String successTitle,
    String? tips,
    required void Function() onTapReAuth,
  }) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: true,
      enableDrag: status == VerityResult.success ? true : false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.w_pt_cj),
      ),
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, setModalState) {
          return WillPopScope(
            onWillPop: () async =>
                status == VerityResult.success ? true : false,
            child: AuthAvatarStepWidget(
              status: status,
              tips: tips,
              successTitle: successTitle,
              onTapClose: throttle(() async {
                Navigator.pop(context);
              }),
              onTapReAuth: throttle(() async {
                Navigator.pop(context);
                onTapReAuth();
              }),
              onTapSuccess: throttle(() async {
                Navigator.pop(context);
              }),
            ),
          );
        },
      ),
    );
  }
}
