import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../base/photo_album_asset_entity.dart';
import '../base/photo_album_base_grid_cell.dart';
import './photo_album_select_notifier.dart';

class CQPhotoAlbumSelectGridCell extends StatelessWidget {
  final CQPhotoAlbumAssetEntity entity;
  final int index;
  final bool isSelect;
  final VoidCallback onPressed;

  const CQPhotoAlbumSelectGridCell({
    Key key,
    this.entity,
    this.index,
    this.isSelect = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _selectNotifier = Provider.of<PhotoAlbumSelectNotifier>(context);

    return Stack(
      children: [
        CQPhotoAlbumBaseGridCell(
          entity: entity,
          index: index,
          onPressed: onPressed,
        ),
        if (_selectNotifier.isContain(index) == true)
          const Positioned(
            right: 5,
            bottom: 5,
            child: Icon(
              Icons.check_circle,
              size: 20,
              color: Color(0xFF1FFD92),
            ),
          ),
      ],
    );
  }
}
