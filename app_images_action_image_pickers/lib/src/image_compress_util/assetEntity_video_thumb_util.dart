/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-05 18:17:35
 * @Description: 图片压缩
 */

import 'dart:io' show File, Directory;
import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:video_compress/video_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;
import '../bean/video_compress_bean.dart';
import '../bean/image_compress_bean.dart';
import '../bean/base_compress_bean.dart';
import '../bean/image_info_bean.dart';
import './base_image_compress_util.dart';
import '../get_image_info_util/get_image_info_util.dart';
import './assetEntity_info_getter.dart';

class AssetEntityVideoThumbUtil {
  static Future<VideoCompressBean> getVideoComppressBean(
    File file,
  ) async {
    VideoCompressBean compressVideoBean = VideoCompressBean(
      originPath: file.path,
      compressInfoProcess: CompressInfoProcess.startCompress,
    );
    // final MediaInfo mediaInfo = await VideoCompress.compressVideo(
    //   file.path,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,
    // );

    // compressVideoBean.compressPath = mediaInfo.path;
    compressVideoBean.compressPath = file.path;
    compressVideoBean.compressInfoProcess = CompressInfoProcess.finishAll;

    return compressVideoBean;
  }

  static Future<ImageCompressBean?> getVideoThumbnailBean(
    File file,
  ) async {
    ImageCompressBean compressImageBean = ImageCompressBean(
      originPathOrUrl: file.path,
      compressInfoProcess: CompressInfoProcess.startCompress,
    );

    // 获取图片文件及其压缩比(为100%时候，不用进行压缩)
    // int compressQuality = _getCompressQuality(file);

    // 获取视频缩略图并进行压缩，最后获取最终的图片路径
    String? newThumbnailPath = await VideoThumbnail.thumbnailFile(
      video: file.path,
      thumbnailPath: null,
      // imageFormat: ImageFormat.WEBP,
      // maxHeight: 64,
      // quality: 75,
    );

    if (newThumbnailPath == null) {
      return null; // 获取缩略图失败
    }

    compressImageBean.compressPath = newThumbnailPath;
    compressImageBean.compressInfoProcess = CompressInfoProcess.finishCompress;
    // 获取压缩图片的宽高
    Map<String, dynamic> imageWithHeight =
        await GetImageInfoUtil.getImageWidthAndHeight(newThumbnailPath);
    int imageWidth = imageWithHeight["width"];
    int imageHeight = imageWithHeight["height"];
    compressImageBean.width = imageWidth;
    compressImageBean.height = imageHeight;
    compressImageBean.compressInfoProcess = CompressInfoProcess.finishAll;

    return compressImageBean;
  }

  static int _getCompressQuality(File file) {
    var quality = 100;
    int fileLength = file.lengthSync();
    if (fileLength > 4 * 1024 * 1024) {
      quality = 50;
    } else if (fileLength > 2 * 1024 * 1024) {
      quality = 60;
    } else if (fileLength > 1 * 1024 * 1024) {
      quality = 70;
    } else if (fileLength > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (fileLength > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    return quality;
  }
}
