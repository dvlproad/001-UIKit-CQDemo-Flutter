/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-23 17:21:51
 * @Description: 压缩
 */

enum CompressMediaResultType {
  NoNeedCompressAgain, // 之前已经上传过，现在不用重复压缩又上传
  CompressSuccess, // 压缩成功
  ImageFailureBCThumbnailGet, // 缩略图片：获取失败
  ImageFailureBCThumbnailUpload, // 缩略图片：上传失败
  VideoFailureBCSelfTooBig, // 视频:太大失败
  VideoFailureBCThumbnailSelfGet, // 缩略视频:获取失败
  VideoFailureBCThumbnailSelfUpload, // 缩略视频:上传失败
  VideoFailureBCThumbnailImageGet, // 视频缩略图:获取失败
  VideoFailureBCThumbnailImageUpload, // 视频缩略图:上传失败
}
