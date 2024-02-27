/*
 * @Author: dvlproad
 * @Date: 2024-02-26 14:53:51
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-26 15:08:36
 * @Description: 
 */
import 'dart:io';
import 'package:path_provider/path_provider.dart' as path_provider;

import './base_append_path_extension.dart';

class BasePathUtil {
  // 获取相对路径（适配app重启后目录变化）
  static String getFieRelativePath(File file) {
    const String appImageRelativeDir = "localImage";

    List<String> filePathComponents = file.path.split("/");
    String fileName = filePathComponents.last;
    final fileRelativePath = appImageRelativeDir.appendPathString(fileName);
    return fileRelativePath;
  }

  // 获取app实时根目录
  static Future<String> getAppCompressDirPath(File file) async {
    Directory dir = await path_provider.getTemporaryDirectory();
    String dirPath = dir.absolute.path;
    return dirPath;
  }
}
