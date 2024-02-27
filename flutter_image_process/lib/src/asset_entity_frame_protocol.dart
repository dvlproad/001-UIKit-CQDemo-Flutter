/*
 * @Author: dvlproad
 * @Date: 2024-02-27 11:20:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 13:55:06
 * @Description: 视频帧获取(用于选封面)--不需要阻塞，可以进去页面之后异步渲染，不同于压缩上传需要压缩完才可以上传
 */
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

import 'bean/base_compress_bean.dart';
import 'image_compress_util/app_video_frame_util.dart';
import 'get_image_info_util/asset_entity_info_getter.dart';

mixin AssetEntityFrameProtocol {
  List<CompressResponseBean>? _videoFrameBeans;
  List<CompressResponseBean>? get videoFrameBeans => _videoFrameBeans;
  set videoFrameBeans(List<CompressResponseBean>? values) {
    _videoFrameBeans = values;
  }

  bool isGettingVideoFrames = false;
  // final Completer _videoFramesCompleter = Completer<String>();
  Future<void> checkAndBeginGetAssetEntityVideoFrames(
      AssetEntity assetEntity) async {
    _log("image choose bean hashCode111 = $hashCode");

    if (_videoFrameBeans != null) {
      // 之前已经截好帧图了
      return;
    }

    // 检查是否可以截取帧(是否是视频文件、文件是否空)
    if (assetEntity.type != AssetType.video) {
      return;
    }

    File? videoFile =
        await AssetEntityInfoGetter.getAssetEntityFile(assetEntity);
    if (videoFile == null) {
      _log("file null 了");
      return;
    }

    try {
      _log("视频帧:获取视频帧列表开始");
      isGettingVideoFrames = true;
      _videoFrameBeans = await AppVideoFrameUtil.getVideoFrameBeans(
        videoFile,
        videoDuration: assetEntity.duration,
        maxFrameCount: 6, // 因为编辑视频帧时，最多只能显示6张视频帧
      );
      isGettingVideoFrames = false;
      _log("视频帧:获取视频帧列表完成");
    } catch (err) {
      _log("Error:获取视频帧列表失败");
    }

    /*
    _videoFramesCompleter.complete('视频帧列表:获取视频帧列表完成，视频帧获取(用于选封面)--不需要阻塞，可以进去页面之后异步渲染，不同于压缩上传需要压缩完才可以上传');
    if (_videoFramesCompleter.isCompleted != true) {
      _log('_compressCompleter.isCompleted');
    }
    */
  }

  /// 日志
  void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
