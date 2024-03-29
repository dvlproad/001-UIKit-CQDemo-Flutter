/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 22:14:09
 * @Description: 图片/视频等选择方法
 */

import 'dart:io' show File, Directory;
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:flutter_permission_manager/flutter_permission_manager.dart';

import 'package:flutter_effect_kit/flutter_effect_kit.dart';
// import 'package:image_pickers/image_pickers.dart';

import 'package:flutter_image_process/flutter_image_process.dart';
// import '../bean/image_compress_bean.dart';

class PickMediaUtil {
  /*
  static void pickPhoto(
    BuildContext context, {
    @required int selectCount,
    bool showCamera,
    @required
        void Function(List<ImageChooseBean> bAddedImageChooseModels)
            imagePickerCallBack,
  }) async {
    // 图片
    print('PickUtil 01:${DateTime.now().toString()}');

    bool allowPhotos = await PermissionsManager.checkPhotoPermissions();
    if (allowPhotos != true) {
      return;
    }
    LoadingUtil.show(); // 压缩耗时
    List<Media> medias = await ImagePickers.pickerPaths(
      galleryMode: GalleryMode.image,
      selectCount: selectCount,
      showGif: false,
      showCamera: showCamera ?? true,
      compressSize: 500,
      uiConfig: UIConfig(uiThemeColor: Color(0xFFffffff)),
      cropConfig: CropConfig(enableCrop: true, width: 1, height: 1),
    );

    List<ImageChooseBean> imageChooseModels = [];
    for (Media media in medias) {
      ImageChooseBean imageChooseModel = ImageChooseBean();
      imageChooseModel.assetEntityPath = media.path;

      imageChooseModel.checkAndBeginCompressAppLocalPath();

      imageChooseModels.add(imageChooseModel);
    }

    print('PickUtil 02:${DateTime.now().toString()}');
    LoadingUtil.dismiss();

    imagePickerCallBack(imageChooseModels);
  }
  */
}
