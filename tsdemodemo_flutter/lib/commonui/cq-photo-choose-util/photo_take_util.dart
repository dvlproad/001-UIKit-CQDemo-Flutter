import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

typedef CQImagePickerCallBack = void Function(String path);
typedef CQPickerImagesCallBack = void Function(
    List<AssetEntity> assetEntitys, List<Uint8List> assetThumbDatas);
typedef CQTakePhotoCallBack = void Function(String imagePath);

class CQTakePhtoUtil {
  // Routes.navigateTo(
  //             context,
  //             Routes.commonTakePhotoPage,
  //             params: {},
  //           ).then((value) {
  //             // 接收下一个页面返回回来的数据
  //             String path = value as String;
  //             print('媒体路径为' + path);

  //             ImageProvider image = AssetImage(path);
  //             String message = "00:49";

  //             _photoAlbumAssets.add(cellBean);
  //             setState(() {});
  //           });

  static Future<void> takePhoto({
    ImagePicker imagePicker,
    @required CQImagePickerCallBack imagePickerCallBack,
  }) async {
    if (imagePicker == null) {
      imagePicker = ImagePicker();
    }
    final PickedFile pickedFile = await imagePicker.getImage(
      source: ImageSource.camera,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    print("获取到的图片地址: pickedFile.path = ${pickedFile.path}");

    if (pickedFile != null && imagePickerCallBack != null) {
      imagePickerCallBack(pickedFile.path); //获取到图片地址
    }
  }
}
