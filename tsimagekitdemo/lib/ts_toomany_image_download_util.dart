/*
 * @Author: dvlproad
 * @Date: 2023-09-25 10:00:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-25 10:59:10
 * @Description: 
 */
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'ts_toomany_image_data_vientiane.dart';

class TSTooManyImageDownloadUtil {
  static String vientianeImageUrl =
      "https://images.xihuanwu.com/mcms/uploads/1647604960983901.jpg";

  static void simulate_download_too_many(
      int imageWidthStart, int imageWidthEnd) {
    int imageCount = imageWidthEnd - imageWidthStart;
    for (var i = 0; i < imageCount; i++) {
      int iImageWidth = imageWidthStart + i;
      String iImageUrl = TSTooManyImageDataVientiane.newImageUrl(
          vientianeImageUrl,
          width: iImageWidth);

      getNetworkImageData(iImageUrl);
      sleep(const Duration(milliseconds: 10)); // 延迟10ms，避免下载太多计算问题
    }
  }
}
