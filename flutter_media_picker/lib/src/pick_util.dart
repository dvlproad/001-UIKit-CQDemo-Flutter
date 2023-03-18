/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 22:03:39
 * @Description: 图片/视频等选择方法
 */

import 'dart:io' show File, Directory;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart'
    show PermissionsManager;
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

import './pick_util/pick_asset_util.dart';
import './pick_util/pick_media_util.dart';

class PickUtil {
  static void chooseOneMedia(
    BuildContext context, {
    PickPhotoAllowType pickAllowType = PickPhotoAllowType.imageOnly,
    required void Function(ImageChooseBean mediaChooseBean) completeBlock,
  }) {
    PickUtil.pickPhoto(
      context,
      maxCount: 1,
      imageChooseModels: [],
      pickAllowType: pickAllowType,
      imagePickerCallBack: ({
        List<ImageChooseBean>? newAddedImageChooseModels,
        List<ImageChooseBean>? newCancelImageChooseModels,
      }) async {
        // 新添加的图片
        if (newAddedImageChooseModels == null ||
            newAddedImageChooseModels.isEmpty) {
          return;
        }

        completeBlock(newAddedImageChooseModels.first);
      },
    );
  }

  static void pickPhoto(
    BuildContext context, {
    int maxCount = 9,
    required List<ImageChooseBean> imageChooseModels,
    // bool showCamera = false,
    PickPhotoAllowType pickAllowType = PickPhotoAllowType.imageOnly,
    required void Function({
      List<ImageChooseBean>? newAddedImageChooseModels,
      List<ImageChooseBean>? newCancelImageChooseModels,
    })
        imagePickerCallBack,
  }) async {
    // 图片
    print('PickUtil 01:${DateTime.now().toString()}');

    /*
    PickMediaUtil.pickPhoto(
      context,
      selectCount: imageChooseModels?.length ?? 0,
      imagePickerCallBack: (bAddedImageChooseModels) {
        if (imagePickerCallBack != null) {
          imagePickerCallBack(
            newAddedImageChooseModels: bAddedImageChooseModels,
            newCancelImageChooseModels: null,
          );
        }
      },
    );
    */

    bool allowPhotos = await PermissionsManager.checkPhotoPermissions();
    if (allowPhotos != true) {
      return;
    }
    PickAssetEntityUtil.pickPhoto(
      context,
      maxCount: maxCount,
      pickAllowType: pickAllowType,
      selectImageChooseModels: imageChooseModels,
      imagePickerCallBack: (
          {newAddedImageChooseModels, newCancelImageChooseModels}) {
        if (imagePickerCallBack != null) {
          imagePickerCallBack(
            newAddedImageChooseModels: newAddedImageChooseModels,
            newCancelImageChooseModels: newCancelImageChooseModels,
          );
        }
      },
    );
  }
  /*
    List<ImageChooseBean> imageChooseModels = [];
    for (AssetEntity assetEntity in assetEntitys) {
      File file = await assetEntity.file;
      // 压缩图片
      String targetPath = await ImageCompressUtil.getFileTargetPath(file);
      file = await ImageCompressUtil.testCompressAndGetFile(file, targetPath);
      // 获取最终的图片路径
      String localPath = file.path;

      ImageChooseBean imageChooseModel = ImageChooseBean(localPath: localPath);
      // imageChooseModel.assetEntity = assetEntity;

      imageChooseModels.add(imageChooseModel);
    }

    print('PickUtil 02:${DateTime.now().toString()}');
    LoadingUtil.dismiss();

    imagePickerCallBack(imageChooseModels);
    */
}
