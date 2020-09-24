import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photo-add-delete-list/images_add_delete_list.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photo-choose-util/photo_permission_pick_take_util.dart';

// GlobalKey<_CQImageDeleteAddPickListState> imageDeleteAddPickListKey =
//     GlobalKey();

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
    CQImagePickerUtil().pickAssetOrTakePhoto(
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
      if (imageOrPhotoModel is AssetEntity) {
        AssetEntity assetEntity = imageOrPhotoModel;
        imageOrPhotoFile = await assetEntity.file;
      } else if (imageOrPhotoModel is String) {
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
