import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import './widget/image_or_photo_grid_cell.dart';
import './bean/image_choose_bean.dart';
export './bean/image_choose_bean.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';
import 'pick_util.dart';
import './pick_util/pick_asset_util.dart' show PickPhotoAllowType;

///TODO:临时处理
import './app_upload_util.dart';
import './app_upload_bean.dart';

class ImageAddDeletePickList extends StatefulWidget {
  final double width;
  final double? height;
  final Color? color;
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

  final PickPhotoAllowType Function(
      List<AppImageChooseBean> currentImageChooseModels)? pickAllowTypeGetBlock;
  final int Function(PickPhotoAllowType pickPhotoAllowType)?
      maxAddCountGetBlock;

  final String Function({int imageIndex})? flagTextBuilder;

  ImageAddDeletePickList({
    Key? key,
    required this.width,
    this.height,
    this.color,
    this.dragEnable = false, // 是否可以拖动
    this.dragCompleteBlock,
    this.imageChooseModels,
    this.flagTextBuilder,
    required this.imageChooseModelsChangeBlock,
    this.onPressedImage, // 自定义点击图片的事件(默认是浏览)
    this.addCellType = AddCellType.defalut_add,
    this.pickAllowTypeGetBlock,
    this.maxAddCountGetBlock, // 最大选择数(未设置则图片9张，视频1张，互斥)
  }) : super(key: key);

  @override
  ImageAddDeletePickListState createState() => ImageAddDeletePickListState();
}

class ImageAddDeletePickListState extends State<ImageAddDeletePickList> {
  List<AppImageChooseBean> _imageChooseModels = [];
  int _maxAddCount = 9;

  PickPhotoAllowType _pickAllowType = PickPhotoAllowType.imageOnly;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _imageChooseModels = widget.imageChooseModels ?? [];
    _updatePickAllowTypeAndMaxAddCountByMediaModels();
  }

  @override
  Widget build(BuildContext context) {
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
      color: widget.color,
      dragEnable: widget.dragEnable,
      dragCompleteBlock: (int oldIndex, int newIndex) {
        if (widget.dragCompleteBlock != null) {
          widget.dragCompleteBlock!(oldIndex, newIndex);
        } else {
          AppImageChooseBean bean = _imageChooseModels.removeAt(oldIndex);
          _imageChooseModels.insert(newIndex, bean);

          setState(() {});
        }
      },
      maxAddCount: _maxAddCount,
      imageCount: _imageChooseModels.length,
      itemImageContentBuilder: ({
        required BuildContext context,
        required int imageIndex,
        required double itemHeight,
        required double itemWidth,
      }) {
        AppImageChooseBean imageChooseModel = _imageChooseModels[imageIndex];
        // print("list path111=$imageIndex:${imageChooseModel.localPath}");

        String? flagText = null;
        if (widget.flagTextBuilder != null) {
          flagText = widget.flagTextBuilder!(imageIndex: imageIndex);
        }

        return CQImageOrPhotoGridCell(
          width: itemWidth,
          height: itemHeight,
          imageChooseModel: imageChooseModel,
          index: imageIndex,
          flagText: flagText,
          onPressed: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _log('点击imageIndex=$imageIndex的图片');
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

        _imageChooseModelsChange();
      },
      addCellBuilder: () {
        return AddCell(addCellType: widget.addCellType);
      },
      onPressedAdd: this._addevent,
    );
  }

  /// 清空图片和视频，供外部使用
  clear() {
    setState(() {
      _imageChooseModels.clear();
    });
  }

  update(List<AppImageChooseBean>? imageChooseModels) {
    setState(() {
      _imageChooseModels = imageChooseModels ?? [];
    });
  }

  Future<bool> upload() async {
    if (_imageChooseModels != null) {
      UploadMediaType mediaType = UploadMediaType.image;
      if (_pickAllowType == PickPhotoAllowType.videoOnly) {
        mediaType = UploadMediaType.video;
        _log("==============视频上传开始，请等待");
      } else {
        _log("==============图片上传开始，请等待");
      }
      UploadMediaResultType uploadMediaResultType =
          await UploadApiUtil.uploadImageChooseModels(
        context: context,
        imageChooseModels: _imageChooseModels,
        mediaType: mediaType,
      );

      if (uploadMediaResultType == UploadMediaResultType.UploadSuccess) {
        _log("==============图片/视频上传完毕，继续上传语音/开始发布");
      } else {
        String errorString =
            UploadApiUtil.getUploadMediaResultTypeString(uploadMediaResultType);
        ToastUtil.showMessage(errorString);
        return false;
      }
    }

    return true;
  }

  void _imageChooseModelsChange() {
    _log('PickUtil 05}');
    _updatePickAllowTypeAndMaxAddCountByMediaModels();
    if (widget.imageChooseModelsChangeBlock != null) {
      widget.imageChooseModelsChangeBlock(
        _imageChooseModels,
        _pickAllowType,
      );
    }
    _log('PickUtil 06');
    setState(() {}); // 直接在本类中更新视图
  }

  _updatePickAllowTypeAndMaxAddCountByMediaModels() {
    if (widget.pickAllowTypeGetBlock != null) {
      _pickAllowType = widget.pickAllowTypeGetBlock!(_imageChooseModels);
    } else {
      _pickAllowType = _getNewPickAllowTypeByImageChooseModels();
    }

    if (widget.maxAddCountGetBlock != null) {
      _maxAddCount = widget.maxAddCountGetBlock!(_pickAllowType);
    } else {
      _maxAddCount = _pickAllowType == PickPhotoAllowType.videoOnly ? 1 : 9;
    }
  }

  PickPhotoAllowType _getNewPickAllowTypeByImageChooseModels() {
    PickPhotoAllowType newPickPhotoAllowType = _pickAllowType;
    if (_imageChooseModels != null && _imageChooseModels.isNotEmpty) {
      ImageChooseBean firstImageChooseModel = _imageChooseModels.first;
      UploadMediaType firstAddAssetType = firstImageChooseModel.mediaType;

      if (firstAddAssetType == UploadMediaType.video) {
        newPickPhotoAllowType = PickPhotoAllowType.videoOnly;
      } else {
        newPickPhotoAllowType = PickPhotoAllowType.imageOnly;
      }
    } else {
      newPickPhotoAllowType = PickPhotoAllowType.imageOrVideo;
    }

    return newPickPhotoAllowType;
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
    PickUtil.pickPhoto(
      context,
      maxCount: _maxAddCount,
      pickAllowType: _pickAllowType,
      imageChooseModels: _imageChooseModels,
      imagePickerCallBack: ({
        List<ImageChooseBean>? newAddedImageChooseModels,
        List<ImageChooseBean>? newCancelImageChooseModels,
      }) {
        _log('PickUtil 03');
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
        PickPhotoAllowType newPickPhotoAllowType = _pickAllowType;
        if (newAddedImageChooseModels != null &&
            newAddedImageChooseModels.isNotEmpty) {
          List<AppImageChooseBean> addImageBeans = [];
          for (ImageChooseBean item in newAddedImageChooseModels) {
            AppImageChooseBean bean = AppImageChooseBean(
              assetEntity: item.assetEntity,
              networkUrl: item.networkUrl,
              width: item.width,
              height: item.height,
            );
            // T bean = T();
            // bean.assetEntity = item.assetEntity;
            // bean.localPath = item.localPath;
            // bean.networkUrl = item.networkUrl;
            // bean.width = item.width;
            // bean.height = item.height;
            // bean.compressImageBean = item.compressImageBean;
            addImageBeans.add(bean);
          }
          _compressAddMediaBeans(addImageBeans); // 异步压缩所添加的文件

          _imageChooseModels.addAll(addImageBeans);
        }

        // setState(() {
        //   // _dealAddedImageChooseModels(_imageChooseModels);
        // });
        _log('PickUtil 04');
        _imageChooseModelsChange();
      },
    );
    // }
  }

  /// 异步压缩所添加的文件
  Future _compressAddMediaBeans(List<AppImageChooseBean> addMeidaBeans) async {
    for (AppImageChooseBean bean in addMeidaBeans) {
      _log("bean.assetEntity.id=${bean.assetEntity!.id} begin...");
      bean.checkAndBeginCompressAssetEntity();
      // 异步压缩，并且每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃
      await Future.delayed(Duration(milliseconds: 500));
      _log("bean.assetEntity.id=${bean.assetEntity!.id} finish...");
    }
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
      if (addedImageChooseModel.mediaType == UploadMediaType.image) {
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
      } else if (addedImageChooseModel.mediaType == UploadMediaType.image) {
        //
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
          _log('imageWidth=$imageWidth, imageHeight=$imageHeight');

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

  _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
