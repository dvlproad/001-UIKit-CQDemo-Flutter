/*
 * @Author: dvlproad
 * @Date: 2024-02-27 10:03:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 13:39:03
 * @Description: 
 */
import 'dart:core';

import 'package:photo_manager/photo_manager.dart';

enum UploadMediaType {
  unkonw,
  image,
  audio,
  video,
  imlog,
  appLog,
  livelog,
}

class MediaTypeUtil {
  static UploadMediaType getByAssetEntity(AssetEntity assetEntity) {
    AssetType assetType = assetEntity.type;
    if (assetType == AssetType.video) {
      return UploadMediaType.video;
    } else if (assetType == AssetType.image) {
      return UploadMediaType.image;
    } else {
      return UploadMediaType.unkonw;
    }
  }

  static UploadMediaType getByPathOrUrl(String localPathOrNetworkUrl) {
    // if (localPathOrNetworkUrl == null) {
    //   throw Exception("localPath 不能为空");
    // }
    String fileExtensionType = localPathOrNetworkUrl.split('.').last;
    fileExtensionType = fileExtensionType.toLowerCase();

    UploadMediaType mediaType = UploadMediaType.unkonw;
    List<String> imageTypes = [
      'jpg',
      'jpeg',
      'png',
      'gif',
      "webp",
      "avif",
    ];
    List<String> videoTypes = [
      'mp4',
      'mov',
      'm4v',
      'rm',
      'wmv',
      'asf',
      'asx',
      'avi',
      'dat',
      'mkv',
      'flv',
      'vob',
      'm3u8',
    ];
    List<String> audioTypes = ['aar'];

    if (imageTypes.contains(fileExtensionType) == true) {
      mediaType = UploadMediaType.image;
    } else if (videoTypes.contains(fileExtensionType) == true) {
      mediaType = UploadMediaType.video;
    } else if (audioTypes.contains(fileExtensionType) == true) {
      mediaType = UploadMediaType.audio;
    } else {
      mediaType = UploadMediaType.unkonw;
    }
    return mediaType;
  }
}
