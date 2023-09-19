/*
 * @Author: dvlproad
 * @Date: 2022-07-18 18:07:40
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-19 14:49:32
 * @Description: 数据万象(宽高都不传的时候，只会做 format/webp/auto-orient 处理)
 */
import 'dart:math';

/// [图片处理方式:快速缩略模板](https://cloud.tencent.com/document/product/460/6929)
/// [图片处理方式:数据万象-缩放thumbnail](https://cloud.tencent.com/document/product/460/36540)
/// [图片处理方式:数据万象-旋转rotate](https://cloud.tencent.com/document/product/460/36542)
///
/// [图片处理方式:数据万象-图片水印](https://cloud.tencent.com/document/product/460/6930)
/// eg:http://examples-1251000004.cos.ap-shanghai.myqcloud.com/sample.jpeg?watermark/1/image/aHR0cDovL2V4YW1wbGVzLTEyNTEwMDAwMDQucGljc2gubXlxY2xvdWQuY29tL3NodWl5aW4uanBn/gravity/southeast
///
/// [图片处理方式:数据万象-文字水印](https://cloud.tencent.com/document/product/460/36542)
/// eg:http://examples-1251000004.cos.ap-shanghai.myqcloud.com/sample.jpeg?watermark/2/text/6IW-6K6v5LqRwrfkuIfosaHkvJjlm74/fill/IzNEM0QzRA/fontsize/20/dissolve/50/gravity/northeast/dx/20/dy/20/batch/1/degree/45

class TestDataVientiane {
  static bool canVientiane(String imageUrl) {
    // https://images.xihuanwu.com/mcms/uploads/1647604960983901.jpg?imageMogr2/thumbnail/100x/format/webp/auto-orient
    int index = imageUrl.indexOf('.xihuanwu.com');
    bool isCloudImage = index != -1;
    return isCloudImage;
  }

  static String newImageUrl(
    String? imageUrl, {
    double? width,
    void Function(String lastImageUrl)? lastImageUrlGetBlock,
  }) {
    if (imageUrl == null) {
      return "";
    }

    bool isCloudImage = canVientiane(imageUrl);
    if (isCloudImage != true) {
      // debugPrint('imageUrl = $imageUrl');
      if (lastImageUrlGetBlock != null) {
        lastImageUrlGetBlock(imageUrl);
      }
      return imageUrl;
    }

    String newImageUrl = imageUrl;
    double multiple = 1;
    String thumbnail = '?imageMogr2/thumbnail/';
    if (width != null && width > 0) {
      double useWidth = width;
      // 0.888972809667674腾讯万象的问题，已提交工单
      // https://console.cloud.tencent.com/workorder/detail?ticketId=202309058831
      // 100/3 舍弃当前变量的小数部分，结果为 33。返回值为 int 类型。
      thumbnail += '${(useWidth * multiple).truncate()}';
      thumbnail += 'x';

      thumbnail += '/';
    }

    // quality/90图片无损压缩，对标小红书
    thumbnail += 'format/webp/auto-orient/quality/90';
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
