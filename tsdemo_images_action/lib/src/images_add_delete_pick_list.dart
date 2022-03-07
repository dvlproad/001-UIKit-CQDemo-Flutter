import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

typedef CQImageOrPhotoModelsChangeBlock = void Function(
    List<dynamic> imageOrPhotoModels); // 当前选中的相册信息

class CQImageDeleteAddPickList extends StatefulWidget {
  final List<dynamic> imageOrPhotoModels; // 数据类型 只能为 AssetEntity、String、File
  final CQImageOrPhotoModelsChangeBlock imageOrPhotoModelsChangeBlock;

  CQImageDeleteAddPickList({
    Key key,
    this.imageOrPhotoModels,
    @required this.imageOrPhotoModelsChangeBlock,
  }) : super(key: key);

  @override
  _CQImageDeleteAddPickListState createState() =>
      new _CQImageDeleteAddPickListState();

  /// 获取 files
  static Future<List<File>> filesFromImageOrPhotoModels(
      List<dynamic> imageOrPhotoModels) async {
    return _CQImageDeleteAddPickListState.getFilesFromImageOrPhotoModels(
        imageOrPhotoModels);
  }
}

class _CQImageDeleteAddPickListState extends State<CQImageDeleteAddPickList> {
  List<dynamic> _imageOrPhotoModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageOrPhotoModels = widget.imageOrPhotoModels ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesAddDeleteList(
      imageOrPhotoModels: _imageOrPhotoModels,
      onPressedAdd: this._addevent,
    );
  }

  void _addevent() {
    ActionSheetUtil.chooseItem(
      context,
      title: '更换头像',
      itemTitles: ['拍照上传', '从相册选择'],
      onConfirm: (int selectedIndex) {
        dealAvatar(selectedIndex);
      },
    );
    /*
    PhotoPickUtil().pickAssetOrTakePhoto(
      type: PickType.onlyImage,
      pathList: null,
      hasSelectedCount: _imageOrPhotoModels.length,
      context: context,
      // loadingDelegate: this,
      takePhotoCallBack: (String path) {
        _imageOrPhotoModels.add(path);

        if (widget.imageOrPhotoModelsChangeBlock != null) {
          // print('当前最新的图片数目为${_imageOrPhotoModels.length}');
          widget.imageOrPhotoModelsChangeBlock(_imageOrPhotoModels);
        }
      },
      pickerImagesCallBack:
          (List<AssetEntity> assetEntitys, List<Uint8List> assetThumbDatas) {
        if (assetEntitys == null || assetEntitys.isEmpty) {
          return;
        }

        _imageOrPhotoModels.addAll(assetEntitys);

        if (widget.imageOrPhotoModelsChangeBlock != null) {
          // print('当前最新的图片数目为${_imageOrPhotoModels.length}');
          widget.imageOrPhotoModelsChangeBlock(_imageOrPhotoModels);
        }
      },
    );
    */
  }

  void dealAvatar(int selectedIndex) async {
    PhotoPickUtil.pickPhoto(
      imagePickerCallBack: (path) {
        _imageOrPhotoModels.add(path);

        if (widget.imageOrPhotoModelsChangeBlock != null) {
          // print('当前最新的图片数目为${_imageOrPhotoModels.length}');
          widget.imageOrPhotoModelsChangeBlock(_imageOrPhotoModels);
        }
      },
    );
  }

  /// 获取 files
  Future<List<File>> files() async {
    return _CQImageDeleteAddPickListState.getFilesFromImageOrPhotoModels(
        _imageOrPhotoModels);
  }

  static Future<List<File>> getFilesFromImageOrPhotoModels(
      List<dynamic> imageOrPhotoModels) async {
    if (imageOrPhotoModels == null) {
      return Future.value([]);
    }

    List<File> imageOrPhotoFiles = [];
    for (dynamic imageOrPhotoModel in imageOrPhotoModels) {
      File imageOrPhotoFile;
      if (imageOrPhotoModel is String) {
        String path = imageOrPhotoModel;
        imageOrPhotoFile = File(path);
      } else if (imageOrPhotoModel is File) {
        imageOrPhotoFile = imageOrPhotoModel;
      } else {
        assert(true, '此类型未处理，报错');
      }

      if (imageOrPhotoFile != null) {
        imageOrPhotoFiles.add(imageOrPhotoFile);
      }
    }
    return Future.value(imageOrPhotoFiles);
  }
}
