// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 12:04:18
 * @Description: 图片选择器的数据模型
 */

enum CompressInfoProcess {
  none, // 未进行任何压缩处理
  startCompress, // 压缩开始
  finishCompress, // 压缩完成
  finishAll, // 压缩完并获取到宽高
}

CompressInfoProcess compressInfoProcessFromString(String value) {
  // if (value == null) {
  //   return CompressInfoProcess.none;
  // }

  Iterable<CompressInfoProcess> values = [
    CompressInfoProcess.none, // 未进行任何压缩处理
    CompressInfoProcess.startCompress, // 压缩开始
    CompressInfoProcess.finishCompress, // 压缩完成
    CompressInfoProcess.finishAll, // 压缩完并获取到宽高
  ];

  return values.firstWhere((type) {
    return type.toString().split('.').last == value;
  });
}

enum CompressResultType {
  unknow, //未知
  success_get, // 成功因为获取到了缩略视频
  success_useOrigin, // 成功因为使用了原图
  failure_tooBig, // 太大不压缩
  failure_tooLong, // 太长不压缩
  failure_get, // 压缩失败
}

CompressResultType compressResultTypeFromString(String value) {
  // if (value == null) {
  //   return CompressResultType.unknow;
  // }

  Iterable<CompressResultType> values = [
    CompressResultType.unknow, //未知
    CompressResultType.success_get, // 成功因为获取到了缩略视频
    CompressResultType.success_useOrigin, // 成功因为使用了原图
    CompressResultType.failure_tooBig, // 太大不压缩
    CompressResultType.failure_get, // 压缩失败
  ];

  return values.firstWhere((type) {
    return type.toString().split('.').last == value;
  });
}

/// 压缩结果
class CompressResponseBean {
  String message;
  CompressResultType type;
  dynamic reslut;

  CompressResponseBean({
    required this.message,
    required this.type,
    this.reslut,
  });

  static CompressResponseBean fromJson(dynamic json) {
    String message = json['message'] ?? '';

    CompressResultType type = CompressResultType.unknow;
    if (json['type'] != null) {
      type = compressResultTypeFromString(json['type']);
    }

    return CompressResponseBean(
      message: message,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};

    map['message'] = message;

    map['type'] = type.toString().split('.').last;

    return map;
  }
}
