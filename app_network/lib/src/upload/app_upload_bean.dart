/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-24 00:07:42
 * @Description:
 */

enum UploadResultType {
  Unknow, // 未知
  UploadSuccess, // 上传成功
  UploadFailure, // 上传失败
  UploadNone, // 不需要上传
}

class UploadResultBean {
  UploadResultType uploadResultType;
  String? url;

  UploadResultBean({
    required this.uploadResultType,
    this.url,
  });
}

enum UploadMediaResultType {
  Unknow,
  UploadSuccess, // 上传成功
  ImageFailureBCThumbnailGet, // 缩略图片：获取失败
  ImageFailureBCThumbnailUpload, // 缩略图片：上传失败
  VideoFailureBCSelfTooBig, // 视频:太大失败
  VideoFailureBCSelfTooLong, // 视频:太长失败
  VideoFailureBCThumbnailSelfGet, // 缩略视频:获取失败
  VideoFailureBCThumbnailSelfUpload, // 缩略视频:上传失败
  VideoFailureBCThumbnailImageGet, // 视频缩略图:获取失败
  VideoFailureBCThumbnailImageUpload, // 视频缩略图:上传失败
}

class UploadMediaResultBean {
  UploadMediaResultType resultType;
  String? url;

  UploadMediaResultBean({
    required this.resultType,
    this.url,
  });
}
