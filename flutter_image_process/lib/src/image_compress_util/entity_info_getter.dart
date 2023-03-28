/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 13:26:06
 * @Description: 图片压缩
 */

import 'dart:io' show File;
import 'package:flutter/foundation.dart';

import 'package:photo_manager/photo_manager.dart' show AssetEntity;

class AssetEntityInfoGetter {
  /// 危险！！！！获取相册的文件流，此方法会产生极大的内存开销，请勿连续调用比如在for中
  static Future<File?> getAssetEntityFile(
    AssetEntity assetEntity,
  ) async {
    File? file = await assetEntity.file;
    if (file == null) {
      // bool exists = await assetEntity.exists;
      File? fileWithSubtype = await assetEntity.fileWithSubtype;
      if (fileWithSubtype != null) {
        file = fileWithSubtype;
      } else {
        File? originFile = await assetEntity.originFile;
        if (originFile != null) {
          file = originFile;
        } else {
          debugPrint("AssetEntityImageCompressUtil:file null 了");
          return null; // 压缩失败
        }
      }

      // File? file = await assetEntity.file;
      // File? fileWithSubtype = await assetEntity.fileWithSubtype;
      // File? originFile = await assetEntity.originFile;
      // File? originFileWithSubtype = await assetEntity.originFileWithSubtype;
      // File? loadFile = await assetEntity.loadFile();
    }

    return file;
  }
}
