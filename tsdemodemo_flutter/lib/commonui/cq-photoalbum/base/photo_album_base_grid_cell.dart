import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/image_grid_cell.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

class CQPhotoAlbumBaseGridCell extends StatelessWidget {
  final CQPhotoAlbumAssetEntity entity;

  final int index;
  final VoidCallback onPressed;

  const CQPhotoAlbumBaseGridCell({
    Key key,
    @required this.entity,
    @required this.index,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider = MemoryImage(entity.bytes);
    String message;
    if (entity.asset.type == AssetType.video) {
      int duration = entity.asset.duration;
      final minutes = (duration / 60).floor();
      final seconds = duration % 60;
      message =
          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return CQImageBaseGridCell(
      imageProvider: imageProvider,
      index: index,
      message: message,
    );
  }
}
