/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 21:53:27
 * @Description: 图片/视频等选择方法
 */

import 'dart:io' show File, Directory;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart'
    show PermissionsManager;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

// 自定义相机
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class PickTakePhotoUtil {
  static Future<AssetEntity?> takePhoto() async {
    bool allowCamera = await PermissionsManager.checkCarmePermissions();
    if (allowCamera != true) {
      return null;
    }

    XFile? previewFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (previewFile == null) {
      return null;
    }
    final String filePath = previewFile.path;
    AssetEntity? entity = await PhotoManager.editor.saveImageWithPath(
      filePath,
      title: path.basename(previewFile.path),
    );
    return entity;

    /*
    return CameraPicker.pickFromCamera(
      c,
      pickerConfig: CameraPickerConfig(
        enableRecording: true,
        foregroundBuilder: (BuildContext context, CameraValue cameraValue) {
          return Container(
            color: Colors.red,
            height: 400,
            child: Column(
              children: [
                Container(
                  color: Colors.green,
                  height: 300,
                ),
              ],
            ),
          );
        },
      ),
    );
    */
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
