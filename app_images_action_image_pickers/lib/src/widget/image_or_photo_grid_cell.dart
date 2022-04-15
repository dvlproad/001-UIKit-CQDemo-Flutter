/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 16:09:49
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart'
    show CQImageBaseGridCell;
import 'package:image_pickers/image_pickers.dart';

import '../bean/image_choose_bean.dart';

class CQImageOrPhotoGridCell extends StatelessWidget {
  final ImageChooseBean imageChooseModel;

  final int index;
  final VoidCallback onPressed;

  CQImageOrPhotoGridCell({
    Key key,
    @required this.imageChooseModel, // 类型可为 AssetEntity 或 String
    @required this.index,
    @required this.onPressed,
  }) : super(key: key);

  ImageProvider<Object> _pathImageProvider(ImageChooseBean imageChooseModel) {
    String imagePath =
        imageChooseModel.localPath ?? imageChooseModel.networkUrl ?? '';

    ImageProvider imageProvider;
    if (imagePath.startsWith(RegExp(r'https?:'))) {
      // Image image = Image.network(photoAlbumPath);
      imageProvider = NetworkImage(imagePath);
    } else {
      Image image = Image.file(File(imagePath));
      imageProvider = image.image;
      // imageProvider = AssetImage(photoAlbumPath);
    }

    return imageProvider;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = _pathImageProvider(imageChooseModel);
    String message = '';

    return CQImageBaseGridCell(
      imageProvider: imageProvider,
      message: message,
      index: this.index,
      onPressed: this.onPressed,
    );

    // if (imageChooseModel is Media) {
    //   Media media = imageChooseModel;

    //   Image image = Image.file(
    //     File(media.thumbPath),
    //     width: 90,
    //     height: 90,
    //     fit: BoxFit.cover,
    //   );
    //   ImageProvider imageProvider = image.image;

    //   return GestureDetector(
    //     onTap: onPressed,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(8),
    //       child: image,
    //     ),
    //   );
    // }
  }
}
