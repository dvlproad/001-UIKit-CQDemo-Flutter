/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 12:02:12
 * @Description: 图片压缩
 */

import 'dart:io' show File, Directory;
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
// import 'package:flutter_network_base/flutter_network_base.dart';

class BaseImageCompressUtil {
  static Future<String> getFileTargetPath(File file) async {
    Directory dir = await path_provider.getTemporaryDirectory();
    String dirPath = dir.absolute.path;
    const String appImageRelativeDir = "localImage";
    final String appImageDirPath =
        dirPath.appendPathString(appImageRelativeDir);
    var appImageDir = Directory(appImageDirPath);
    try {
      bool exists = await appImageDir.exists();
      if (!exists) {
        await appImageDir.create();
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    String fileRelativePath = getFileTargetRelativePath(file);
    final targetPath = dirPath.appendPathString(fileRelativePath);
    return targetPath;
  }

  static String getFileTargetRelativePath(File file) {
    const String appImageRelativeDir = "localImage";

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
    debugPrint("testCompressAndGetFile");
    String filePath = file.absolute.path;
    // UploadMediaType mediaType = getMediaType(filePath);
    // if (mediaType == UploadMediaType.image) {
    String fileType = filePath.split('.').last;
    if (['jpg', 'jpeg', 'png'].contains(fileType)) {
      CompressFormat format =
          'png' == fileType ? CompressFormat.png : CompressFormat.jpeg;
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetCompressPath,
          quality: 90,
          minWidth: 1024,
          minHeight: 1024,
          rotate: 0,
          format: format
      );

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

extension PathStringAppendExtension on String {
  String appendPathString(String appendPath) {
    String noslashThis; // 没带斜杠的 api host
    if (endsWith('/')) {
      noslashThis = substring(0, length - 1);
    } else {
      noslashThis = this;
    }

    String hasslashAppendPath; // 带有斜杠的 appendPath
    if (appendPath.startsWith('/')) {
      hasslashAppendPath = appendPath;
    } else {
      hasslashAppendPath = '/$appendPath';
    }

    String newPath = noslashThis + hasslashAppendPath;
    return newPath;
  }
}
