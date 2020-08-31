import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_base_grid_cell.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_select_notifier.dart';

class CQPhotoAlbumSelectGridCell extends StatelessWidget {
  final PhotoAlbumAssetEntity entity;
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
          onPressed: this.onPressed,
        ),
        if (_selectNotifier.isContain(index) == true)
          Positioned(
            right: 5,
            bottom: 5,
            // child: Icon(C1440Icon.icon_correct,
            //     size: 20, color: Color(0xFF1FFD92)),
            child: Image(
              image: AssetImage('lib/Resources/report/arrow_right.png'),
              width: 8,
              height: 12,
            ),
          ),
      ],
    );
  }
}
