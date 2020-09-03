import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_grid_cell.dart';

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

  @override
  Widget build(BuildContext context) {
    if (imageOrPhotoModel is AssetEntity) {
      AssetEntity assetEntity = imageOrPhotoModel;

      return FutureBuilder<Uint8List>(
        future: assetEntity.thumbData,
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            // photoAlbumAssetFile = await photoAlbumAsset.file;

            Uint8List thumbData = snapshot.data;
            ImageProvider imageProvider = MemoryImage(thumbData);

            String message;
            if (assetEntity.type == AssetType.video) {
              int duration = assetEntity.duration;
              final minutes = (duration / 60).floor();
              final seconds = duration % 60;
              message =
                  '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
            }

            return CQImageBaseGridCell(
              imageProvider: imageProvider,
              message: message,
              index: this.index,
              onPressed: this.onPressed,
            );
          } else {
            return Container();
          }
        },
      );
    } else if (imageOrPhotoModel is String) {
      String photoAlbumPath = imageOrPhotoModel;
      ImageProvider imageProvider;
      if (photoAlbumPath.startsWith(RegExp(r'https?:'))) {
        // Image image = Image.network(photoAlbumPath);
        imageProvider = NetworkImage(photoAlbumPath);
      } else {
        // Image image = Image.file(File(photoAlbumPath);
        imageProvider = AssetImage(photoAlbumPath);
      }
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
