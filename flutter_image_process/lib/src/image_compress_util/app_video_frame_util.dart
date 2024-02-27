// ignore_for_file: unused_element

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 10:19:23
 * @Description: 图片压缩
 */

import 'dart:math';
import 'dart:io' show File;
import 'package:flutter/foundation.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../bean/base_compress_bean.dart';
import '../path/app_compress_path_util.dart';

class AppVideoFrameUtil {
  // 获取视频缩略图，通过视频帧
  static Future<CompressResponseBean> getVideoThumbnailBean(
    File videoFile,
  ) async {
    return getVideoFrameBean(videoFile, framePosition: -1, frameQuality: 100);
  }

  static Future<List<CompressResponseBean>> getVideoFrameBeans(
    File file, {
    required int videoDuration,
    int maxFrameCount = 10,
  }) async {
    debugPrint('视频时长：$videoDuration');
    List<double> framePositions = [];
    if (videoDuration <= 0) {
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

    List<CompressResponseBean> beans = [];
    // for (var i = 0; i < 5; i++) {
    for (var position in framePositions) {
      CompressResponseBean bean = await getVideoFrameBean(
        file,
        framePosition: position,
        needCopy: true,
      );
      beans.add(bean);

      // if (i < videoFrameCount - 1) {
      //   // 异步压缩，并且不是最后一个时候,每个压缩间隔一下,防止内存还没释放,导致积累过多崩溃
      //   await Future.delayed(Duration(milliseconds: 500));
      // }
    }

    return beans;
  }

  // 获取指定位置的帧图(包含对该帧图进行指定质量的压缩)
  static Future<CompressResponseBean> getVideoFrameBean(
    File videoFile, {
    double framePosition = -1,
    int frameQuality = 100,
    bool needCopy = false, // 是否保留之前已获取的视频帧，(默认视频只取一个帧后续都是覆盖)
  }) async {
    // 计算视频缩略图的存放路径(获取的时候同时包含压缩)
    String targetFilePath =
        await AppCompressPathUtil.getTargetThumbCompressPathForVideoFile(
      videoFile,
      videoFramePosition: framePosition,
      frameQuality: frameQuality,
    );
    // 判断该路径文件是否已经存在，存在则代表获取过，则不进行重复获取
    File targetFile = File(targetFilePath);
    bool exists = await targetFile.exists();
    if (exists) {
      // 缩略图之前已经创建，不需要重复创建
      return CompressResponseBean(
        message: "成功，因为使用之前已经获取的视频帧图",
        type: CompressResultType.success_get_by_compressBefore,
        reslut: targetFile,
      );
    }

    // 开始获取视频帧图片
    String? resultFilePath = await VideoThumbnail.thumbnailFile(
      video: videoFile.path,
      imageFormat: ImageFormat.JPEG,
      thumbnailPath: targetFilePath,
      timeMs: (framePosition * 1000).toInt(),
      quality: frameQuality,
    );

    if (resultFilePath == null) {
      return CompressResponseBean(
        message: "帧获取失败，使用占位图",
        type: CompressResultType.failure_get,
        reslut: null,
      );
    }

    return CompressResponseBean(
      message: "成功,因为获得了压缩图片",
      type: CompressResultType.success_get,
      reslut: File(resultFilePath),
    );
  }
}
