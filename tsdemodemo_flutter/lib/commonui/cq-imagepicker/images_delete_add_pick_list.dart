import 'dart:io';
import 'dart:typed_data';
import 'package:tsdemodemo_flutter/commonui/base-uikit/bg_border_widget.dart';
import 'package:flutter/material.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:tsdemodemo_flutter/commonui/cq-imagepicker/imagepicker_util.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photoalbum/adddelete/images_delete_list.dart';

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
    return CQImageDeleteList(
      maxAddCount: 9,
      imageOrPhotoModels: _imageOrPhotoModels,
      prefixWidget: _addCell(),
    );
  }

  /// 添加图片的 cell
  Widget _addCell() {
    return CJBGImageWidget(
      backgroundImage: AssetImage('assets/images/photoalbum/pic_添加图片.png'),
      // child: Icon(C1440Icon.icon_addattention, color: Colors.white),
      child: Container(),
      onPressed: () {
        this._addevent();
      },
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
