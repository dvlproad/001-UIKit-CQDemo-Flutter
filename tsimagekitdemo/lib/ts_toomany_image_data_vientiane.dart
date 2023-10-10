/*
 * @Author: dvlproad
 * @Date: 2023-09-19 14:49:06
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-25 09:57:02
 * @Description: 
 */
/// [图片处理方式:快速缩略模板](https://cloud.tencent.com/document/product/460/6929)
/// [图片处理方式:数据万象-缩放thumbnail](https://cloud.tencent.com/document/product/460/36540)
/// [图片处理方式:数据万象-旋转rotate](https://cloud.tencent.com/document/product/460/36542)
class TSTooManyImageDataVientiane {
  static String newImageUrl(String imageUrl, {required int width}) {
    String thumbnail = '?imageMogr2/thumbnail/';
    thumbnail += '${width}x/';
    thumbnail += 'format/webp/auto-orient/quality/100';

    String newImageUrl = "$imageUrl$thumbnail";
    // debugPrint('newImageUrl = $newImageUrl');
    return newImageUrl;
  }
}
