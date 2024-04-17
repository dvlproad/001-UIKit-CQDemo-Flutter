/*
 * @Author: dvlproad
 * @Date: 2024-03-29 12:57:58
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-29 15:12:03
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

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
