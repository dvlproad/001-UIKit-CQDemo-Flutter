import 'dart:io' show File;
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart';

import './widget/image_or_photo_grid_cell.dart';

class CQImageDeleteAddPickList extends StatefulWidget {
  final List<dynamic> imageOrPhotoModels; // 数据类型 只能为 AssetEntity、String、File
  // final Widget Function(dynamic imageOrPhotoModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  final void Function(List<dynamic> imageOrPhotoModels)
      imageOrPhotoModelsChangeBlock; // 当前选中的相册信息

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
      imageCount: _imageOrPhotoModels.length,
      itemImageContentBuilder: ({
        @required BuildContext context,
        @required int imageIndex,
        @required double itemWidth,
        @required double itemHeight,
      }) {
        dynamic imageOrPhotoModel = _imageOrPhotoModels[imageIndex];

        return CQImageOrPhotoGridCell(
          imageOrPhotoModel: imageOrPhotoModel,
          index: imageIndex,
          onPressed: () {
            print('点击$imageIndex');
          },
        );
      },
      onPressedDelete: (imageIndex) {
        dynamic imageOrPhotoModel = _imageOrPhotoModels[imageIndex];
        widget.imageOrPhotoModels.remove(imageOrPhotoModel);
      },
      onPressedAdd: this._addevent,
    );
  }

  void _addevent() {
    ActionSheetUtil.chooseItem(
      context,
      title: '选择图片',
      itemTitles: ['拍照上传', '从相册选择'],
      onConfirm: (int selectedIndex) {
        dealAvatar(selectedIndex);
      },
    );
  }

  void dealAvatar(int selectedIndex) async {
    if (selectedIndex == 0) {
      PhotoTakeUtil.takePhoto(
        imagePickerCallBack: (path) {
          _imageOrPhotoModels.add(path);

          if (widget.imageOrPhotoModelsChangeBlock != null) {
            // print('当前最新的图片数目为${_imageOrPhotoModels.length}');
            widget.imageOrPhotoModelsChangeBlock(_imageOrPhotoModels);
          }
        },
      );
    } else {
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
