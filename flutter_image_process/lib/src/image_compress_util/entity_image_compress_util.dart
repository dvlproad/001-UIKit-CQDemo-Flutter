/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 14:00:26
 * @Description: 图片压缩
 */

import 'dart:io' show File;

import 'package:photo_manager/photo_manager.dart' show AssetEntity;
import '../bean/image_compress_bean.dart';
import '../bean/base_compress_bean.dart';
import './base_image_compress_util.dart';
import '../get_image_info_util/get_image_info_util.dart';
import './entity_info_getter.dart';

class AssetEntityImageCompressUtil {
  static Future<ImageCompressBean?> getCompressImageBean(
    AssetEntity assetEntity,
  ) async {
    /// 危险！！！！获取相册的文件流，此方法会产生极大的内存开销，请勿连续调用比如在for中
    File? file;
    try {
      file = await AssetEntityInfoGetter.getAssetEntityFile(assetEntity);
      if (file == null) {
        return null;
      }
    } catch (err) {
      return null; // 提示:内存激增，不会走到此catch
    }

    ImageCompressBean compressImageBean = ImageCompressBean(
      originPathOrUrl: file.absolute.path,
      compressInfoProcess: CompressInfoProcess.startCompress,
    );

    // 获取图片文件及其压缩比(为100%时候，不用进行压缩)
    int compressQuality = _getCompressQuality(file);
    // int compressQuality = 80;
    if (compressQuality == 100) {
      compressImageBean.width = assetEntity.width;
      compressImageBean.height = assetEntity.height;
      compressImageBean.compressPath = file.absolute.path;
      compressImageBean.compressInfoProcess = CompressInfoProcess.finishAll;
    } else {
      // 图片压缩的保存路径获取
      String targetCompressPath =
          await BaseImageCompressUtil.getFileTargetPath(file);

      // 图片压缩开始，并获取最终的图片路径
      compressImageBean.compressInfoProcess = CompressInfoProcess.startCompress;
      File? localCompressFile =
          await BaseImageCompressUtil.compressFileAndReturnNewFile(
              file, targetCompressPath);
      if (localCompressFile == null) {
        return null; // 压缩失败
      }
      compressImageBean.compressPath = localCompressFile.path;
      compressImageBean.compressInfoProcess =
          CompressInfoProcess.finishCompress;
      // 获取压缩图片的宽高
      Map<String, dynamic> imageWithHeight =
          await GetImageInfoUtil.getImageWidthAndHeight(localCompressFile.path);
      int imageWidth = imageWithHeight["width"];
      int imageHeight = imageWithHeight["height"];
      compressImageBean.width = imageWidth;
      compressImageBean.height = imageHeight;
      compressImageBean.compressInfoProcess = CompressInfoProcess.finishAll;
    }

    return compressImageBean;
  }

  static int _getCompressQuality(File file) {
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
}
