/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 13:57:31
 * @Description: 图片选择器的数据模型
 */

import 'dart:ui' show Size;
import 'dart:async';

import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../asset_entity_compress_protocol.dart';
import '../asset_entity_frame_protocol.dart';
import '../get_image_info_util/asset_entity_size_util.dart';
import '../get_image_info_util/image_provider_size_util.dart';
import '../get_image_info_util/media_type_util.dart';

import './base_compress_bean.dart';
import './image_info_bean.dart';

// ImageProvider
import 'package:flutter/material.dart' show ImageProvider;
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;

import 'package:extended_image/extended_image.dart';

enum UploadMediaScene {
  unkonw,
  selfie, //自拍
}

class ImageChooseBean
    with AssetEntityCompressProtocol, AssetEntityFrameProtocol {
  String? networkUrl; // 图片的网络地址
  AssetEntity? assetEntity;

  int? width; // 图片宽度
  int? height; // 图片高度

  // 数据类型 只能为 AssetEntity、String、File

  ImageInfoBean? thumbnailInfo;
  String? networkThumbnailUrl; // 图片的网络地址

  double frameDuration = -1; // 选中视频帧时间位置
  double videoDuration = 0; // 视频时长
  Completer<bool> assetEntityCompleter = Completer<bool>();

  ImageChooseBean({
    this.networkUrl,
    this.assetEntity,
    this.width,
    this.height,
    this.thumbnailInfo,
    this.networkThumbnailUrl,
  }) {
    if (assetEntity != null && assetEntity!.type == AssetType.video) {
      videoDuration = assetEntity!.duration.toDouble();
      width = AssetEntitySizeUtil.getRealWidthForAssetEntity(assetEntity!);
      height = AssetEntitySizeUtil.getRealHeightForAssetEntity(assetEntity!);

      assetEntityCompleter.complete(true);
    }
  }

  ImageChooseBean.fromJson(Map<String, dynamic> json) {
    networkUrl = json["imgUrl"];
    width = json["width"];
    height = json["height"];
    videoDuration = json["videoDuration"] ?? 0;
    frameDuration = json["frameDuration"] ?? -1;
    networkUrl = json["networkUrl"];
    networkThumbnailUrl = json["networkThumbnailUrl"];

    if (json["compressedImage"] != null) {
      imageCompressResponseBean =
          CompressResponseBean.fromJson(json["compressedImage"]);
    }
    if (json["compressedVideo"] != null) {
      videoCompressResponseBean =
          CompressResponseBean.fromJson(json["compressedVideo"]);
    }

    if (json["videoThumb"] != null) {
      videoThumbResponseBean =
          CompressResponseBean.fromJson(json["videoThumb"]);
    }

    Map<String, dynamic>? asset = json["assetEntity"];
    if (asset != null) {
      assetEntity = AssetEntity(
          id: asset["id"],
          typeInt: asset["typeInt"],
          width: asset["width"],
          height: asset["height"],
          duration: asset["duration"],
          orientation: asset["orientation"],
          isFavorite: asset["isFavorite"],
          title: asset["title"],
          createDateSecond: asset["createDateSecond"],
          modifiedDateSecond: asset["modifiedDateSecond"],
          relativePath: asset["relativePath"],
          latitude: asset["latitude"],
          longitude: asset["longitude"],
          mimeType: asset["mimeType"],
          subtype: asset["subtype"]);
      assetEntityCompleter.complete(true);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (networkUrl != null) {
      data["imgUrl"] = networkUrl;
    }
    if (width != null) {
      data["width"] = width;
    }
    if (height != null) {
      data["height"] = height;
    }

    data['videoDuration'] = videoDuration;
    data['frameDuration'] = frameDuration;
    data['networkThumbnailUrl'] = networkThumbnailUrl;
    data['networkUrl'] = networkUrl;

    if (imageCompressResponseBean != null) {
      data["compressedImage"] = imageCompressResponseBean!.toJson();
    }

    if (videoCompressResponseBean != null) {
      data["compressedVideo"] = videoCompressResponseBean!.toJson();
    }

    if (videoThumbResponseBean != null) {
      data["videoThumb"] = videoThumbResponseBean!.toJson();
    }

    if (assetEntity != null) {
      Map<String, dynamic> asset = HashMap();
      asset["id"] = assetEntity!.id;
      asset["typeInt"] = assetEntity!.typeInt;
      int width = AssetEntitySizeUtil.getRealWidthForAssetEntity(assetEntity!);
      int height =
          AssetEntitySizeUtil.getRealHeightForAssetEntity(assetEntity!);
      asset["width"] = width;
      asset["height"] = height;
      asset["duration"] = assetEntity!.duration;
      asset["orientation"] = assetEntity!.orientation;
      asset["isFavorite"] = assetEntity!.isFavorite;
      asset["title"] = assetEntity!.title;
      asset["createDateSecond"] = assetEntity!.createDateSecond;
      asset["modifiedDateSecond"] = assetEntity!.modifiedDateSecond;
      asset["relativePath"] = assetEntity!.relativePath;
      asset["latitude"] = assetEntity!.latitude;
      asset["longitude"] = assetEntity!.longitude;
      asset["mimeType"] = assetEntity!.mimeType;
      asset["subtype"] = assetEntity!.subtype;
      data["assetEntity"] = asset;
    }

    return data;
  }

  /// 获取图片
  ImageProvider? get imageProvider {
    ImageProvider? imageProvider;

    if (currentCompressedImageOrVideoThumbnailProvider != null) {
      imageProvider = currentCompressedImageOrVideoThumbnailProvider;
      return imageProvider;
    }
    if (assetEntity != null) {
      imageProvider = AssetEntityImageProvider(
        assetEntity!,
        isOriginal: true,
      );
    } else if (networkUrl != null) {
      imageProvider = ExtendedNetworkImageProvider(networkUrl!);
    }

    return imageProvider;
  }

  UploadMediaType get mediaType {
    if (compressAssetEntity != null) {
      return MediaTypeUtil.getByAssetEntity(compressAssetEntity!);
    } else if (assetEntity != null) {
      return MediaTypeUtil.getByAssetEntity(assetEntity!);
    } else if (networkUrl != null) {
      UploadMediaType mediaType = MediaTypeUtil.getByPathOrUrl(networkUrl!);
      return mediaType;
    } else {
      return UploadMediaType.unkonw;
    }
  }

  Future<Size?> get lastShowSize async {
    late int uploadImageWidth;
    late int uploadImageHeight;

    // 网络图已有宽高数据
    if (width != null && height != null) {
      uploadImageWidth = width!;
      uploadImageHeight = height!;
    } else if (currentCompressedImageOrVideoThumbnailProvider != null) {
      // 本地缩略图
      Size imageSize = await ImageProviderSizeUtil.getWidthAndHeight(
          currentCompressedImageOrVideoThumbnailProvider!);
      return imageSize;
    } else if (assetEntity != null) {
      uploadImageWidth = assetEntity!.width;
      uploadImageHeight = assetEntity!.height;
    }

    return Size(uploadImageWidth.toDouble(), uploadImageHeight.toDouble());
  }

  Future checkAndBeginCompressAssetEntity({bool force = false}) async {
    if (!_enableCompress) return;

    checkAndBeginCompress(assetEntity!);
  }

  bool get _enableCompress {
    if (assetEntity == null) {
      debugPrint("该资源不是来源于相册(即可能是网络)，无法进行压缩");
      return false;
    }
    return true;
  }

  Future reCompressAssetEntity() async {
    if (networkUrl != null) {
      return;
    }
    checkAndBeginCompressAssetEntity();
  }

  Future<void> checkAndBeginGetVideoFrames() async {
    if (assetEntity == null) {
      debugPrint("该资源不是来源于相册(即可能是网络)");
      return;
    }
    checkAndBeginGetAssetEntityVideoFrames(assetEntity!);
  }
}
