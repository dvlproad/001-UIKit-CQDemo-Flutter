import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import './bean/base_compress_bean.dart';

import 'get_image_info_util/asset_entity_info_getter.dart';
import 'get_image_info_util/image_provider_size_util.dart';

import 'image_compress_util/app_image_compress_util.dart';
import 'image_compress_util/app_video_compress_util.dart';

import 'image_compress_util/app_video_frame_util.dart';

mixin AssetEntityCompressProtocol {
  // 压缩的文件
  AssetEntity? compressAssetEntity;
  // 压缩进度
  CompressInfoProcess compressInfoProcess = CompressInfoProcess.none;

  // 压缩后的视频
  CompressResponseBean? videoCompressResponseBean;

  // 压缩后的视频缩略图
  CompressResponseBean? videoThumbResponseBean;

  // 压缩后的图片
  CompressResponseBean? imageCompressResponseBean;

  // 私有变量
  final Completer _compressCompleter = Completer<String>();

  // 选择完图片的时候就处理，避免进行上传的时候才去压缩导致时长增加
  Future<void> checkAndBeginCompress(AssetEntity assetEntity) async {
    _log("image choose bean hashCode111 = $hashCode");
    compressAssetEntity = assetEntity;

    // 已经开始异步压缩、异步请求压缩结果的宽高等时，直接返回(即使未结束，也慢慢等待)，防止重复创建
    if (compressInfoProcess != CompressInfoProcess.none) {
      return;
    }

    // 压缩前的准备：获取要压缩的文件
    File? file = await AssetEntityInfoGetter.getAssetEntityFile(assetEntity);
    if (file == null) {
      _log("要压缩的 file null 了");
      return;
    }

    compressInfoProcess = CompressInfoProcess.startCompress;
    if (assetEntity.type == AssetType.video) {
      // 如果选择的是视频
      int? videoDuration = assetEntity.duration; // milliseconds
      videoCompressResponseBean =
          await AppVideoCompressUtil.getCompressModel(file, videoDuration);

      // 视频缩略图
      videoThumbResponseBean =
          await AppVideoFrameUtil.getVideoThumbnailBean(file);
    } else {
      // 如果选择的是其它，则当成图片处理
      imageCompressResponseBean =
          await AppImageCompressUtil.getCompressModel(file);
    }

    if (!_compressCompleter.isCompleted) {
      _compressCompleter.complete('压缩:压缩完成，此时才可以进行上传压缩视频及其缩略图、或图片请求');
    }
    if (_compressCompleter.isCompleted != true) {
      _log('_compressCompleter.isCompleted');
    }
    compressInfoProcess = CompressInfoProcess.finishCompress;
  }

  // 选择完显示时候
  // 获取用于显示在列表上的图片
  ImageProvider? get compressedImageOrVideoThumbnailProvider {
    ImageProvider? imageProvider;

    if (imageCompressResponseBean != null &&
        imageCompressResponseBean!.reslut != null) {
      File resultCompressImageFile = imageCompressResponseBean!.reslut!;
      if (resultCompressImageFile.existsSync()) {
        Image image = Image.file(resultCompressImageFile);
        imageProvider = image.image;
        return imageProvider;
      }
    }

    if (videoThumbResponseBean != null &&
        videoThumbResponseBean!.reslut != null) {
      File resultVideoImageFile = videoThumbResponseBean!.reslut!;
      if (resultVideoImageFile.existsSync()) {
        Image image = Image.file(resultVideoImageFile);
        imageProvider = image.image;
        return imageProvider;
      }
    }

    return imageProvider;
  }

  // 获取最后要上传的图片的大小
  Future<Size?> get lastUploadCompressedImageOrVideoThumbnailSize async {
    ImageProvider? imageProvider = compressedImageOrVideoThumbnailProvider;
    if (imageProvider == null) {
      return null;
    }

    Size imageSize =
        await ImageProviderSizeUtil.getWidthAndHeight(imageProvider);
    return imageSize;
  }

  // 获取最后要上传的视频文件(会自动等待前面的压缩结束)
  Future<String?> lastUploadVideoSelfPath() async {
    // 草稿里的图片已有压缩数据
    if (compressInfoProcess == CompressInfoProcess.finishCompress) {
      File resultFile = videoCompressResponseBean?.reslut;
      return resultFile.path;
    }

    await _compressCompleter.future; // 优化压缩流程，上传时候未完成压缩会自动等待，并在完成压缩后，自动继续
    File resultFile = videoCompressResponseBean?.reslut;
    return resultFile.path;
  }

  // 获取最后要上传的视频帧图文件(会自动等待前面的压缩结束)
  Future<String?> lastUploadVideoFramePath() async {
    // 草稿里的图片已有压缩数据
    if (compressInfoProcess == CompressInfoProcess.finishCompress) {
      File resultFile = videoThumbResponseBean?.reslut;
      return resultFile.path;
    }

    await _compressCompleter.future; // 优化压缩流程，上传时候未完成压缩会自动等待，并在完成压缩后，自动继续
    File resultFile = videoThumbResponseBean?.reslut;
    return resultFile.path;
  }

  // 获取最后要上传的图片文件(会自动等待前面的压缩结束)
  Future<String?> lastUploadImagePath() async {
    _log("image choose bean hashCode = $hashCode");
    // 草稿里的图片已有压缩数据
    if (compressInfoProcess == CompressInfoProcess.finishCompress) {
      File resultFile = imageCompressResponseBean?.reslut;
      return resultFile.path;
    }

    await _compressCompleter.future; // 优化压缩流程，上传时候未完成压缩会自动等待，并在完成压缩后，自动继续
    File resultFile = imageCompressResponseBean?.reslut;
    return resultFile.path;
  }

  /// 日志
  void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
