import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart'
    show CQImageBaseGridCell;
import 'package:image_pickers/image_pickers.dart';

class CQImageOrPhotoGridCell extends StatelessWidget {
  final dynamic imageOrPhotoModel;

  final int index;
  final VoidCallback onPressed;

  CQImageOrPhotoGridCell({
    Key key,
    @required this.imageOrPhotoModel, // 类型可为 AssetEntity 或 String
    @required this.index,
    @required this.onPressed,
  }) : super(key: key);

  ImageProvider<Object> _pathImageProvider(dynamic photoAlbumPath) {
    ImageProvider imageProvider;
    if (photoAlbumPath.startsWith(RegExp(r'https?:'))) {
      // Image image = Image.network(photoAlbumPath);
      imageProvider = NetworkImage(photoAlbumPath);
    } else {
      Image image = Image.file(File(photoAlbumPath));
      imageProvider = image.image;
      // imageProvider = AssetImage(photoAlbumPath);
    }

    return imageProvider;
  }

  @override
  Widget build(BuildContext context) {
    if (imageOrPhotoModel is Media) {
      Media media = imageOrPhotoModel;

      Image image = Image.file(
        File(media.thumbPath),
        width: 90,
        height: 90,
        fit: BoxFit.cover,
      );
      ImageProvider imageProvider = image.image;

      return GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: image,
        ),
      );
    } else if (imageOrPhotoModel is String) {
      String photoAlbumPath = imageOrPhotoModel;
      ImageProvider imageProvider = _pathImageProvider(imageOrPhotoModel);
      String message = '';

      return CQImageBaseGridCell(
        imageProvider: imageProvider,
        message: message,
        index: this.index,
        onPressed: this.onPressed,
      );
    } else {
      return Container(
        color: Colors.red,
        child: Text('请传入正确的 image 数据类型: AssetEntity or String'),
      );
    }
  }
}
