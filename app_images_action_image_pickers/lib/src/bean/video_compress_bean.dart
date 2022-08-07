/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:47:48
 * @Description: 图片选择器的数据模型
 */
import './base_compress_bean.dart';
import './image_info_bean.dart';

class VideoCompressBean {
  String originPath;
  String? compressPath;

  CompressInfoProcess compressInfoProcess;

  VideoCompressBean({
    required this.originPath,
    this.compressPath,
    required this.compressInfoProcess,
  });

  static VideoCompressBean fromJson(dynamic json) {
    String originPath = json['originPath'] ?? '';
    String? compressPath = json['compressPath'];

    CompressInfoProcess compressInfoProcess = CompressInfoProcess.none;
    if (json['compressInfoProcess'] != null) {
      compressInfoProcess =
          compressInfoProcessFromString(json['compressInfoProcess']);
    }

    return VideoCompressBean(
      originPath: originPath,
      compressPath: compressPath,
      compressInfoProcess: compressInfoProcess,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};

    map['originPath'] = originPath;

    if (compressPath != null) {
      map['compressPath'] = compressPath;
    }

    map['compressInfoProcess'] = compressInfoProcess.toString().split('.').last;

    return map;
  }
}
