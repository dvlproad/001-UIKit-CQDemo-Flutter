/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:17:13
 * @Description: 图片压缩
 */

import 'dart:io' show File, Directory;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:flutter_network/src/url/appendPathExtension.dart';

class BaseImageCompressUtil {
  static Future<String> getFileTargetPath(File file) async {
    Directory dir = await path_provider.getTemporaryDirectory();
    String dirPath = dir.absolute.path;
    final String appImageRelativeDir = "localImage";
    final String appImageDirPath = dirPath.appendPathString(appImageRelativeDir);
    var appImageDir = Directory(appImageDirPath);
    try {
      bool exists = await appImageDir.exists();
      if (!exists) {
        await appImageDir.create();
      }
    } catch (e) {
      print(e);
    }

    String fileRelativePath = getFileTargetRelativePath(file);
    final targetPath = dirPath.appendPathString(fileRelativePath);
    return targetPath;
  }

  static String getFileTargetRelativePath(File file) {
    final String appImageRelativeDir = "localImage";

    List<String> filePathComponents = file.path.split("/");
    String fileName = filePathComponents.last;
    final fileRelativePath = appImageRelativeDir.appendPathString(fileName);
    return fileRelativePath;
  }

  // 压缩file图片到指定的targetCompressPath路径，并返回得到的新File文件
  static Future<File?> compressFileAndReturnNewFile(
    File file,
    String targetCompressPath,
  ) async {
    print("testCompressAndGetFile");
    String filePath = file.absolute.path;
    // UploadMediaType mediaType = getMediaType(filePath);
    // if (mediaType == UploadMediaType.image) {
    String fileType = filePath.split('.').last;
    if (['jpg', 'jpeg', 'png'].contains(fileType)) {
      final File? result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetCompressPath,
        quality: 90,
        minWidth: 1024,
        minHeight: 1024,
        rotate: 0,
      );

      print("原图大小:${file.lengthSync()}");
      print("新图大小:${result?.lengthSync() ?? 0}");

      return result;
    } else {
      return file;
    }
  }
}
