/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 22:06:35
 * @Description: 图片压缩
 */

import 'dart:math';
import 'dart:io' show File, Directory, Platform;
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
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
import 'package:flutter_network_base/src/url/appendPathExtension.dart';

class AssetEntityVideoThumbUtil {
  static Future<CompressResponseBean> getVideoComppressBean(
    File file,
    AssetEntity assetEntity,
  ) async {
    VideoCompressBean compressVideoBean = VideoCompressBean(
      originPath: file.path,
      compressInfoProcess: CompressInfoProcess.startCompress,
    );

    // 原始视频信息(大小、长度等)
    // final MediaInfo originMediaInfo =
    //     await VideoCompress.getMediaInfo(file.path);
    // int? originFilesize = originMediaInfo.filesize; // bytes
    // if (originFilesize != null) {
    /*
      if (originFilesize > 200 * 1000 * 1000) {
        // > 200M
        return CompressResponseBean(
          message: '失败,因为视频太大',
          type: CompressResultType.failure_tooBig,
          reslut: null,
        );
      }
      */
    // }
    int? videoDuration = assetEntity.duration; // milliseconds
    int position = -1;
    if (videoDuration != null) {
      if (videoDuration > 30 * 60) {
        // 30分钟
        return CompressResponseBean(
          message: '失败,因为视频太长',
          type: CompressResultType.failure_tooLong,
          reslut: null,
        );
      }
      if (videoDuration > 2) {
        position = 1; // 大于2秒的情况下取第一秒
      }
    }

    // MOV压缩失败，特殊处理
    bool shouldCompress = file.path.split('.').last.toLowerCase() == 'mov';
    shouldCompress = false; // 需求改为暂时都不用本地压缩
    if (shouldCompress != true) {
      compressVideoBean.compressPath = file.path;
      compressVideoBean.compressInfoProcess = CompressInfoProcess.finishAll;
      return CompressResponseBean(
        message: '成功,使用原视频',
        type: CompressResultType.success_useOrigin,
        reslut: compressVideoBean,
      );
    }

    // final MediaInfo? mediaInfo = await VideoCompress.compressVideo(
    //   file.path,
    //   quality: VideoQuality.MediumQuality,
    //   deleteOrigin: false,
    //   includeAudio: true,
    // ); // TODO: MOV压缩失败
    // if (mediaInfo == null) {
    //   // return CompressResponseBean(
    //   //   message: '失败',
    //   //   type: CompressResultType.failure_get,
    //   //   reslut: null,
    //   // );
    //   // final dir = await path_provider.getApplicationDocumentsDirectory();
    //   // final th = dir.path.appendPathString("VIDEO_COMPRESS").appendPathString(file.path.split("/").last);
    //   //
    //   // file.copy()
    //   compressVideoBean.compressPath = file.path;
    //   compressVideoBean.compressInfoProcess = CompressInfoProcess.finishAll;
    //   return CompressResponseBean(
    //     message: '成功,使用原视频',
    //     type: CompressResultType.success_useOrigin,
    //     reslut: compressVideoBean,
    //   );
    // }
    compressVideoBean.compressPath = file.path;
    compressVideoBean.compressInfoProcess = CompressInfoProcess.finishAll;

    return CompressResponseBean(
      message: '成功,并获取到了视频',
      type: CompressResultType.success_get,
      reslut: compressVideoBean,
    );
  }

  static Future<ImageCompressBean?> getVideoThumbnailBean(
    File file, {
    int quality = 100,
    double position = -1,
  }) async {
    return getVideoFrameBean(file, quality: quality, position: position);
  }

  static Future<ImageCompressBean?> getVideoFrameBean(
    File file, {
    int quality = 100,
    double position = -1,
    bool needCopy = false, // 是否保留之前已获取的视频帧，(默认视频只取一个帧后续都是覆盖)
  }) async {
    ImageCompressBean compressImageBean = ImageCompressBean(
      originPathOrUrl: '', // file.path 是视频路径,视频缩略图没有没有地址,设为''
      compressInfoProcess: CompressInfoProcess.startCompress,
    );

    // 获取图片文件及其压缩比(为100%时候，不用进行压缩)
    // int compressQuality = _getCompressQuality(file);

    // 获取视频缩略图并进行压缩，最后获取最终的图片路径
    /* // 方法一：只能是系统相册中的那张，而且安卓的视频缩略图会因为channel问题，获取失败
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
    */
    // 创建文件夹
    Directory tempDir = await getTemporaryDirectory();
    var videoThumbDir = Directory(tempDir.path + "/" + "video_thumb");
    if (!videoThumbDir.existsSync()) {
      debugPrint(
          'getVideoThumbFrameList 文件夹不存在，准备创建：${tempDir.path + "/" + "video_thumb"}');
      videoThumbDir.createSync();
    }

    String tempPath = videoThumbDir.path;

    // 图片保存路径
    var pathTag = file.path
        .substring(file.path.lastIndexOf('/') + 1, file.path.lastIndexOf('.'));
    var formatDuration = _formatDuration(position);
    var savePath =
        "$tempPath/${pathTag.replaceAll(".", "_")}_${formatDuration.replaceAll(":", "_").replaceAll(".", "_")}.jpg";

    File thumbFile = File(savePath);
    if (!thumbFile.existsSync()) {
      DateTime start = DateTime.now();
      debugPrint('缩略图不存在，准备创建');
      await VideoThumbnail.thumbnailFile(
        video: file.path,
        imageFormat: ImageFormat.JPEG,
        thumbnailPath: savePath,
        timeMs: (position * 1000).toInt(),
        quality: 100,
      );
      DateTime end = DateTime.now();
      debugPrint(
          '缩略图创建完毕，耗时:${end.difference(start).inMilliseconds},文件存放路径：$savePath');
    } else {
      debugPrint('缩略图已存在，不用创建，文件存放路径：$savePath');
    }
    // var oldFile = File(thumbPath!);
    // thumbFile.createSync();
    // thumbFile.writeAsBytesSync(oldFile.readAsBytesSync());
    // var commend = "-ss $formatDuration -i ${file.path} -q:v 4 -vframes 1 $savePath";
    // var session = await FFmpegKit.execute(commend);
    // final runTime = await session.getDuration();
    // debugPrint("FFmpeg:${session.getCommand()}\n视频帧提取完毕,用时$runTime毫秒");

    compressImageBean.compressPath = savePath;
    compressImageBean.compressInfoProcess = CompressInfoProcess.finishCompress;
    // 获取压缩图片的宽高
    Map<String, dynamic> imageWithHeight =
        await GetImageInfoUtil.getImageWidthAndHeight(savePath);
    int imageWidth = imageWithHeight["width"];
    int imageHeight = imageWithHeight["height"];
    compressImageBean.width = imageWidth;
    compressImageBean.height = imageHeight;
    compressImageBean.compressInfoProcess = CompressInfoProcess.finishAll;

    return compressImageBean;
  }

  static Future<List<ImageCompressBean>> getVideoFrameBeans(
    File file, {
    AssetEntity? assetEntity,
    int maxFrameCount = 10,
  }) async {
    double? videoDuration;
    if (assetEntity != null) {
      videoDuration = assetEntity.videoDuration.inMilliseconds / 1000;
    } else {
      final MediaInfo originMediaInfo =
          await VideoCompress.getMediaInfo(file.path);
      videoDuration = originMediaInfo.duration! / 1000; // milliseconds
    }
    debugPrint('视频时长：$videoDuration');
    List<double> framePositions = [];
    if (videoDuration == null) {
      framePositions = [-1];
    } else {
      // double frameCount = min(originDurationSecond, maxFrameCount.toDouble());
      // 视频多少秒取一帧
      double positionSpace = videoDuration / max(1, (maxFrameCount - 1));
      for (var i = 0; i < maxFrameCount; i++) {
        double position = min(
            positionSpace * i, videoDuration - 0.1); // 防止失败 最后一张取视频时长-0.1秒的位置
        framePositions.add(position);
      }
    }
    // int videoFrameCount = framePositions.length;

    List<ImageCompressBean> beans = [];
    // for (var i = 0; i < 5; i++) {
    for (var position in framePositions) {
      ImageCompressBean? bean = await getVideoFrameBean(
        file,
        position: position,
        needCopy: true,
      );
      if (bean != null) {
        beans.add(bean);
      }

      // if (i < videoFrameCount - 1) {
      //   // 异步压缩，并且不是最后一个时候,每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃
      //   await Future.delayed(Duration(milliseconds: 500));
      // }
    }

    return beans;
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

  static String _formatDuration(double time) {
    Duration duration = Duration(milliseconds: (time * 1000).toInt());
    // 返回此持续时间跨越的整秒数。
    String inSeconds = (duration.inSeconds % 60).toString().padLeft(2, "0");
    // 返回此持续时间跨越的整分钟数。
    String inMinutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String inHours = duration.inHours.toString().padLeft(2, '0');
    String milliseconds = (duration.inMilliseconds % 1000).toString();
    return "$inHours:$inMinutes:$inSeconds.$milliseconds";
  }
}
