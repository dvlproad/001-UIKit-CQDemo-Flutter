/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-06 16:33:54
 * @Description: 图片选择器的数据模型
 */

import 'dart:ui' show Size;
import 'dart:async';

import 'dart:io' show File, Directory;
import 'package:flutter/foundation.dart';
import '../image_compress_util/assetEntity_image_compress_util.dart';
import '../image_compress_util/assetEntity_video_thumb_util.dart';
import '../get_image_info_util/get_image_info_util.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity, AssetType;

import 'package:video_thumbnail/video_thumbnail.dart';
import './image_compress_bean.dart';
import './video_compress_bean.dart';
import './base_compress_bean.dart';
import './image_info_bean.dart';
import '../image_compress_util/assetEntity_info_getter.dart';

// ImageProvider
import 'package:flutter/material.dart' show ImageProvider, Image;
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;

UploadMediaType getMediaType(String localPathOrNetworkUrl) {
  if (localPathOrNetworkUrl == null) {
    throw Exception("localPath 不能为空");
  }
  String fileExtensionType = localPathOrNetworkUrl.split('.').last;
  fileExtensionType = fileExtensionType.toLowerCase();

  UploadMediaType mediaType = UploadMediaType.unkonw;
  if (['jpg', 'jpeg', 'png'].contains(fileExtensionType) == true) {
    mediaType = UploadMediaType.image;
  } else if ([
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
      ].contains(fileExtensionType) ==
      true) {
    mediaType = UploadMediaType.video;
  } else if (['aar'].contains(fileExtensionType) == true) {
    mediaType = UploadMediaType.audio;
  } else {
    mediaType = UploadMediaType.unkonw;
  }
  return mediaType;
}

enum UploadMediaType {
  unkonw,
  image,
  audio,
  video,
}

class ImageChooseBean {
  String? networkUrl; // 图片的网络地址
  AssetEntity? assetEntity;

  int? width; // 图片宽度
  int? height; // 图片高度

  // 数据类型 只能为 AssetEntity、String、File

  ImageInfoBean? thumbnailInfo;
  String? networkThumbnailUrl; // 图片的网络地址

  ImageChooseBean({
    this.networkUrl,
    this.assetEntity,
    this.width,
    this.height,
    this.thumbnailInfo,
    this.networkThumbnailUrl,
  });

  ImageChooseBean.fromJson(Map<String, dynamic> json) {
    networkUrl = json["imgUrl"];
    width = json["width"];
    height = json["height"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data["imgUrl"] = networkUrl;
    data["width"] = width;
    data["height"] = height;

    return data;
  }

  /// 获取图片
  ImageProvider? get imageProvider {
    ImageProvider? imageProvider;
    if (compressImageBean != null && compressImageBean!.compressPath != null) {
      String imagePath = compressImageBean!.compressPath!;
      Image image = Image.file(File(imagePath));
      imageProvider = image.image;
    } else if (assetEntity != null) {
      imageProvider = AssetEntityImageProvider(
        assetEntity!,
        isOriginal: true,
      );
    } else if (networkUrl != null) {
      imageProvider = CachedNetworkImageProvider(networkUrl!);
    }

    return imageProvider;
  }

  UploadMediaType get mediaType {
    if (assetEntity != null) {
      AssetType assetType = assetEntity!.type;
      if (assetType == AssetType.video) {
        return UploadMediaType.video;
      } else if (assetType == AssetType.image) {
        return UploadMediaType.image;
      } else {
        return UploadMediaType.unkonw;
      }
    } else if (networkUrl != null) {
      UploadMediaType mediaType = getMediaType(networkUrl!);
      return mediaType;
    } else if (compressImageBean != null) {
      UploadMediaType mediaType =
          getMediaType(compressImageBean!.originPathOrUrl);
      return mediaType;
    } else {
      return UploadMediaType.unkonw;
    }
  }

  Size get lastShowSize {
    late int uploadImageWidth;
    late int uploadImageHeight;

    // 网络图已有宽高数据
    if (this.width != null && this.height != null) {
      uploadImageWidth = this.width!;
      uploadImageHeight = this.height!;
    } else if (this.compressImageBean != null &&
        this.compressImageBean!.width != null &&
        this.compressImageBean!.height != null) {
      // 本地缩略图
      uploadImageWidth = this.compressImageBean!.width!;
      uploadImageHeight = this.compressImageBean!.height!;
    } else if (this.assetEntity != null) {
      uploadImageWidth = this.assetEntity!.width;
      uploadImageHeight = this.assetEntity!.height;
    } else {
      uploadImageWidth = 103;
      uploadImageHeight = 103;
    }

    return Size(uploadImageWidth.toDouble(), uploadImageHeight.toDouble());
  }

  Future<String?> lastUploadThumbnailVideoPath() async {
    // 草稿里的图片已有压缩数据
    if (_compressVideoBean != null &&
        _compressVideoBean!.compressInfoProcess ==
            CompressInfoProcess.finishAll) {
      return _compressVideoBean!.compressPath;
    }

    await _compressCompleter.future; // 优化压缩流程，上传时候未完成压缩会自动等待，并在完成压缩后，自动继续
    if (mediaType == UploadMediaType.video) {
      //
    } else {
      //
    }

    if (_compressVideoBean == null) {
      return null; // 获取缩略图失败(发现获取安卓视频缩略图失败过)
    }

    return _compressVideoBean!.compressPath;
  }

  Future<String?> lastUploadThumbnailImagePath() async {
    _log("image choose bean hashCode = ${this.hashCode}");
    // 草稿里的图片已有压缩数据
    if (_compressImageBean != null &&
        _compressImageBean!.compressInfoProcess ==
            CompressInfoProcess.finishAll) {
      return _compressImageBean!.compressPath;
    }

    await _compressCompleter.future; // 优化压缩流程，上传时候未完成压缩会自动等待，并在完成压缩后，自动继续
    if (mediaType == UploadMediaType.video) {
      //
    } else {
      //
    }

    if (_compressImageBean == null) {
      return null; // 获取缩略图失败(发现获取安卓视频缩略图失败过)
    }

    return _compressImageBean!.compressPath;
  }

  // 图片压缩后的信息(本地路径、宽、高)
  ImageCompressBean? get compressImageBean => _compressImageBean;
  ImageCompressBean? _compressImageBean;
  set compressImageBean(ImageCompressBean? compressImageBean) {
    _compressImageBean = compressImageBean;
  }

  // 视频压缩后的信息(本地路径、宽、高)
  VideoCompressBean? get compressVideoBean => _compressVideoBean;
  VideoCompressBean? _compressVideoBean;
  set compressVideoBean(VideoCompressBean? compressVideoBean) {
    _compressVideoBean = compressVideoBean;
  }

  Completer _compressCompleter = Completer<String>();
  Future checkAndBeginCompressAssetEntity() async {
    _log("image choose bean hashCode111 = ${this.hashCode}");
    if (_compressImageBean != null || _compressVideoBean != null) {
      // 已经开始异步压缩、异步请求宽高等的时候，直接返回，即使未结束，也慢慢等待，防止重复创建
      return;
    }

    if (assetEntity != null) {
      if (assetEntity!.type == AssetType.video) {
        File? videoFile =
            await AssetEntityInfoGetter.getAssetEntityFile(assetEntity!);
        if (videoFile == null) {
          _log("file null 了");
          return;
        }
        _compressVideoBean =
            await AssetEntityVideoThumbUtil.getVideoComppressBean(videoFile);
        try {
          _compressImageBean =
              await AssetEntityVideoThumbUtil.getVideoThumbnailBean(videoFile);
        } catch (err) {
          _log("Error:获取视频缩略图失败");
        }
      } else {
        _compressImageBean =
            await AssetEntityImageCompressUtil.getCompressImageBean(
                assetEntity!);
      }

      _compressCompleter.complete('压缩:压缩完成，此时才可以进行上传压缩视频及其缩略图、或图片请求');
      if (_compressCompleter.isCompleted != true) {
        _log('_compressCompleter.isCompleted');
      }
    }
  }

  /*
  void checkAndBeginCompressAppLocalPath() {
    print("image choose bean hashCode111 = ${this.hashCode}");
    if (_compressImageBean != null) {
      // 已经开始异步压缩、异步请求宽高等的时候，直接返回，即使未结束，也慢慢等待，防止重复创建
      return;
    }

    _compressImageBean = ImageCompressBean();
    _compressImageBean.infoBean = ImageInfoBean();
    _compressImageBean.infoBean.localPath = assetEntityPath;
    if (assetEntity != null) {
      AssetEntityImageCompressUtil.getCompressImageBean(assetEntity)
          .then((ImageCompressBean imageCompressBean) {
        _compressImageBean = imageCompressBean;

        print("image choose bean hashCode222 = ${this.hashCode}");
        if (_compressImageBean == null) {}

        // _compressCompleter.complete('图片:本地压缩并获取宽高完成，此时才可以进行上传请求');
        // if (_compressCompleter.isCompleted != true) {
        //   print('_compressCompleter.isCompleted');
        // }
      });
    }
  }
  */

  void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
