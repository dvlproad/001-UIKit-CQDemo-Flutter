// ignore_for_file: unused_import, unnecessary_import

/*
 * @Author: dvlproad
 * @Date: 2022-08-11 19:18:21
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 14:18:05
 * @Description: 
 */
import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:photo_manager/photo_manager.dart' show AssetType;

import './widget/image_or_photo_grid_cell.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';

import 'package:app_network/app_network.dart'
    show AppNetworkManager, UploadApiUtil, UploadMediaResultType;

class ImageCheckUtil {
  /// 检查所添加的文件是否可以使用(是否太长，是否太大)
  static Future<bool> checkMediaBeans<T extends ImageChooseBean>(
    List<T> addMeidaBeans,
  ) async {
    int count = addMeidaBeans.length;
    for (var i = 0; i < count; i++) {
      T bean = addMeidaBeans[i];
      if (await _checkChooseMediaResult(bean) != true) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> _checkChooseMediaResult<T extends ImageChooseBean>(
    T bean,
  ) async {
    if (bean.assetEntity != null) {
      if (bean.assetEntity!.type == AssetType.video) {
        File? videoFile =
            await AssetEntityInfoGetter.getAssetEntityFile(bean.assetEntity!);
        if (videoFile == null) {
          _log("file null 了");
          return true;
        }

        VideoCheckResponseBean checkResponseBean =
            await AssetEntityVideoCheckUtil.getVideoCheckResponseBean(
                videoFile);
        if (checkResponseBean.type != VideoCheckResultType.success) {
          ToastUtil.showMessage(checkResponseBean.message, duration: 2);
          return false;
        }
      }
    }

    return true;
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
