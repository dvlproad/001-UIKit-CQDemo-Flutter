import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_select_grid_cell.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/select/photo_album_select_notifier.dart';

class CQPhotoList extends StatefulWidget {
  final List<PhotoAlbumAssetEntity> photoAlbumAssets;
  final PhotoAlbumSelectNotifier photoAlbumSelectNotifier;
  final Widget prefixWidget;
  final Widget suffixWidget;

  CQPhotoList({
    Key key,
    @required this.photoAlbumAssets,
    @required this.photoAlbumSelectNotifier,
    this.prefixWidget,
    this.suffixWidget,
  })  : assert(photoAlbumSelectNotifier != null),
        super(key: key);

  @override
  _CQPhotoListState createState() => _CQPhotoListState();
}

class _CQPhotoListState extends State<CQPhotoList> {
  PhotoAlbumSelectNotifier _photoAlbumSelectNotifier;

  @override
  void initState() {
    super.initState();

    _photoAlbumSelectNotifier = widget.photoAlbumSelectNotifier;
  }

  @override
  Widget build(BuildContext context) {
    List<PhotoAlbumAssetEntity> _photoAlbumAssets = widget.photoAlbumAssets;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PhotoAlbumSelectNotifier>.value(
          value: _photoAlbumSelectNotifier,
        ),
      ],
      child: Consumer<PhotoAlbumSelectNotifier>(
        builder: (context, photoAlbumSelectNotifier, _) {
          int itemCount = _photoAlbumAssets.length;
          bool allowAddPrefixWidget = false;
          bool allowAddSuffixWidget = false;

          if (widget.prefixWidget != null) {
            allowAddPrefixWidget = true;
            itemCount++;
          }
          if (widget.suffixWidget != null) {
            allowAddPrefixWidget = true;
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
        },
      ),
    );
  }

  Widget _photoAlbumGridCell({
    @required PhotoAlbumAssetEntity photoAlbumAssets,
    @required int photoAlbumAssetIndex,
  }) {
    return CQPhotoAlbumSelectGridCell(
      entity: photoAlbumAssets,
      index: photoAlbumAssetIndex,
      isSelect: _photoAlbumSelectNotifier.isContain(photoAlbumAssetIndex),
      onPressed: () {
        PhotoAlbumSelectErrorCode errorCode =
            _photoAlbumSelectNotifier.addSelectIndex(photoAlbumAssetIndex);
        if (errorCode == PhotoAlbumSelectErrorCode.exceedLimit) {
          print('超过最大数');
        }
      },
    );
  }
}
