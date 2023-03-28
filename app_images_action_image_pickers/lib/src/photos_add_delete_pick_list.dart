import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';

import 'package:flutter_media_picker/flutter_media_picker.dart';

import './widget/image_or_photo_grid_cell.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';

import 'package:photo_manager/photo_manager.dart' show AssetEntity;

class PhotoAddDeletePickList extends StatefulWidget {
  final double width;
  final double? height;
  final Color? color;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final List<AppImageChooseBean>? imageChooseModels;
  // final Widget Function(dynamic imageChooseModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  final void Function(List<AppImageChooseBean> imageChooseModels)
      imageChooseModelsChangeBlock; // 当前选中的相册信息
  final void Function(
          List<AppImageChooseBean> imageChooseModels, int imageIndex)?
      onPressedImage;

  final AddCellType? addCellType;

  final PickPhotoAllowType pickAllowType;
  final Function isClickUpImg;

  const PhotoAddDeletePickList({
    Key? key,
    required this.width,
    this.height,
    this.color,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    this.imageChooseModels,
    required this.imageChooseModelsChangeBlock,
    this.onPressedImage, // 自定义点击图片的事件(默认是浏览)
    this.addCellType,
    this.pickAllowType = PickPhotoAllowType.imageOnly,
    required this.isClickUpImg,
  }) : super(key: key);

  @override
  _PhotoAddDeletePickListState createState() => _PhotoAddDeletePickListState();
}

class _PhotoAddDeletePickListState extends State<PhotoAddDeletePickList> {
  List<AppImageChooseBean> _imageChooseModels = [];
  final int _maxAddCount = 9;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _imageChooseModels = widget.imageChooseModels ?? [];

    return CQImagesAddDeleteList(
      width: widget.width,
      height: widget.height,
      color: widget.color,
      direction: Axis.horizontal,
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      dragEnable: widget.dragEnable,
      dragCompleteBlock: widget.dragCompleteBlock,
      hideDeleteIcon: true,
      maxAddCount: _maxAddCount,
      itemWidthHeightRatio: 144.0 / 180.0,
      imageCount: _imageChooseModels.length,
      itemImageContentBuilder: (
          {required BuildContext context,
          required int imageIndex,
          required double itemHeight,
          required double itemWidth}) {
        AppImageChooseBean imageChooseModel = _imageChooseModels[imageIndex];
        // print("list path111=$imageIndex:${imageChooseModel.localPath}");

        return CQImageOrPhotoGridCell(
          width: itemWidth,
          height: itemHeight,
          cornerRadius: 5,
          imageChooseModel: imageChooseModel,
          index: imageIndex,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            debugPrint('点击imageIndex=$imageIndex的图片');
            // _focusNode.unfocus();

            if (widget.onPressedImage != null) {
              widget.onPressedImage!(_imageChooseModels, imageIndex);
            } else {
              PreviewUtil.preview(
                context,
                imageChooseModels: _imageChooseModels,
                imageIndex: imageIndex,
              );
            }
          },
        );
      },
      onPressedDelete: (imageIndex) {
        AppImageChooseBean imageChooseModel = _imageChooseModels[imageIndex];
        _imageChooseModels.remove(imageChooseModel);
        setState(() {});
      },
      addCellBuilder: () {
        return AddCell(addCellType: AddCellType.image_text_for_user_photos);
      },
      onPressedAdd: _addevent,
    );
  }

  void _addevent() {
    FocusScope.of(context).requestFocus(FocusNode());
    widget.isClickUpImg();
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
    PickUtil.pickPhoto(
      context,
      maxCount: _maxAddCount,
      pickAllowType: widget.pickAllowType,
      imageChooseModels: _imageChooseModels,
      imagePickerCallBack: ({
        List<ImageChooseBean>? newAddedImageChooseModels,
        List<ImageChooseBean>? newCancelImageChooseModels,
      }) async {
        // print('images_add_delete_pick_list 11:${DateTime.now().toString()}');
        // 新取消的图片
        List<AssetEntity> shouldCancelAssetEntitys = [];
        for (var item in newCancelImageChooseModels ?? []) {
          shouldCancelAssetEntitys.add(item.assetEntity);
        }

        List<AppImageChooseBean> shouldCancelAppImageChooseBeans = [];
        for (AppImageChooseBean item in _imageChooseModels) {
          if (item.assetEntity != null &&
              shouldCancelAssetEntitys.contains(item.assetEntity)) {
            shouldCancelAppImageChooseBeans.add(item);
          }
        }

        _imageChooseModels.removeWhere((element) {
          return shouldCancelAppImageChooseBeans.contains(element);
        });

        // 新添加的图片
        List<AppImageChooseBean> addImageBeans = [];
        for (ImageChooseBean item in newAddedImageChooseModels ?? []) {
          AppImageChooseBean bean = AppImageChooseBean(
            assetEntity: item.assetEntity,
            networkUrl: item.networkUrl,
            width: item.width,
            height: item.height,
          );
          bean.checkAndBeginCompressAssetEntity();
          // T bean = T();
          // bean.assetEntity = item.assetEntity;
          // bean.localPath = item.localPath;
          // bean.networkUrl = item.networkUrl;
          // bean.width = item.width;
          // bean.height = item.height;
          // bean.compressImageBean = item.compressImageBean;
          addImageBeans.add(bean);
        }
        _imageChooseModels.addAll(addImageBeans);
        // await _dealAddedImageChooseModels(_imageChooseModels);
        // setState(() {});

        modelsChangeBlock();
        // print('images_add_delete_pick_list 22:${DateTime.now().toString()}');
      },
    );
    // }
  }

  //回调
  modelsChangeBlock() {
    if (_imageChooseModels.isEmpty) {
      return;
    }
    if (_imageChooseModels.last.compressImageBean == null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        modelsChangeBlock();
      });
      return;
    } else {
      widget.imageChooseModelsChangeBlock(_imageChooseModels);
    }
    debugPrint('当前最新的图片数目为${_imageChooseModels.length}');
  }

  /*
  Future<bool> _dealAddedImageChooseModels(
      List<AppImageChooseBean> addedImageChooseModels) async {
    _log('获取所选择的所有图片的宽高开始...');
    int count = addedImageChooseModels.length;

    List<Future<Map<String, dynamic>>> futures = [];
    for (var i = 0; i < count; i++) {
      AppImageChooseBean addedImageChooseModel = addedImageChooseModels[i];

      Image image;
      if (addedImageChooseModel.networkUrl != null) {
        String imageUrl = addedImageChooseModel.networkUrl;
        image = Image.network(imageUrl);
        debugPrint(
            '$imageUrl 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');
      } else {
        String imageFileLocalPath = addedImageChooseModel.assetEntityPath;
        image = Image.file(File(imageFileLocalPath));
        debugPrint(
            '$imageFileLocalPath 图片的宽高如下:\nimageWidth111=${image.width}, imageHeight=${image.height}');
      }

      ImageProvider imageProvider = image.image;

      Future<Map<String, dynamic>> future = getWidthAndHeight(imageProvider);
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
        AppImageChooseBean addedImageChooseModel = addedImageChooseModels[i];
        String imageFileLocalPath = addedImageChooseModel.assetEntityPath;

        Map<String, dynamic> imageWidthHeight = results[i];
        int imageWidth = imageWidthHeight['width'];
        int imageHeight = imageWidthHeight['height'];
        debugPrint(
            '$imageFileLocalPath 图片的宽高如下:\nimageWidth222=$imageWidth, imageHeight=$imageHeight');

        addedImageChooseModel.width = imageWidth;
        addedImageChooseModel.height = imageHeight;
      }

      _log('获取所选择的所有图片的宽高结束...');

      return true;
    });
  }
  */

  Future<Map<String, dynamic>> getWidthAndHeight(
      ImageProvider<Object> imageProvider) async {
    Completer<Map<String, dynamic>> completer = Completer();

    imageProvider.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener(
        (ImageInfo info, bool _) {
          int imageWidth = info.image.width;
          int imageHeight = info.image.height;
          debugPrint('imageWidth=$imageWidth, imageHeight=$imageHeight');

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
