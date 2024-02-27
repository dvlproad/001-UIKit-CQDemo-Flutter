// ignore_for_file: unused_element

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-26 16:20:57
 * @Description: 图片压缩
 */

import 'dart:io' show File;
import 'package:video_compress/video_compress.dart';

import '../bean/base_compress_bean.dart';
import '../path/app_compress_path_util.dart';

class AppVideoCompressUtil {
  // 获取指定【视频文件】的压缩文件
  static Future<CompressResponseBean> getCompressModel(
    File videoFile,
    int videoDuration,
  ) async {
    // 根据视频文件信息(格式、大小)获取其压缩比(
    // ①格式MOV使用 VideoCompress 会压缩失败，所以需要特殊处理；
    // ②超过30分钟时候，不用进行压缩)
    bool shouldCompress = videoFile.path.split('.').last.toLowerCase() == 'mov';
    // shouldCompress = false; // 需求改为暂时都不用本地压缩
    if (shouldCompress != true) {
      return CompressResponseBean(
        message: '成功，因为mov不用压缩，所以使用了原视频',
        type: CompressResultType.success_useOrigin,
        reslut: videoFile,
      );
    }
    if (videoDuration > 30 * 60) {
      return CompressResponseBean(
        message: '失败,因为视频太长超过30分钟',
        type: CompressResultType.failure_tooLong,
        reslut: null,
      );
    }

    // 计算图片/视频压缩后的存放路径
    String targetCompressFilePath =
        await AppCompressPathUtil.getTargetCompressPathForVideoFile(
      videoFile,
      videoQulatity: "medium",
    );
    // 判断该路径文件是否已经存在，存在则代表压缩过，则不进行重复压缩
    File targetCompressFile = File(targetCompressFilePath);
    bool exists = await targetCompressFile.exists();
    if (exists) {
      // 压缩的视频之前已经创建，不需要重复创建
      return CompressResponseBean(
        message: "成功因为使用之前已经压缩的视频",
        type: CompressResultType.success_get_by_compressBefore,
        reslut: targetCompressFile,
      );
    }

    // 开始压缩视频
    final MediaInfo? resultMediaInfo = await VideoCompress.compressVideo(
      videoFile.path,
      quality: VideoQuality.MediumQuality,
      deleteOrigin: false,
      includeAudio: true,
    ); // TODO: MOV压缩失败
    if (resultMediaInfo == null) {
      return CompressResponseBean(
        message: '失败，非mov的视频文件也压缩失败，使用原视频',
        type: CompressResultType.failure_get,
        reslut: null,
      );
    }

    return CompressResponseBean(
      message: '成功,因为获得了压缩视频',
      type: CompressResultType.success_get,
      reslut: resultMediaInfo.file,
    );
  }
}
