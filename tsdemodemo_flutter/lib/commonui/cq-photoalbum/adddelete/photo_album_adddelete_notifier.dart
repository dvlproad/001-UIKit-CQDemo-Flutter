import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

class PhotoAlbumAddDeleteNotifier with ChangeNotifier {
  List<CQPhotoAlbumAssetEntity> _assets = List();

  List<CQPhotoAlbumAssetEntity> get assets => _assets;

  void addAsset(CQPhotoAlbumAssetEntity assetEntity) {
    this._assets.add(assetEntity);
    notifyListeners();
  }

  void removeAsset(CQPhotoAlbumAssetEntity assetEntity) {
    this._assets.remove(assetEntity);
    notifyListeners();
  }
}
