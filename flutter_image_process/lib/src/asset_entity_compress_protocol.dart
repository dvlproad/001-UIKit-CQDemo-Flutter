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

  /// 是否执行过压缩
  bool get _beenExecCompress {
    if (compressAssetEntity == null) {
      debugPrint("该资源不是来源于相册(即可能是网络)，不曾进行过压缩");
      return false;
    }
    return true;
  }

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
  // 如果有压缩，获取可用于显示在列表上的压缩图片数据
  ImageProvider? get currentCompressedImageOrVideoThumbnailProvider {
    if (!_beenExecCompress) return null;

    File? resultFile;
    if (compressAssetEntity!.type == AssetType.video) {
      // 如果是视频
      if (currentVideoFrameFile != null &&
          currentVideoFrameFile!.existsSync()) {
        resultFile = currentVideoFrameFile;
      }
    } else {
      // 如果是图片
      if (currentImageCompressFile != null &&
          currentImageCompressFile!.existsSync()) {
        resultFile = currentImageCompressFile;
      }
    }

    if (resultFile == null) {
      return null;
    }

    Image image = Image.file(resultFile);
    ImageProvider imageProvider = image.image;
    return imageProvider;
  }

  // 获取最后要上传的图片的大小
  Future<Size?> get lastUploadCompressedImageOrVideoThumbnailSize async {
    ImageProvider? imageProvider =
        currentCompressedImageOrVideoThumbnailProvider;
    if (imageProvider == null) {
      return null;
    }

    Size imageSize =
        await ImageProviderSizeUtil.getWidthAndHeight(imageProvider);
    return imageSize;
  }

  /// 如果有压缩，当前(不一定压缩完)视频的压缩文件
  File? get currentVideoCompressFile {
    if (!_beenExecCompress) return null;

    File? resultFile = videoCompressResponseBean?.reslut;
    return resultFile;
  }

  /// 如果有压缩，当前(不一定压缩完)视频的压缩帧文件
  File? get currentVideoFrameFile {
    if (!_beenExecCompress) return null;

    File? resultFile = videoThumbResponseBean?.reslut;
    return resultFile;
  }

  /// 如果有压缩，当前(不一定压缩完)图片的压缩文件
  File? get currentImageCompressFile {
    if (!_beenExecCompress) return null;

    File? resultFile = imageCompressResponseBean?.reslut;
    return resultFile;
  }

  // 获取最后要上传的视频文件(会自动等待前面的压缩结束)
  Future<String?> lastUploadVideoSelfPath() async {
    if (!_beenExecCompress) return null;

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
    if (!_beenExecCompress) return null;

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
    if (!_beenExecCompress) return null;

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
