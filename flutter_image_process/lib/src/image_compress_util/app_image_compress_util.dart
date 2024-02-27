/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 14:07:07
 * @Description: 图片压缩
 */

import 'dart:io' show File;

import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../bean/base_compress_bean.dart';
import '../path/app_compress_path_util.dart';

class AppImageCompressUtil {
  static Future<CompressResponseBean> getCompressModel(File imageFile) async {
    // 根据图片文件信息(大小)获取其压缩比(为100%时候，不用进行压缩)
    int compressImageQuality = _getCompressImageQuality(imageFile);
    if (compressImageQuality == 100) {
      return CompressResponseBean(
        message: '成功，因为100%不用压缩，所以使用了原图',
        type: CompressResultType.success_useOrigin,
        reslut: imageFile,
      );
    }

    // 计算图片/视频压缩后的存放路径
    String targetCompressFilePath =
        await AppCompressPathUtil.getTargetCompressPathForImageFile(
      imageFile,
      imageQulatity: compressImageQuality,
    );
    // 判断该路径文件是否已经存在，存在则代表压缩过，则不进行重复压缩
    File targetCompressFile = File(targetCompressFilePath);
    bool exists = await targetCompressFile.exists();
    if (exists) {
      // 缩略图之前已经创建，不需要重复创建
      return CompressResponseBean(
        message: "成功因为使用之前已经压缩的图片",
        type: CompressResultType.success_get_by_compressBefore,
        reslut: targetCompressFile,
      );
    }

    // 开始压缩图片
    File? resultFile = await compressFileAndReturnNewFile(
      imageFile,
      targetCompressFilePath,
    );
    if (resultFile == null) {
      return CompressResponseBean(
        message: "压缩失败，使用原图",
        type: CompressResultType.failure_get,
        reslut: null,
      );
    }

    return CompressResponseBean(
      message: "成功,因为获得了压缩图片",
      type: CompressResultType.success_get,
      reslut: resultFile,
    );
  }

  // 根据文件信息(大小)获取其压缩比
  // 方案1：压缩到指定大小内(推荐）
  // 压缩比=min(1, maxSize/fileSize)   // fileSize < maxSize 不压缩
  // 方案2：不限制大小都要对其本身进行一定比例的压缩
  // > 4M：50%
  // > 2M：60%
  // > 1M：70%
  // > 0.5M：80%
  // > 0.25M：90%
  static int _getCompressImageQuality(File file) {
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

  // 压缩file图片到指定的targetCompressPath路径，并返回得到的新File文件
  static Future<File?> compressFileAndReturnNewFile(
    File file,
    String targetCompressPath,
  ) async {
    debugPrint("testCompressAndGetFile");
    String filePath = file.absolute.path;
    // UploadMediaType mediaType = getMediaType(filePath);
    // if (mediaType == UploadMediaType.image) {
    String fileType = filePath.split('.').last;
    if (['jpg', 'jpeg', 'png'].contains(fileType)) {
      CompressFormat format =
          'png' == fileType ? CompressFormat.png : CompressFormat.jpeg;
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path, targetCompressPath,
          quality: 90,
          minWidth: 1024,
          minHeight: 1024,
          rotate: 0,
          format: format);

      if (result == null) return file;

      debugPrint("原图大小:${file.lengthSync()}");
      debugPrint("新图大小:${await result.length()}");
      File resultFile = File(result.path);
      if (resultFile.existsSync()) {
        return resultFile;
      }
      return file;
    } else {
      return file;
    }
  }
}
