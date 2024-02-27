/*
 * @Author: dvlproad
 * @Date: 2024-02-26 14:49:18
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-26 16:56:28
 * @Description: 
 */
import 'dart:io';

import 'package:flutter/foundation.dart';

import './base_append_path_extension.dart';
import './base_path_util.dart';

class AppCompressPathUtil {
  // 计算【图片】压缩后的压缩文件的完整实时路径
  static Future<String> getTargetCompressPathForImageFile(
    File file, {
    required int imageQulatity,
  }) async {
    String targetCompressPath = await _getTargetCompressPathForFile(
      file,
      compressDirName: "compressImage",
      compressFileNameGetBlock:
          (String folderPath, String fileName, String fileExtension) {
        String comprssFileName = "${fileName}_$imageQulatity.$fileExtension";
        return comprssFileName;
      },
    );
    return targetCompressPath;
  }

  // 计算【视频】压缩后的压缩文件的完整实时路径
  static Future<String> getTargetCompressPathForVideoFile(
    File file, {
    required String videoQulatity,
  }) async {
    String targetCompressPath = await _getTargetCompressPathForFile(
      file,
      compressDirName: "compressVideo",
      compressFileNameGetBlock:
          (String folderPath, String fileName, String fileExtension) {
        String comprssFileName = "${fileName}_$videoQulatity.$fileExtension";
        return comprssFileName;
      },
    );
    return targetCompressPath;
  }

  // 计算【视频缩略图】的路径
  static Future<String> getTargetThumbCompressPathForVideoFile(
    File file, {
    required double videoFramePosition,
    required int frameQuality,
  }) async {
    String targetCompressPath = await _getTargetCompressPathForFile(
      file,
      compressDirName: "video_thumb",
      compressFileNameGetBlock:
          (String folderPath, String fileName, String fileExtension) {
        String videoFramePositionString = _formatDuration(videoFramePosition);
        String comprssFileName =
            "${fileName}_${videoFramePositionString}_$frameQuality.$fileExtension";
        return comprssFileName;
      },
    );
    return targetCompressPath;
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

  // 计算【任意文件】的目标路径
  static Future<String> _getTargetCompressPathForFile(
    File file, {
    required String compressDirName,
    required String Function(
            String folderPath, String fileName, String fileExtension)
        compressFileNameGetBlock,
  }) async {
    // 1.1 压缩目录
    String dirPath = await BasePathUtil.getAppCompressDirPath(file);

    // 1.2 压缩目录的子目录
    String compressDirPath = dirPath.appendPathString(compressDirName);
    Directory compressDir = Directory(compressDirPath);
    bool exists = await compressDir.exists();
    if (!exists) {
      await compressDir.create();
    }

    // 2.1 获取文件名的各种信息（用于等下生成新的压缩文件名）
    String relativePath = BasePathUtil.getFieRelativePath(file);
    int lastSlashIndex = relativePath.lastIndexOf('/');
    String folderPath = relativePath.substring(0, lastSlashIndex);
    debugPrint('文件夹路径: $folderPath');
    int lastDotIndex = relativePath.lastIndexOf('.');
    String fileName = relativePath.substring(lastSlashIndex + 1, lastDotIndex);
    debugPrint('文件名: $fileName');
    String fileExtension = relativePath.substring(lastDotIndex + 1);
    debugPrint('文件扩展名: $fileExtension');

    // 2.2 压缩文件相对路径
    String comprssFileName =
        compressFileNameGetBlock(folderPath, fileName, fileExtension);
    String compressFileRelativePath =
        folderPath.appendPathString(comprssFileName);

    // 3 目标完整路径
    String targetCompressPath =
        compressDirPath.appendPathString(compressFileRelativePath);
    return targetCompressPath;
  }
}
