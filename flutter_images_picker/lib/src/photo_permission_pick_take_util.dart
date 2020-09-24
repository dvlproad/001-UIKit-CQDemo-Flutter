import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo/src/entity/options.dart';
// export 'package:photo/src/entity/options.dart' show PickType;

import './photo_pick_uti.dart';
import './photo_take_util.dart';
import './permission_manager.dart';

import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo/src/ui/dialog/not_permission_dialog.dart';
import 'package:photo/src/provider/i18n_provider.dart';
// export 'package:photo/src/provider/i18n_provider.dart'
//     show I18NCustomProvider, I18nProvider, CNProvider, ENProvider;

typedef CQImagePickerCallBack = void Function(String path);
typedef CQPickerImagesCallBack = void Function(
    List<AssetEntity> assetEntitys, List<Uint8List> assetThumbDatas);
typedef CQTakePhotoCallBack = void Function(String imagePath);

class CQImagePickerUtil {
  Future<void> takePhoto({
    @required BuildContext context,
    @required ImagePicker imagePicker,
    @required CQImagePickerCallBack imagePickerCallBack,
  }) async {
    if (!await PermissionsManager.checkCarmePermissions(context)) {
      return;
    }
    await CQTakePhtoUtil.takePhoto(
      imagePicker: imagePicker,
      imagePickerCallBack: imagePickerCallBack,
    );
  }

  /// 选择相册 或 拍照
  Future<void> pickAssetOrTakePhoto({
    @required PickType type,
    @required List<AssetPathEntity> pathList,
    @required BuildContext context,
    @required CQPickerImagesCallBack pickerImagesCallBack,
    @required CQTakePhotoCallBack takePhotoCallBack,
    LoadingDelegate loadingDelegate,
    int hasSelectedCount = 0,
  }) async {
    var requestPermission = await PhotoManager.requestPermission();
    if (requestPermission != true) {
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      var result = await showDialog(
        context: context,
        builder: (ctx) => NotPermissionDialog(
          I18NPermissionProvider(
            cancelText: "取消",
            sureText: "去开启",
            titleText: "没有访问相册的权限",
          ),
        ),
      );
      if (result == true) {
        PhotoManager.openSetting();
      }
      return null;
    }

    List<AssetEntity> assetEntitys =
        await CQAssetEntityPickerUtil.pickAssetEntitys(
      pickType: type,
      pathList: pathList,
      context: context,
      hasSelectedCount: hasSelectedCount,
      takePhotoCallBack: takePhotoCallBack,
    );

    List<Uint8List> assetThumbDatas = [];
    if (assetEntitys != null) {
      for (AssetEntity assetEntity in assetEntitys) {
        Uint8List thumbData = await assetEntity.thumbData;
        assetThumbDatas.add(thumbData);
      }
    }

    if (pickerImagesCallBack != null) {
      pickerImagesCallBack(assetEntitys, assetThumbDatas);
    }
  }
}
