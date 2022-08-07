/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:08:08
 * @Description: 图片选择器的数据模型
 */

enum CompressInfoProcess {
  none, // 未进行任何压缩处理
  startCompress, // 压缩开始
  finishCompress, // 压缩完成
  finishAll, // 压缩完并获取到宽高
}

CompressInfoProcess compressInfoProcessFromString(String value) {
  if (value == null) {
    return CompressInfoProcess.none;
  }

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
