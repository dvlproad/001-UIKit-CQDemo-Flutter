/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 21:00:44
 * @Description: 图片选择器的数据模型
 */

import 'dart:ui' show Size;
import 'dart:async';
import 'dart:io';

import 'dart:io' show File, Directory;
import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

import '../images_compress_util.dart';
import '../image_compress_util/assetEntity_image_compress_util.dart';
import '../image_compress_util/assetEntity_video_thumb_util.dart';
import '../image_compress_util/assetEntity_info_getter.dart';

import '../get_image_info_util/get_image_info_util.dart';

import './image_compress_bean.dart';
import './video_compress_bean.dart';
import './base_compress_bean.dart';
import './image_info_bean.dart';

// ImageProvider
import 'package:flutter/material.dart' show ImageProvider, Image;
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImageProvider;

import 'package:extended_image/extended_image.dart';

UploadMediaType getMediaType(String localPathOrNetworkUrl) {
  if (localPathOrNetworkUrl == null) {
    throw Exception("localPath 不能为空");
  }
  String fileExtensionType = localPathOrNetworkUrl.split('.').last;
  fileExtensionType = fileExtensionType.toLowerCase();

  UploadMediaType mediaType = UploadMediaType.unkonw;
  List<String> imageTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    "webp",
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

  double frameDuration = -1; // 选中视频帧时间位置
  double videoDuration = 0; // 视频时长
  String assetEntityId = ""; // assetEntity的id
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
      assetEntityId = assetEntity!.id;
      width = _getRealWidthForAssetEntity(assetEntity!);
      height = _getRealHeightForAssetEntity(assetEntity!);

      assetEntityCompleter.complete(true);
    }
  }

  int _getRealWidthForAssetEntity(AssetEntity assetEntity) {
    int width = assetEntity.width;

    bool _isLandscape =
        assetEntity.orientation == 90 || assetEntity.orientation == 270;
    if (Platform.isAndroid && !_isLandscape) {
      // 注意:安卓宽高有时候会相反，有些机子又是正确的，所以使用不传的方案，让后台去腾讯云判断
      // width = assetEntity.height;
    }

    return width;
  }

  int _getRealHeightForAssetEntity(AssetEntity assetEntity) {
    int height = assetEntity.height;

    bool _isLandscape =
        assetEntity.orientation == 90 || assetEntity.orientation == 270;
    if (Platform.isAndroid && !_isLandscape) {
      // 注意:安卓宽高有时候会相反，有些机子又是正确的，所以使用不传的方案，让后台去腾讯云判断
      // height = assetEntity.width;
    }

    return height;
  }

  ImageChooseBean.fromJson(Map<String, dynamic> json) {
    networkUrl = json["imgUrl"];
    width = json["width"];
    height = json["height"];
    videoDuration = json["videoDuration"] ?? 0;
    frameDuration = json["frameDuration"] ?? -1;
    assetEntityId = json["assetEntityId"];
    AssetEntity.fromId(assetEntityId).then((value) {
      assetEntity = value;
      assetEntityCompleter.complete(true);
    });
    if (json["compressImageBean"] != null) {
      compressImageBean = ImageCompressBean.fromJson(json["compressImageBean"]);
    }

    if (json["compressVideoBean"] != null) {
      compressVideoBean = VideoCompressBean.fromJson(json["compressVideoBean"]);
    }
    Map<String, dynamic> asset = json["assetEntity"];
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
    data['assetEntityId'] = assetEntityId;

    if (compressImageBean != null) {
      data["compressImageBean"] = compressImageBean!.toJson();
    }

    if (compressVideoBean != null) {
      data["compressVideoBean"] = compressVideoBean!.toJson();
    }

    if (assetEntity != null) {
      Map<String, dynamic> asset = HashMap();
      asset["id"] = assetEntity!.id;
      asset["typeInt"] = assetEntity!.typeInt;
      int width = _getRealWidthForAssetEntity(assetEntity!);
      int height = _getRealHeightForAssetEntity(assetEntity!);
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
    if (compressImageBean != null && compressImageBean!.compressPath != null) {
      String imagePath = compressImageBean!.compressPath!;
      final file = File(imagePath);
      if (file.existsSync()) {
        Image image = Image.file(file);
        imageProvider = image.image;
        return imageProvider;
      }
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
    } else {
      if (compressVideoBean != null) {
        return UploadMediaType.video;
      } else if (compressImageBean != null) {
        UploadMediaType mediaType =
            getMediaType(compressImageBean!.originPathOrUrl);
        return mediaType;
      } else {
        return UploadMediaType.unkonw;
      }
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
  CompressResultType compressVideoResultType = CompressResultType.unknow;

  set compressVideoBean(VideoCompressBean? compressVideoBean) {
    _compressVideoBean = compressVideoBean;
  }

  Completer _compressCompleter = Completer<String>();

  Future checkAndBeginCompressAssetEntity({bool force = false}) async {
    _log("image choose bean hashCode111 = ${this.hashCode}");
    if ((_compressImageBean != null || _compressVideoBean != null) && !force) {
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
        CompressResponseBean compressResponseBean =
            await AssetEntityVideoThumbUtil.getVideoComppressBean(
                videoFile, assetEntity!);
        _compressVideoBean = compressResponseBean.reslut;
        compressVideoResultType = compressResponseBean.type;
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
      if (!_compressCompleter.isCompleted)
        _compressCompleter.complete('压缩:压缩完成，此时才可以进行上传压缩视频及其缩略图、或图片请求');
      if (_compressCompleter.isCompleted != true) {
        _log('_compressCompleter.isCompleted');
      }
    }
  }

  Future reCompressAssetEntity() async {
    if (networkUrl != null) {
      return;
    }
    if (assetEntity != null) {
      if (assetEntity!.type == AssetType.video) {
        if (_compressVideoBean != null &&
            _compressVideoBean!.compressPath != null) {
          bool exist = await File(_compressVideoBean!.compressPath!).exists();
          if (exist) {
            return;
          }
        }
        File? videoFile =
            await AssetEntityInfoGetter.getAssetEntityFile(assetEntity!);
        if (videoFile == null) {
          _log("file null 了");
          return;
        }
        CompressResponseBean compressResponseBean =
            await AssetEntityVideoThumbUtil.getVideoComppressBean(
                videoFile, assetEntity!);
        _compressVideoBean = compressResponseBean.reslut;
        compressVideoResultType = compressResponseBean.type;
        try {
          _compressImageBean =
              await AssetEntityVideoThumbUtil.getVideoThumbnailBean(videoFile);
        } catch (err) {
          _log("Error:获取视频缩略图失败");
        }
      } else {
        if (_compressImageBean != null &&
            _compressImageBean!.compressPath != null) {
          bool exist = await File(_compressImageBean!.compressPath!).exists();
          if (exist) {
            return;
          }
        }
        _compressImageBean =
            await AssetEntityImageCompressUtil.getCompressImageBean(
                assetEntity!);
      }
      if (!_compressCompleter.isCompleted)
        _compressCompleter.complete('压缩:压缩完成，此时才可以进行上传压缩视频及其缩略图、或图片请求');
      if (_compressCompleter.isCompleted != true) {
        _log('_compressCompleter.isCompleted');
      }
    }
  }

  /// 视频帧获取
  bool isGettingVideoFrames = false;

  List<ImageCompressBean>? _videoFrameBeans;

  Future<List<ImageCompressBean>> getVideoFrameBeans({
    int maxFrameCount = 6, // 因为编辑视频帧时，最多只能显示6张视频帧
  }) async {
    if (_videoFrameBeans != null && _videoFrameBeans!.isNotEmpty) {
      return _videoFrameBeans ?? [];
    }
    File? file;
    if (assetEntity != null) {
      file = await assetEntity!.file;
    } else {
      file = File(compressVideoBean?.compressPath ??
          compressVideoBean?.originPath ??
          "");
    }
    _videoFrameBeans = await AssetEntityVideoThumbUtil.getVideoFrameBeans(
      file!,
      assetEntity: assetEntity,
      maxFrameCount: maxFrameCount,
    );
    return _videoFrameBeans ?? [];
  }

  Completer _videoFramesCompleter = Completer<String>();

  Future<List<ImageCompressBean>?> checkAndBeginGetVideoFrames() async {
    _log("image choose bean hashCode111 = ${this.hashCode}");

    if (assetEntity == null || assetEntity!.type != AssetType.video) {
      return null;
    }

    File? videoFile =
        await AssetEntityInfoGetter.getAssetEntityFile(assetEntity!);
    if (videoFile == null) {
      _log("file null 了");
      return null;
    }

    if (_videoFrameBeans != null) {
      // 已经开始异步压缩、异步请求宽高等的时候，直接返回，即使未结束，也慢慢等待，防止重复创建
      return null;
    }

    try {
      _log("视频帧:获取视频帧列表开始");
      isGettingVideoFrames = true;
      _videoFrameBeans = await AssetEntityVideoThumbUtil.getVideoFrameBeans(
        videoFile,
        assetEntity: assetEntity,
        maxFrameCount: 6, // 因为编辑视频帧时，最多只能显示6张视频帧
      );
      isGettingVideoFrames = false;
      _log("视频帧:获取视频帧列表完成");
    } catch (err) {
      _log("Error:获取视频帧列表失败");
    }

    _videoFramesCompleter.complete('视频帧列表:获取视频帧列表完成，此时才可以进行');
    if (_videoFramesCompleter.isCompleted != true) {
      _log('_compressCompleter.isCompleted');
    }
    return _videoFrameBeans;
  }

  Future loadAssetEntity(String assetId) async {
    if (assetEntity == null) {
      assetEntityId = assetId;
      assetEntity = await AssetEntity.fromId(assetId);
      assetEntityCompleter.complete(true);
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
