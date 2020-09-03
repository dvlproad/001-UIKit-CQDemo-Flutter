import 'dart:typed_data';

import 'package:tsdemodemo_flutter/commonui/cq-imagepicker/take_photo_cell.dart';
import 'package:photo/photo.dart';
import 'package:tsdemodemo_flutter/commonutil/permissions/permission_manager.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

typedef CQImagePickerCallBack = void Function(String path);
typedef CQPickerImagesCallBack = void Function(
    List<AssetEntity> assetEntitys, List<Uint8List> assetThumbDatas);
typedef CQTakePhotoCallBack = void Function(String imagePath);

class CQImagePickerUtil {
  // Routes.navigateTo(
  //             context,
  //             Routes.commonTakePhotoPage,
  //             params: {},
  //           ).then((value) {
  //             // 接收下一个页面返回回来的数据
  //             String path = value as String;
  //             print('媒体路径为' + path);

  //             ImageProvider image = AssetImage(path);
  //             String message = "00:49";
  //             ImageCellBean cellBean = ImageCellBean(image, message);

  //             _photoAlbumAssets.add(cellBean);
  //             setState(() {});
  //           });

  Future<void> pickerImageOrVideo({
    int type,
    @required BuildContext context,
    @required ImagePicker imagePicker,
    @required CQImagePickerCallBack imagePickerCallBack,
  }) async {
    if (type == 1 && !await PermissionsManager.checkPhotoPermissions(context)) {
      return;
    }
    if (type == 2 && !await PermissionsManager.checkCarmePermissions(context)) {
      return;
    }
    final PickedFile pickedFile = await imagePicker.getImage(
      source: type == 1 ? ImageSource.gallery : ImageSource.camera,
      maxHeight: 1920,
      maxWidth: 1080,
      imageQuality: 70,
    );
    if (pickedFile != null && imagePickerCallBack != null) {
      imagePickerCallBack(pickedFile.path); //获取到图片地址
    }
    print("获取到的图片地址: pickedFile = $pickedFile");
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
    this.pickAsset(
      type: type,
      pathList: pathList,
      context: context,
      pickerImagesCallBack: pickerImagesCallBack,
      loadingDelegate: loadingDelegate,
      hasSelectedCount: hasSelectedCount,
      prefixWidget: _takePhotoCell(
        context: context,
        takePhotoCallBack: takePhotoCallBack,
      ),
    );
  }

  /// 拍照的 cell
  Widget _takePhotoCell({
    @required BuildContext context,
    @required CQTakePhotoCallBack takePhotoCallBack,
  }) {
    ImagePicker imagePicker = ImagePicker();
    return CQTakePhotoCell(
      context: context,
      imagePicker: imagePicker,
      takePhotoCallBack: (String path) {
        Navigator.pop(context);

        if (takePhotoCallBack != null) {
          takePhotoCallBack(path);
        }
      },
    );
  }

  /// 选择相册
  Future<void> pickAsset({
    @required PickType type,
    @required List<AssetPathEntity> pathList,
    @required BuildContext context,
    @required CQPickerImagesCallBack pickerImagesCallBack,
    LoadingDelegate loadingDelegate,
    int hasSelectedCount = 0,
    Widget prefixWidget, // prefix widget
  }) async {
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    /// context is required, other params is optional.
    assert(context != null);

    PhotoPicker.clearThumbMemoryCache();

    int currentMaxSelected = 9 - hasSelectedCount;

    List<AssetEntity> assetEntitys = await PhotoPicker.pickAsset(
      prefixWidget: prefixWidget,
      // BuildContext required
      context: context,

      /// The following are optional parameters.
      themeColor: Colors.black,
      // the title color and bottom color

      textColor: Colors.white,
      // text color
      padding: 5.0,
      // item padding
      dividerColor: Colors.black,
      // divider color
      disableColor: Colors.grey.shade300,
      // the check box disable color
      itemRadio: 1.00,
      // the content item radio
      maxSelected: currentMaxSelected,
      // max picker image count
      // provider: I18nProvider.english,
      provider: I18nProvider.chinese,
      // i18n provider ,default is chinese. , you can custom I18nProvider or use ENProvider()
      rowCount: 4,
      // item row count

      thumbSize: 150,
      // preview thumb size , default is 64
      sortDelegate: SortDelegate.common,
      // default is common ,or you make custom delegate to sort your gallery
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        checkColor: Colors.green,
        unselectedColor: Colors.white,
      ),
      // default is DefaultCheckBoxBuilderDelegate ,or you make custom delegate to create checkbox

      loadingDelegate: loadingDelegate,
      // if you want to build custom loading widget,extends LoadingDelegate, [see example/lib/main.dart]

      badgeDelegate: const DurationBadgeDelegate(),
      // badgeDelegate to show badge widget

      pickType: type,

      photoPathList: pathList,
    );

    List<Uint8List> assetThumbDatas = [];
    for (AssetEntity assetEntity in assetEntitys) {
      Uint8List thumbData = await assetEntity.thumbData;
      assetThumbDatas.add(thumbData);
    }

    if (pickerImagesCallBack != null) {
      pickerImagesCallBack(assetEntitys, assetThumbDatas);
    }
  }
}
