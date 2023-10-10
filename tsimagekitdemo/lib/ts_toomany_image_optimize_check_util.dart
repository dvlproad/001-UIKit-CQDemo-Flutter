/*
 * @Author: dvlproad
 * @Date: 2023-09-25 10:31:10
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-25 11:54:05
 * @Description: 优化检查
 */
import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:extended_image_library/extended_image_library.dart';

import 'ts_toomany_image_data_vientiane.dart';
import 'ts_toomany_image_download_util.dart';

class TSTooManyImageOptimizeCheckUtil {
  /// 计算图片的查找时长
  static checkImageFindDuration() async {
    String foundImageUrl = TSTooManyImageDataVientiane.newImageUrl(
        TSTooManyImageDownloadUtil.vientianeImageUrl,
        width: 6600);
    getNetworkImageData(foundImageUrl);
    int foundDuration =
        await TSTooManyImageOptimizeCheckUtil.calculateFindDuration(
            foundImageUrl);
    debugPrint("$foundImageUrl 的查找时间为:$foundDuration");
  }

  /// get md5 from key
  static String keyToMd5(String key) =>
      md5.convert(utf8.encode(key)).toString();

  /// 获取网络图片最后的本地存储文件夹路径
  static Future<String> getLastDirPath(String imageUrl,
      {bool? useSubDir}) async {
    Directory cacheDir = await getTemporaryDirectory();
    String imageCacheHomeDirPath = join(cacheDir.path, cacheImageFolderName);

    if (useSubDir != true) {
      // 不使用子目录，直接一个文件夹存放
      return imageCacheHomeDirPath;
    }

    String subDirHome = keyToMd5(imageUrl);
    String imageCacheSubDirName = subDirHome.substring(0, 1);
    String lastDirPath = "$imageCacheHomeDirPath/$imageCacheSubDirName";
    return lastDirPath;
  }

  /// 计算图片文件的查找耗时(查找失败返回-1)
  static Future<int> calculateFindDuration(String imageUrl,
      {bool? useSubDir}) async {
    String md5Key = keyToMd5(imageUrl);
    final String lastDirPath =
        await getLastDirPath(imageUrl, useSubDir: useSubDir);

    final Directory cacheImagesDirectory = Directory(lastDirPath);

    int foundStartTime = DateTime.now().millisecondsSinceEpoch;
    // exist, try to find cache image file
    if (cacheImagesDirectory.existsSync()) {
      /// existsSync同步方法，检查该路径的文件夹是否存在
      final File cacheFlie = File(join(cacheImagesDirectory.path, md5Key));
      if (cacheFlie.existsSync()) {
        /// existsSync同步方法，检查该路径的文件是否存在
        int foundEndTime = DateTime.now().millisecondsSinceEpoch;
        int foundDuration = foundEndTime - foundStartTime;
        return foundDuration;
      }
    }

    return -1;
  }
}
