/*
 * @Author: dvlproad
 * @Date: 2024-03-29 12:57:58
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-29 14:45:46
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

import './app/images_check_util.dart';

class AppPickModelUtil {
  static void addMedia<TBean extends ImageChooseBean>(
    BuildContext context,
    List<TBean> currentImageChooseModels, {
    bool needCompress = true,
    required TBean Function(ImageChooseBean item) createTInstance,
    required void Function(List<TBean> newCurImageChooseModels) completeBlock,
  }) {
    PickPhotoAllowType pickAllowType =
        pickAllowTypeByImageChooseModels(currentImageChooseModels);
    int maxAddCount = pickAllowType == PickPhotoAllowType.videoOnly ? 1 : 9;

    PickUtil.pickPhoto(
      context,
      maxCount: maxAddCount,
      pickAllowType: pickAllowType,
      imageChooseModels: currentImageChooseModels,
      imagePickerCallBack: ({
        List<ImageChooseBean>? newAddedImageChooseModels,
        List<ImageChooseBean>? newCancelImageChooseModels,
      }) async {
        if (newAddedImageChooseModels != null &&
            await ImageCheckUtil.checkMediaBeans(newAddedImageChooseModels) !=
                true) {
          return;
        }

        BasePickModelUtil.pickedsAddOrCancelTo(
          currentImageChooseModels,
          newAddedImageChooseModels: newAddedImageChooseModels,
          newCancelImageChooseModels: newCancelImageChooseModels,
          createTInstance: createTInstance,
          extraThingToAddedMeidaBeans: (
              {required List<TBean> addedMeidaBeans}) {
            extraThingToAddedMeidaBeans(
              addedMeidaBeans: addedMeidaBeans,
              needCompress: needCompress,
            );
          },
        );
        completeBlock(currentImageChooseModels);
      },
    );
  }

  /// 图片/视频更新自身接口(目前使用于：'更换视频'按钮的点击)
  static void updateMediaSelf<TBean extends ImageChooseBean>(
    BuildContext context,
    List<TBean> currentImageChooseModels,
    int mediaIndex, {
    PickPhotoAllowType pickAllowType = PickPhotoAllowType.imageOnly,
    required TBean Function(ImageChooseBean item) createTInstance,
    bool needCompress = true,
    required void Function(List<TBean> newCurImageChooseModels) completeBlock,
  }) {
    PickUtil.chooseOneMedia(
      context,
      pickAllowType: pickAllowType,
      completeBlock: (ImageChooseBean item) async {
        BasePickModelUtil.pickedReplaceTo(
          currentImageChooseModels,
          mediaIndex,
          item: item,
          createTInstance: createTInstance,
          extraThingToAddedMeidaBeans: (
              {required List<TBean> addedMeidaBeans}) {
            extraThingToAddedMeidaBeans(
              addedMeidaBeans: addedMeidaBeans,
              needCompress: needCompress,
            );
          },
        );

        completeBlock(currentImageChooseModels);
      },
    );
  }

  static PickPhotoAllowType pickAllowTypeByImageChooseModels(
      List<ImageChooseBean> imageChooseModels) {
    if (imageChooseModels.isEmpty) {
      return PickPhotoAllowType.imageOrVideo;
    }

    ImageChooseBean firstImageChooseModel = imageChooseModels.first;
    UploadMediaType firstAddAssetType = firstImageChooseModel.mediaType;
    if (firstAddAssetType == UploadMediaType.video) {
      return PickPhotoAllowType.videoOnly;
    } else {
      return PickPhotoAllowType.imageOnly;
    }
  }
  /*
  static appPickedsAddOrCancelTo<TBean extends ImageChooseBean>(
    List<TBean> currentImageChooseModels, {
    List<ImageChooseBean>? newAddedImageChooseModels,
    List<ImageChooseBean>? newCancelImageChooseModels,
    required TBean Function(ImageChooseBean item) createTInstance,
    bool needCompress = true,
  }) {
    return BasePickModelUtil.pickedsAddOrCancelTo(
      currentImageChooseModels,
      newAddedImageChooseModels: newAddedImageChooseModels,
      newCancelImageChooseModels: newCancelImageChooseModels,
      createTInstance: createTInstance,
      extraThingToAddedMeidaBeans: ({required List<TBean> addedMeidaBeans}) {
        extraThingToAddedMeidaBeans(
          addedMeidaBeans: addedMeidaBeans,
          needCompress: needCompress,
        );
      },
    );
  }

  static appPickedReplaceTo<TBean extends ImageChooseBean>(
    List<TBean> currentImageChooseModels,
    int mediaIndex, {
    required ImageChooseBean item,
    required TBean Function(ImageChooseBean item) createTInstance,
    bool needCompress = true,
  }) {
    return BasePickModelUtil.pickedReplaceTo(
      currentImageChooseModels,
      mediaIndex,
      item: item,
      createTInstance: createTInstance,
      extraThingToAddedMeidaBeans: ({required List<TBean> addedMeidaBeans}) {
        extraThingToAddedMeidaBeans(
          addedMeidaBeans: addedMeidaBeans,
          needCompress: needCompress,
        );
      },
    );
  }
  */

  // 其他额外需要对所添加媒体处理的事情（图片压缩、视频帧获取等）
  static void extraThingToAddedMeidaBeans<TBean extends ImageChooseBean>({
    required List<TBean> addedMeidaBeans,
    bool needCompress = true,
  }) {
    if (needCompress) {
      ImageCompressUtil.compressMediaBeans(addedMeidaBeans); // 异步压缩所添加的文件
    }

    /*
          if (addedMeidaBeans.first.assetEntity?.type == AssetType.video) {
            if (widget.needVideoFrames == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => ChooseFramePage(
                    video: _imageChooseModels.first,
                    onSubmit: (ImageChooseBean? imageChooseBean) {
                      widget.onChangeCover?.call(imageChooseBean);
                      if (imageChooseBean != null) {
                        ImageCompressUtil.compressMediaBeans(
                            [imageChooseBean]); // 异步压缩所添加的文件
                      }
                    },
                    customChooseCover: null,
                  ),
                ),
              );
            } else {
              // 预先截帧
              addedMeidaBeans.first.getVideoFrameBeans();
            }
          }

          if (_shouldJumpToImageTemplatePage(
              addMeidaBeans.first.assetEntity?.type)) {
            _jumpToImageTemplatePage(addMeidaBeans, ImageTemplateEditType.add);
          }
          */
  }
}

class BasePickModelUtil {
  /// 供子类调用的方法:所选中的值有效，即可以使用(在此之前可能需要先检查是否可进行此操作，所添加的文件是否可以使用(是否太长，是否太大))
  static pickedsAddOrCancelTo<TBean extends ImageChooseBean>(
    List<TBean> currentImageChooseModels, {
    List<ImageChooseBean>? newAddedImageChooseModels,
    List<ImageChooseBean>? newCancelImageChooseModels,
    required TBean Function(ImageChooseBean item) createTInstance,
    void Function({required List<TBean> addedMeidaBeans})?
        extraThingToAddedMeidaBeans, // 其他额外需要对所添加媒体处理的事情（图片压缩、视频帧获取等）
  }) async {
    logPickerUtil('PickUtil 03');

    // 新取消的图片
    if (newCancelImageChooseModels != null) {
      List<AssetEntity> shouldCancelAssetEntitys = [];
      for (var item in newCancelImageChooseModels) {
        if (item.assetEntity != null) {
          shouldCancelAssetEntitys.add(item.assetEntity!);
        }
      }

      List<TBean> shouldCancelTBeans = [];
      for (TBean item in currentImageChooseModels) {
        if (item.assetEntity != null &&
            shouldCancelAssetEntitys.contains(item.assetEntity)) {
          shouldCancelTBeans.add(item);
        }
      }

      currentImageChooseModels.removeWhere((element) {
        return shouldCancelTBeans.contains(element);
      });
    }

    // 新添加的图片
    if (newAddedImageChooseModels != null) {
      if (newAddedImageChooseModels.isNotEmpty) {
        List<TBean> addMeidaBeans = [];
        for (ImageChooseBean item in newAddedImageChooseModels) {
          TBean bean = createTInstance(item);
          addMeidaBeans.add(bean);
        }
        extraThingToAddedMeidaBeans?.call(addedMeidaBeans: addMeidaBeans);

        currentImageChooseModels.addAll(addMeidaBeans);
      }
    }

    logPickerUtil('PickUtil 04');
    // imageChooseModelsChange(isUpdateAction: false);
  }

  /// 图片/视频更新自身接口(目前使用于：'更换视频'按钮的点击)
  static pickedReplaceTo<TBean extends ImageChooseBean>(
    List<TBean> currentImageChooseModels,
    int mediaIndex, {
    required ImageChooseBean item,
    required TBean Function(ImageChooseBean item) createTInstance,
    void Function({required List<TBean> addedMeidaBeans})?
        extraThingToAddedMeidaBeans, // 其他额外需要对所添加媒体处理的事情（图片压缩、视频帧获取等）
  }) {
    TBean newBean = createTInstance(item);
    extraThingToAddedMeidaBeans?.call(addedMeidaBeans: [newBean]);

    currentImageChooseModels[mediaIndex] = newBean;
    // imageChooseModelsChange(isUpdateAction: true);
  }

  static logPickerUtil(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
