/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:30:42
 * @Description: 图片基础信息(宽高)
 */

class ImageInfoBean {
  // String pathOrUrl; // 图片的本地路径或网络地址
  int? width; // 图片宽度
  int? height; // 图片高度

  ImageInfoBean({
    // required this.pathOrUrl,
    this.width,
    this.height,
  });

  bool get hasGetSize {
    return width != null && height != null && width! > 0 && height! > 0;
  }

  ImageInfoBean.fromJson(Map<String, dynamic> json) {
    // pathOrUrl = json['pathOrUrl'];
    width = json['width'];
    height = json['height'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    // if (pathOrUrl != null) {
    //   map['pathOrUrl'] = pathOrUrl;
    // }
    if (width != null) {
      map['width'] = width;
    }
    if (height != null) {
      map['height'] = height;
    }

    return map;
  }
}
