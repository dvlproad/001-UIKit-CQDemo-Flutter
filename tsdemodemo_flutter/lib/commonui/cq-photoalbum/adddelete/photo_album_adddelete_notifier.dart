import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

class PhotoAlbumAddDeleteNotifier with ChangeNotifier {
  List<PhotoAlbumAssetEntity> _assets = List();

  List<PhotoAlbumAssetEntity> get assets => _assets;

  void addAsset(PhotoAlbumAssetEntity assetEntity) {
    this._assets.add(assetEntity);
    notifyListeners();
  }

  void removeAsset(PhotoAlbumAssetEntity assetEntity) {
    this._assets.remove(assetEntity);
    notifyListeners();
  }
}
