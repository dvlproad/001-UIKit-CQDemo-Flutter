/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 16:27:26
 * @Description: 图片/视频等选择方法
 */

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:image_pickers/image_pickers.dart';
import './bean/image_choose_bean.dart';

class PickUtil {
  static pickPhoto({
    @required int selectCount,
    bool showCamera,
    @required
        void Function(List<ImageChooseBean> bAddedImageChooseModels)
            imagePickerCallBack,
  }) async {
    // 图片
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
      ImageChooseBean imageChooseModel = ImageChooseBean(localPath: media.path);
      imageChooseModels.add(imageChooseModel);
    }

    imagePickerCallBack(imageChooseModels);
  }
}
