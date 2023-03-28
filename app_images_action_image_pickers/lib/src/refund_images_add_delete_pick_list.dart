import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import './widget/image_or_photo_grid_cell.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';

class RefundImageAddDeletePickList extends StatefulWidget {
  final double width;
  final double? height;
  final bool dragEnable;
  final void Function(int oldIndex, int newIndex)? dragCompleteBlock;

  final List<AppImageChooseBean>? imageChooseModels;
  // final Widget Function(dynamic imageChooseModel) badgeWidgetSetupBlock; // 可以返回为'删除'按钮 或者 '选中'按钮等任意
  final void Function(List<AppImageChooseBean> imageChooseModels,
          PickPhotoAllowType bNewPickPhotoAllowType)
      imageChooseModelsChangeBlock; // 当前选中的相册信息
  final void Function(
          List<AppImageChooseBean> imageChooseModels, int imageIndex)?
      onPressedImage;

  final AddCellType addCellType;

  final PickPhotoAllowType pickAllowType;

  RefundImageAddDeletePickList({
    Key? key,
    required this.width,
    this.height,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    this.imageChooseModels,
    required this.imageChooseModelsChangeBlock,
    this.onPressedImage, // 自定义点击图片的事件(默认是浏览)
    this.addCellType = AddCellType.defalut_add,
    this.pickAllowType = PickPhotoAllowType.imageOnly,
  }) : super(key: key);

  @override
  _RefundImageAddDeletePickListState createState() =>
      _RefundImageAddDeletePickListState();
}

class _RefundImageAddDeletePickListState
    extends State<RefundImageAddDeletePickList> {
  List<AppImageChooseBean> _imageChooseModels = [];

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
    // print("list === path111====================");
    // int count = _imageChooseModels.length ?? 0;
    // for (var i = 0; i < count; i++) {
    //   AppImageChooseBean item = _imageChooseModels[i];

    //   String path = item.localPath;
    //   print("list path111=$i:$path");
    // }
    return CQImagesAddDeleteList(
      width: widget.width,
      height: widget.height,
      dragEnable: widget.dragEnable,
      dragCompleteBlock: widget.dragCompleteBlock,
      maxAddCount: 3,
      imageCount: _imageChooseModels.length,
      itemImageContentBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
      }) {
        AppImageChooseBean imageChooseModel = _imageChooseModels[imageIndex];
        // print("list path111=$imageIndex:${imageChooseModel.localPath}");

        return CQImageOrPhotoGridCell(
          width: itemWidth,
          height: itemHeight,
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

        widget.imageChooseModelsChangeBlock(
          _imageChooseModels,
          widget.pickAllowType,
        );
      },
      addCellBuilder: () {
        return AddCell(addCellType: widget.addCellType);
      },
      onPressedAdd: _addevent,
    );
  }

  void _addevent() {
    FocusScope.of(context).requestFocus(FocusNode());
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
      context,
      pickAllowType: widget.pickAllowType,
      imageChooseModels: _imageChooseModels,
      imagePickerCallBack: ({
        List<ImageChooseBean>? newAddedImageChooseModels,
        List<ImageChooseBean>? newCancelImageChooseModels,
      }) {
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
        PickPhotoAllowType newPickPhotoAllowType = widget.pickAllowType;
        if (newAddedImageChooseModels != null &&
            newAddedImageChooseModels.isNotEmpty) {
          ImageChooseBean firstImageChooseModel =
              newAddedImageChooseModels.first;

          AssetType firstAddAssetType = firstImageChooseModel.assetEntity!.type;

          if (firstAddAssetType == AssetType.video) {
            newPickPhotoAllowType = PickPhotoAllowType.videoOnly;
          }

          List<AppImageChooseBean> addImageBeans = [];
          for (ImageChooseBean item in newAddedImageChooseModels) {
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
        }

        // setState(() {
        //   _dealAddedImageChooseModels(_imageChooseModels);
        // });

        widget.imageChooseModelsChangeBlock(
          _imageChooseModels,
          newPickPhotoAllowType,
        );
        // print('images_add_delete_pick_list 22:${DateTime.now().toString()}');
      },
    );
    // }
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
