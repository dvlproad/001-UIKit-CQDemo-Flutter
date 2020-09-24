import 'dart:typed_data';
import './photolist/photo_list.dart';
import 'package:photo/photo.dart';

import 'package:photo/src/provider/i18n_provider.dart';
// export 'package:photo/src/provider/i18n_provider.dart'
//     show I18NCustomProvider, I18nProvider, CNProvider, ENProvider;

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

typedef CQPickerImagesCallBack = void Function(
    List<AssetEntity> assetEntitys, List<Uint8List> assetThumbDatas);
typedef CQTakePhotoCallBack = void Function(String imagePath);

class CQAssetEntityPickerUtil {
  /// 选择相册 或 拍照
  static Future<List<AssetEntity>> pickAssetEntitys({
    @required PickType pickType,
    @required List<AssetPathEntity> pathList,
    @required BuildContext context,
    int hasSelectedCount = 0,
    @required CQTakePhotoCallBack takePhotoCallBack,
  }) async {
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    assert(context != null);

    PhotoPicker.clearThumbMemoryCache();

    // assert(provider != null, "provider must be not null");
    assert(context != null, "context must be not null");
    // assert(pickType != null, "pickType must be not null");

    I18nProvider provider = I18nProvider.chinese;
    int currentMaxSelected = 9 - hasSelectedCount;
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (ctx) => CQPhotoAlbumList(
          provider: provider,
          photoList: pathList,
          takePhotoCallBack: takePhotoCallBack,
          pickType: pickType,
          maxSelected: currentMaxSelected,
        ),
      ),
    );
  }
}
