import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

class CQPhotoAlbumBaseGridCell extends StatelessWidget {
  final PhotoAlbumAssetEntity entity;
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
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(),
            image: DecorationImage(
              image: MemoryImage(entity.bytes),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              if (entity.asset.type == AssetType.video)
                Positioned(
                  right: 5,
                  top: 5,
                  child: _getVideoDuration(entity.asset.duration),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getVideoDuration(int duration) {
    final minutes = (duration / 60).floor();
    final seconds = duration % 60;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        textAlign: TextAlign.end,
        style: TextStyle(
          fontSize: 10.0,
        ),
      ),
    );
  }
}
