import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/base/photo_album_asset_entity.dart';

enum PhotoAlbumAssetState { loading, success, failure, empty }

class PhotoAlbumNotifier with ChangeNotifier {
  List<CQPhotoAlbumAssetEntity> _assets = List();
  int page = 0;
  int _pageSize = 20;

  List<CQPhotoAlbumAssetEntity> get assets => _assets;

  PhotoAlbumAssetState state = PhotoAlbumAssetState.loading;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> resetList(List<AssetEntity> assets) async {
    _assets.clear();
    // _assets.addAll(assets);
    for (final asset in assets) {
      final thumb = await asset.thumbData;
      _assets.add(
        CQPhotoAlbumAssetEntity(asset, thumb),
      );
    }
  }

  Future<void> moreList(List<AssetEntity> assets) async {
    // _assets.addAll(assets);
    for (final asset in assets) {
      final thumb = await asset.thumbData;
      _assets.add(
        CQPhotoAlbumAssetEntity(asset, thumb),
      );
    }
  }

  Future loadAssets() async {
    List<AssetPathEntity> assetPath = [];
    try {
      assetPath = await PhotoManager.getAssetPathList(onlyAll: true)
          .timeout(Duration(seconds: 5));
    } catch (e) {
      throw Future.error("${e.toString()}");
    }

    if (assetPath.isEmpty) {
      state = PhotoAlbumAssetState.empty;
      return Future.value(state);
    } else {
      final allAssetsPath = assetPath.firstWhere((list) => list.isAll);
      final assetList = await allAssetsPath.getAssetListPaged(page, _pageSize);

      if (Platform.isIOS) {
        assetList.first.file
            .then((value) => value.parent.delete(recursive: true));
      }
      if (assetList.length == 0) {
        return;
      }

      if (page == 0) {
        await resetList(assetList);
      } else {
        await moreList(assetList);
      }
      page++;
    }

    notifyListeners();

    state = PhotoAlbumAssetState.success;
    return Future.value(state);
  }
}
