/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-14 18:49:11
 * @Description: 图片选择器的数据模型
 */

class ImageChooseBean {
  String localPath; // 图片的本地路径
  String networkUrl; // 图片的网络地址

  int width; // 图片宽度
  int height; // 图片高度

  // 数据类型 只能为 AssetEntity、String、File

  ImageChooseBean({
    this.localPath,
    this.networkUrl,
    this.width,
    this.height,
  });
}
