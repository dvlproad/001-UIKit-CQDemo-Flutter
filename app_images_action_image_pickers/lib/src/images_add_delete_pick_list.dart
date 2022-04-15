import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import './widget/image_or_photo_grid_cell.dart';
import './bean/image_choose_bean.dart';
export './bean/image_choose_bean.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview_util.dart';
import './pick_util.dart';

class ImageAddDeletePickList<T extends ImageChooseBean> extends StatefulWidget {
  final List imageChooseModels;
  // final Widget Function(dynamic imageChooseModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  final void Function(List imageChooseModels)
      imageChooseModelsChangeBlock; // 当前选中的相册信息
  final void Function(List imageChooseModels, int imageIndex) onPressedImage;

  final AddCellType addCellType;

  ImageAddDeletePickList({
    Key key,
    this.imageChooseModels,
    @required this.imageChooseModelsChangeBlock,
    this.onPressedImage, // 自定义点击图片的事件(默认是浏览)
    this.addCellType,
  }) : super(key: key);

  @override
  _ImageAddDeletePickListState createState() => _ImageAddDeletePickListState();
}

class _ImageAddDeletePickListState<T extends ImageChooseBean>
    extends State<ImageAddDeletePickList> {
  List _imageChooseModels;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _imageChooseModels = widget.imageChooseModels ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return CQImagesAddDeleteList(
      imageCount: _imageChooseModels.length,
      itemImageContentBuilder: ({context, imageIndex}) {
        T imageChooseModel = _imageChooseModels[imageIndex];

        return CQImageOrPhotoGridCell(
          imageChooseModel: imageChooseModel,
          index: imageIndex,
          onPressed: () {
            print('点击imageIndex=$imageIndex的图片');
            // _focusNode.unfocus();

            if (widget.onPressedImage != null) {
              widget.onPressedImage(_imageChooseModels, imageIndex);
            } else {
              PreviewUtil.preview(_imageChooseModels, imageIndex);
            }
          },
        );
      },
      onPressedDelete: (imageIndex) {
        T imageChooseModel = _imageChooseModels[imageIndex];
        _imageChooseModels.remove(imageChooseModel);

        setState(() {});

        if (widget.imageChooseModelsChangeBlock != null) {
          // print('当前最新的图片数目为${_imageChooseModels.length}');
          widget.imageChooseModelsChangeBlock(_imageChooseModels);
        }
      },
      addCellBuilder: () {
        return AddCell(addCellType: widget.addCellType);
      },
      onPressedAdd: this._addevent,
    );
  }

  void _addevent() {
    dealAvatar(0);
    // ActionSheetUtil.chooseItem(
    //   context,
    //   title: '选择图片',
    //   itemTitles: ['拍照上传', '从相册选择'],
    //   onConfirm: (int selectedIndex) {
    //     dealAvatar(selectedIndex);
    //   },
    // );
  }

  void dealAvatar(int selectedIndex) async {
    // if (selectedIndex == 0) {
    //   PhotoTakeUtil.takePhoto(
    //     imagePickerCallBack: (path) {
    //       _imageChooseModels.add(path);

    //       if (widget.imageOrPhotoModelsChangeBlock != null) {
    //         // print('当前最新的图片数目为${_imageChooseModels.length}');
    //         widget.imageOrPhotoModelsChangeBlock(_imageChooseModels);
    //       }
    //     },
    //   );
    // } else {
    int selectCount = 9 - _imageChooseModels.length;
    PickUtil.pickPhoto(
      selectCount: selectCount,
      imagePickerCallBack: (bAddedImageChooseModels) {
        _imageChooseModels.addAll(bAddedImageChooseModels);

        _dealAddedImageChooseModels(_imageChooseModels);

        if (widget.imageChooseModelsChangeBlock != null) {
          // print('当前最新的图片数目为${_imageChooseModels.length}');
          widget.imageChooseModelsChangeBlock(_imageChooseModels);
        }

        setState(() {});
      },
    );
    // }
  }

  Future<bool> _dealAddedImageChooseModels(List addedImageChooseModels) async {
    int count = addedImageChooseModels.length ?? 0;

    List<Future<Map<String, dynamic>>> futures = [];
    for (var i = 0; i < count; i++) {
      T addedImageChooseModel = addedImageChooseModels[i];

      String imageFileLocalPath = addedImageChooseModel.localPath;
      Image image = Image.file(File(imageFileLocalPath));
      // debugPrint(
      //     '$imageFileLocalPath 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');

      ImageProvider imageProvider = image.image;

      Future future = getWidthAndHeight(imageProvider);
      futures.add(future);
    }
    // 串行
    // Map<String, dynamic> imageWidthHeight =
    //     await getWidthAndHeight(imageProvider);
    // int imageWidth = imageWidthHeight['width'];
    // int imageHeight = imageWidthHeight['height'];
    // debugPrint(
    //     '$imageFileLocalPath 图片的宽高如下:\nimageWidth222=$imageWidth, imageHeight=$imageHeight');

    // addedImageChooseModel.width = imageWidth;
    // addedImageChooseModel.height = imageHeight;

    // 并发
    return Future.wait(futures).then((List<Map<String, dynamic>> results) {
      for (var i = 0; i < count; i++) {
        T addedImageChooseModel = addedImageChooseModels[i];
        String imageFileLocalPath = addedImageChooseModel.localPath;

        Map<String, dynamic> imageWidthHeight = results[i];
        int imageWidth = imageWidthHeight['width'];
        int imageHeight = imageWidthHeight['height'];
        // debugPrint(
        //     '$imageFileLocalPath 图片的宽高如下:\nimageWidth222=$imageWidth, imageHeight=$imageHeight');

        addedImageChooseModel.width = imageWidth;
        addedImageChooseModel.height = imageHeight;
      }

      return true;
    });
  }

  Future<Map<String, dynamic>> getWidthAndHeight(
      ImageProvider<Object> imageProvider) async {
    Completer<Map<String, dynamic>> completer = Completer();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          // print('imageWidth=$imageWidth, imageHeight=$imageHeight');

          Map<String, dynamic> imageWithHeight = {
            "width": imageWidth,
            "height": imageHeight,
          };
          completer.complete(imageWithHeight);
        },
      ),
    );

    return completer.future;
  }
}
