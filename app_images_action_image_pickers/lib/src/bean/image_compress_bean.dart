/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:45:57
 * @Description: 图片选择器的数据模型
 */
import './base_compress_bean.dart';
import './image_info_bean.dart';

class ImageCompressBean extends ImageInfoBean {
  String originPathOrUrl;
  String? compressPath;
  CompressInfoProcess compressInfoProcess;

  ImageCompressBean({
    int? width,
    int? height,
    required this.originPathOrUrl,
    this.compressPath,
    required this.compressInfoProcess,
  }) : super(
          width: width,
          height: height,
        );

  static ImageCompressBean fromJson(Map<String, dynamic> json) {
    ImageInfoBean infoBean = ImageInfoBean.fromJson(json);
    int? width = infoBean.width;
    int? height = infoBean.height;

    String originPathOrUrl = json['originPathOrUrl'] ?? '';
    String? compressPath = json['compressPath'];
    CompressInfoProcess compressInfoProcess = CompressInfoProcess.none;
    if (json['compressInfoProcess'] != null) {
      compressInfoProcess =
          compressInfoProcessFromString(json['compressInfoProcess']);
    }

    return ImageCompressBean(
      width: width,
      height: height,
      originPathOrUrl: originPathOrUrl,
      compressInfoProcess: compressInfoProcess,
      compressPath: compressPath,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = super.toJson();

    map['originPathOrUrl'] = originPathOrUrl;

    if (compressPath != null) {
      map['compressPath'] = compressPath;
    }
    map['compressInfoProcess'] = compressInfoProcess.toString().split('.').last;

    return map;
  }
}
