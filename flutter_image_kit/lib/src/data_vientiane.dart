/*
 * @Author: dvlproad
 * @Date: 2022-07-18 18:07:40
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-04-07 18:11:05
 * @Description: 数据万象(宽高都不传的时候，只会做 format/webp/auto-orient 处理)
 */
import 'dart:math';

import '../flutter_image_kit_adapt.dart';

/// [图片处理方式:快速缩略模板](https://cloud.tencent.com/document/product/460/6929)
/// [图片处理方式:数据万象-缩放thumbnail](https://cloud.tencent.com/document/product/460/36540)
/// [图片处理方式:数据万象-旋转rotate](https://cloud.tencent.com/document/product/460/36542)
///
/// [图片处理方式:数据万象-图片水印](https://cloud.tencent.com/document/product/460/6930)
/// eg:http://examples-1251000004.cos.ap-shanghai.myqcloud.com/sample.jpeg?watermark/1/image/aHR0cDovL2V4YW1wbGVzLTEyNTEwMDAwMDQucGljc2gubXlxY2xvdWQuY29tL3NodWl5aW4uanBn/gravity/southeast
///
/// [图片处理方式:数据万象-文字水印](https://cloud.tencent.com/document/product/460/36542)
/// eg:http://examples-1251000004.cos.ap-shanghai.myqcloud.com/sample.jpeg?watermark/2/text/6IW-6K6v5LqRwrfkuIfosaHkvJjlm74/fill/IzNEM0QzRA/fontsize/20/dissolve/50/gravity/northeast/dx/20/dy/20/batch/1/degree/45
enum ImageDealType {
  default2, // 默认等比限定缩略图的宽高最小值
  origin, // 原图
}

class DataVientiane {
  static bool canVientiane(String imageUrl) {
    // https://images.xxx.com/mcms/uploads/1647604960983901.jpg?imageMogr2/thumbnail/100x/format/webp/auto-orient
    int index = imageUrl.indexOf('.xxx.com');
    bool isCloudImage = index != -1;
    return isCloudImage;
  }

  static String newImageUrl(
    String imageUrl,
    ImageDealType imageDealType, {
    double? width,
    double? height,
    void Function(String lastImageUrl)? lastImageUrlGetBlock,
  }) {
    // ignore: unnecessary_null_comparison
    if (imageUrl == null) {
      return "";
    }
    // String fileExtensionType = imageUrl.split('.').last.toLowerCase();
    // if (['jpg', 'jpeg', 'png'].contains(fileExtensionType) == false) {
    //   return imageUrl;
    // }
    if (imageDealType == ImageDealType.origin) {
      // debugPrint('imageUrl = $imageUrl');
      if (lastImageUrlGetBlock != null) {
        lastImageUrlGetBlock(imageUrl);
      }
      return imageUrl;
    }

    // https://images.xxx.com/mcms/uploads/1647604960983901.jpg?imageMogr2/thumbnail/100x/format/webp/auto-orient
    int index = imageUrl.indexOf('.xxx.com');
    bool isCloudImage = index != -1;
    if (isCloudImage != true) {
      // debugPrint('imageUrl = $imageUrl');
      if (lastImageUrlGetBlock != null) {
        lastImageUrlGetBlock(imageUrl);
      }
      return imageUrl;
    }

    String newImageUrl = imageUrl;
    int multiple = 3; // 固定取3倍图，能保证清晰，万象中已做处理，也不会太大
    String thumbnail = '?imageMogr2/thumbnail/';
    if (width != null && width > 0) {
      List<double> ladders = [];
      double ladderValue = 50.0.w_pt_cj;
      for (var i = 1; i <= 8; i++) {
        ladders.add(ladderValue * i);
      }
      /*
      // List<double> ladders = [36, 64, 188, 360, 750]; // 图片规范
      List<double> ladders = [
        36.0.w_pt_cj,
        64.0.w_pt_cj,
        160.0.w_pt_cj,
        188.0.w_pt_cj, // 半屏幕
        224.0.w_pt_cj,
        256.0.w_pt_cj,
        375.0.w_pt_cj, // 满屏幕宽
      ]; // 图片规范
      */

      double useWidth = width;
      int ladderCount = ladders.length;
      for (var i = 0; i <= ladderCount; i++) {
        double ladderValue = ladders[i];
        if (width < ladderValue) {
          useWidth = max(width, ladderValue);
          break;
        }
      }
      // 100/3 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
      thumbnail += '${(useWidth * multiple).truncate()}';
      thumbnail += 'x';

      if (height != null && height > 0) {
        double useHeight = height;
        double widthHeightRatio = (width / height).toDouble();
        useHeight = useWidth / widthHeightRatio;

        thumbnail += '${(useHeight * multiple).truncate()}';
      }

      thumbnail += '/';
    }

    thumbnail += 'format/webp/auto-orient';
    newImageUrl += thumbnail;
    // newImageUrl +='&watermark/2/text/6IW-6K6v5LqRwrfkuIfosaHkvJjlm74/fill/IzNEM0QzRA/fontsize/20/dissolve/50/gravity/northeast/dx/20/dy/20/batch/1/degree/45';

    // newImageUrl +='?watermark/1/image/aHR0cDovL2V4YW1wbGVzLTEyNTEwMDAwMDQucGljc2gubXlxY2xvdWQuY29tL3NodWl5aW4uanBn/gravity/southeast';
    // debugPrint('newImageUrl = $newImageUrl');
    if (lastImageUrlGetBlock != null) {
      lastImageUrlGetBlock(newImageUrl);
    }
    return newImageUrl;
  }
}
