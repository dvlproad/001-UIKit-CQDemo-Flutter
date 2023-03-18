/*
 * @Author: dvlproad
 * @Date: 2022-08-30 15:50:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 13:13:43
 * @Description: 
 */
import 'dart:io' show File;
import 'dart:async';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import './widget/image_or_photo_grid_cell.dart';
import 'package:flutter_image_process/flutter_image_process.dart';

import './images_add_cell.dart';
export './images_add_cell.dart' show AddCellType;

import './preview/preview_util.dart';

import 'package:app_network/app_network.dart';

enum UploadFileType {
  medias, // 上传文件
  coverImage, // 上传封面
}

class MediaListUploadUtil {
  /// 列表中的所有资源上传
  ///
  /// autoShowToastWhenError:失败的情况下，内部是否自动弹 toast
  static Future<bool> uploadMediasAndCover({
    required List<AppImageChooseBean> imageChooseModels,
    required PickPhotoAllowType pickAllowType,
    required bool multipart,
    ImageChooseBean? coverImageChooseModel, // 封面
    bool autoShowToastWhenError = true,
    void Function({
      required UploadFileType uploadFileType,
      required double totalProgressValue, // 总的下载进度
    })?
        uploadProgress,
    void Function()? uploadSuccess,
    void Function(UploadMediaResultType errorResultType)? uploadFailure,
  }) async {
    bool mediaUploadSuccess = await MediaListUploadUtil.upload(
      multipart: multipart,
      imageChooseModels: imageChooseModels,
      pickAllowType: pickAllowType,
      autoShowToastWhenError: autoShowToastWhenError,
      uploadProgress: ({
        required int failureUploadNumber,
        required int needUploadNumber,
        required int successUploadNum,
        required double totalProgressValue,
      }) {
        if (uploadProgress != null) {
          uploadProgress(
            uploadFileType: UploadFileType.medias,
            totalProgressValue: totalProgressValue,
          );
        }
      },
      uploadSuccess: uploadSuccess,
      uploadFailure: uploadFailure,
    );

    if (!mediaUploadSuccess) {
      return false;
    }

    return MediaListUploadUtil.checkAndUploadCoverImage(
      multipart: multipart,
      coverImageChooseModel: coverImageChooseModel,
      autoShowToastWhenError: autoShowToastWhenError,
      uploadProgress: ({
        required int failureUploadNumber,
        required int needUploadNumber,
        required int successUploadNum,
        required double totalProgressValue,
      }) {
        if (uploadProgress != null) {
          uploadProgress(
            uploadFileType: UploadFileType.coverImage,
            totalProgressValue: totalProgressValue,
          );
        }
      },
      uploadSuccess: uploadSuccess,
      uploadFailure: uploadFailure,
    );
  }

  /// 列表中的所有资源上传
  ///
  /// autoShowToastWhenError:失败的情况下，内部是否自动弹 toast
  static Future<bool> upload({
    required bool multipart,
    required List<AppImageChooseBean> imageChooseModels,
    required PickPhotoAllowType pickAllowType,
    bool autoShowToastWhenError = true,
    void Function({
      required double totalProgressValue, // 总的下载进度
      required int needUploadNumber, // 需要上传的个数
      required int successUploadNum, // 已成功上传的个数
      required int failureUploadNumber, // 失败的个数
    })?
        uploadProgress,
    void Function()? uploadSuccess,
    void Function(UploadMediaResultType errorResultType)? uploadFailure,
  }) async {
    if (imageChooseModels != null) {
      UploadMediaType mediaType = UploadMediaType.image;
      if (pickAllowType == PickPhotoAllowType.videoOnly) {
        mediaType = UploadMediaType.video;
        _log("==============视频上传开始，请等待");
      } else {
        _log("==============图片上传开始，请等待");
      }
      UploadMediaResultType uploadMediaResultType =
          await UploadApiUtil.uploadImageChooseModelsByCallBack(
        multipart: multipart,
        imageChooseModels: imageChooseModels,
        mediaType: mediaType,
        uploadProgress: uploadProgress,
        uploadSuccess: uploadSuccess,
        uploadFailure: uploadFailure,
      );

      if (uploadMediaResultType == UploadMediaResultType.UploadSuccess) {
        _log("==============图片/视频上传完毕，继续上传语音/开始发布");
      } else {
        if (autoShowToastWhenError == true) {
          String errorString = UploadApiUtil.getUploadMediaResultTypeString(
              uploadMediaResultType);
          // ToastUtil.showMessage(errorString);
        }
        return false;
      }
    }

    return true;
  }

  /// 列表中的所有资源上传
  ///
  /// autoShowToastWhenError:失败的情况下，内部是否自动弹 toast
  static Future<bool> checkAndUploadCoverImage({
    required bool multipart,
    ImageChooseBean? coverImageChooseModel, // 封面
    bool autoShowToastWhenError = true,
    void Function({
      required double totalProgressValue, // 总的下载进度
      required int needUploadNumber, // 需要上传的个数
      required int successUploadNum, // 已成功上传的个数
      required int failureUploadNumber, // 失败的个数
    })?
        uploadProgress,
    void Function()? uploadSuccess,
    void Function(UploadMediaResultType errorResultType)? uploadFailure,
  }) async {
    if (coverImageChooseModel == null) {
      return true;
    }

    _log("==============封面上传开始，请等待");
    UploadMediaResultType uploadMediaResultType =
        await UploadApiUtil.uploadImageChooseModelsByCallBack(
      multipart: multipart,
      imageChooseModels: [coverImageChooseModel],
      mediaType: UploadMediaType.image,
      uploadProgress: uploadProgress,
      uploadSuccess: uploadSuccess,
      uploadFailure: uploadFailure,
    );

    if (uploadMediaResultType == UploadMediaResultType.UploadSuccess) {
      _log("==============封面上传完毕，继续上传语音/开始发布");
      return true;
    } else {
      if (autoShowToastWhenError == true) {
        String errorString =
            UploadApiUtil.getUploadMediaResultTypeString(uploadMediaResultType);
        ToastUtil.showMessage(errorString);
      }
      return false;
    }
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
