import 'dart:typed_data';
import 'package:photo_manager/photo_manager.dart';

class CQPhotoAlbumAssetEntity {
  final AssetEntity asset;
  final Uint8List bytes;

  CQPhotoAlbumAssetEntity(this.asset, this.bytes);
}
