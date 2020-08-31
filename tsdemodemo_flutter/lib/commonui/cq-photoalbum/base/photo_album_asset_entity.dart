import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

class PhotoAlbumAssetEntity {
  final AssetEntity asset;
  final Uint8List bytes;

  PhotoAlbumAssetEntity(this.asset, this.bytes);
}
