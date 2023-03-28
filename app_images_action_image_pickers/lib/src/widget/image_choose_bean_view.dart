// ignore_for_file: unused_import

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-28 10:25:38
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:photo_manager/photo_manager.dart' show AssetEntity;

import 'package:flutter_image_kit/flutter_image_kit.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

import '../preview/widget/asset_entity_widget.dart';
import 'package:flutter_player_ui/flutter_player_ui.dart';

class ImageChooseBeanView {
  static Widget getImageWidget<T extends ImageChooseBean>({
    required BuildContext context,
    required T imageChooseModel,
    double? width,
    double? height,
    void Function(String lastImageUrl)? lastImageUrlGetBlock, // 获取最后显示的url(打印用)
    bool showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
  }) {
    if (imageChooseModel.assetEntity != null) {
      return _getCustomImageWidget_assetEntity(
        context: context,
        imageChooseModel: imageChooseModel,
        width: width,
        height: height,
        showCenterIconIfVideo: showCenterIconIfVideo,
      );
    } else if (imageChooseModel.networkUrl != null &&
        imageChooseModel.networkUrl!.isNotEmpty) {
      return _getCustomImageWidget_networkUrl(
        context: context,
        imageChooseModel: imageChooseModel,
        width: width,
        height: height,
        lastImageUrlGetBlock: lastImageUrlGetBlock,
        showCenterIconIfVideo: showCenterIconIfVideo,
      );
    } else if (imageChooseModel.compressImageBean != null &&
        imageChooseModel.compressImageBean!.compressPath != null) {
      return _getCustomImageWidget_compressPath(
        context: context,
        imageChooseModel: imageChooseModel,
        width: width,
        height: height,
        showCenterIconIfVideo: showCenterIconIfVideo,
      );
    } else {
      // String imagePath = imageChooseModel.assetEntityPath;
      // Image image = Image.file(File(imagePath));
      // imageProvider = image.image;
      // // imageProvider = AssetImage(photoAlbumPath);
      // imagePathOrUrl = imagePath;

      return Container(
        width: width,
        height: height,
      );
    }
  }

  static Widget _getCustomImageWidget_assetEntity<T extends ImageChooseBean>({
    required BuildContext context,
    required T imageChooseModel,
    double? width,
    double? height,
    bool showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
  }) {
    AssetEntity entity = imageChooseModel.assetEntity!;

    // ImageProvider imageProvider = AssetEntityImageProvider(
    //   entity,
    //   isOriginal: false,
    // );
    return AssetEntityWidget(
      assetEntity: entity,
      showCenterIconIfVideo: showCenterIconIfVideo,
    );
  }

  static Widget _getCustomImageWidget_compressPath<T extends ImageChooseBean>({
    required BuildContext context,
    required T imageChooseModel,
    double? width,
    double? height,
    bool showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
  }) {
    String imagePath = imageChooseModel.compressImageBean!.compressPath!;
    Image image = Image.file(File(imagePath));

    // imageProvider = image.image;
    // // imageProvider = AssetImage(photoAlbumPath);

    return Image(
      image: image.image,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  static Widget _getCustomImageWidget_networkUrl<T extends ImageChooseBean>({
    required BuildContext context,
    required T imageChooseModel,
    double? width,
    double? height,
    void Function(String lastImageUrl)? lastImageUrlGetBlock, // 获取最后显示的url(打印用)
    bool showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
  }) {
    String imageUrl = imageChooseModel.networkUrl!;
    // imageProvider = NetworkImage(imageUrl);
    // imageProvider = CachedNetworkImageProvider(imageUrl);

    UploadMediaType mediaType = imageChooseModel.mediaType;
    if (mediaType == UploadMediaType.video) {
      return NetworkVideoWidget(
        networkUrl: imageUrl,
        showCenterIcon: showCenterIconIfVideo,
      );
    }

    return TolerantNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      width: width,
      height: height,
      lastImageUrlGetBlock: lastImageUrlGetBlock,
    );
  }
}
