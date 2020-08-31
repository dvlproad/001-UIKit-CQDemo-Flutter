import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/photo_album_delete_grid_cell.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

class CQImagesChooseList extends StatefulWidget {
  final List<PhotoAlbumAssetEntity> photoAlbumAssets;
  final int maxAddCount;
  final Widget prefixWidget;
  final Widget suffixWidget;

  CQImagesChooseList({
    Key key,
    @required this.photoAlbumAssets,
    this.maxAddCount = 100000,
    this.prefixWidget,
    this.suffixWidget,
  }) : super(key: key);

  @override
  _CQImagesChooseListState createState() => _CQImagesChooseListState();
}

class _CQImagesChooseListState extends State<CQImagesChooseList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int maxShowCount = widget.maxAddCount;
    bool allowAddPrefixWidget = false;
    bool allowAddSuffixWidget = false;

    List<PhotoAlbumAssetEntity> _photoAlbumAssets = widget.photoAlbumAssets;
    if (_photoAlbumAssets.length > maxShowCount) {
      _photoAlbumAssets = _photoAlbumAssets.sublist(0, widget.maxAddCount);
    }

    int itemCount = _photoAlbumAssets.length;
    if (widget.prefixWidget != null && itemCount < maxShowCount) {
      allowAddPrefixWidget = true;
      itemCount++;
    }
    if (widget.suffixWidget != null && itemCount < maxShowCount) {
      allowAddSuffixWidget = true;
      itemCount++;
    }

    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        padding: EdgeInsets.only(bottom: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
        ),
        itemBuilder: (context, index) {
          if (allowAddPrefixWidget == true && index == 0) {
            return widget.prefixWidget;
          }
          if (allowAddSuffixWidget == true && index == itemCount - 1) {
            return widget.suffixWidget;
          }

          int photoAlbumAssetIndex = index;
          if (allowAddPrefixWidget == true) {
            photoAlbumAssetIndex = index - 1;
          }
          return _photoAlbumGridCell(
            photoAlbumAssets: _photoAlbumAssets[photoAlbumAssetIndex],
            photoAlbumAssetIndex: photoAlbumAssetIndex,
          );
        },
      ),
    );
  }

  Widget _photoAlbumGridCell({
    @required PhotoAlbumAssetEntity photoAlbumAssets,
    @required int photoAlbumAssetIndex,
  }) {
    return CQPhotoAlbumDeleteGridCell(
      entity: photoAlbumAssets,
      index: photoAlbumAssetIndex,
      isSelect: false,
      onPressed: () {
        print('点击$photoAlbumAssetIndex');
      },
    );
  }
}
