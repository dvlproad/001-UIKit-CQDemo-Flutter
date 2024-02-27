import 'dart:io';

import 'package:photo_manager/photo_manager.dart';

class AssetEntitySizeUtil {
  static int getRealWidthForAssetEntity(AssetEntity assetEntity) {
    int width = assetEntity.width;

    bool isLandscape =
        assetEntity.orientation == 90 || assetEntity.orientation == 270;
    if (Platform.isAndroid && !isLandscape) {
      // 注意:安卓宽高有时候会相反，有些机子又是正确的，所以使用不传的方案，让后台去腾讯云判断
      // width = assetEntity.height;
    }

    return width;
  }

  static int getRealHeightForAssetEntity(AssetEntity assetEntity) {
    int height = assetEntity.height;

    bool isLandscape =
        assetEntity.orientation == 90 || assetEntity.orientation == 270;
    if (Platform.isAndroid && !isLandscape) {
      // 注意:安卓宽高有时候会相反，有些机子又是正确的，所以使用不传的方案，让后台去腾讯云判断
      // height = assetEntity.width;
    }

    return height;
  }
}
