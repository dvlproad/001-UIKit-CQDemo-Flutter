// ignore_for_file: unused_import, non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-19 16:15:26
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_image_basekit/flutter_image_kit.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

import './asset_entity_widget.dart';

class ImageChooseBeanBaseView<T extends ImageChooseBean>
    extends StatelessWidget {
  final T imageChooseModel;
  final double? width;
  final double? height;

  final Widget Function(BuildContext context) networkVideoWidgetBuilder;
  final void Function(String lastImageUrl)? lastImageUrlGetBlock;
  final bool showCenterIconIfVideo;

  const ImageChooseBeanBaseView({
    Key? key,
    required this.imageChooseModel,
    this.width,
    this.height,
    required this.networkVideoWidgetBuilder,
    this.lastImageUrlGetBlock, // 获取最后显示的url(打印用)
    this.showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageChooseModel.assetEntity != null) {
      return _getCustomImageWidget_assetEntity(
        context,
      );
    } else if (imageChooseModel.networkUrl != null &&
        imageChooseModel.networkUrl!.isNotEmpty) {
      return _getCustomImageWidget_networkUrl(context);
    } else if (imageChooseModel
            .currentCompressedImageOrVideoThumbnailProvider !=
        null) {
      return _getCustomImageWidget_compressImageProvider(
          imageChooseModel.currentCompressedImageOrVideoThumbnailProvider!);
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

  Widget _getCustomImageWidget_assetEntity(BuildContext context) {
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

  Widget _getCustomImageWidget_compressImageProvider(
      ImageProvider compressImageProvider) {
    return Image(
      image: compressImageProvider,
      fit: BoxFit.cover,
      width: width,
      height: height,
    );
  }

  Widget _getCustomImageWidget_networkUrl(BuildContext context) {
    String imageUrl = imageChooseModel.networkUrl!;
    // imageProvider = NetworkImage(imageUrl);
    // imageProvider = CachedNetworkImageProvider(imageUrl);

    UploadMediaType mediaType = imageChooseModel.mediaType;
    if (mediaType == UploadMediaType.video) {
      // return NetworkVideoWidget(
      //   networkUrl: imageUrl,
      //   showCenterIcon: showCenterIconIfVideo,
      // );
      return networkVideoWidgetBuilder(context);
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
