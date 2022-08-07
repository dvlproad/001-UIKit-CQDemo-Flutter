/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-06 11:58:03
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_images_action_list/flutter_images_action_list.dart'
    show CQImageBaseGridCell;
// import 'package:image_pickers/image_pickers.dart';
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;

import 'package:flutter_image_kit/flutter_image_kit.dart';

import '../bean/image_choose_bean.dart';
import '../preview/widget/asset_entity_widget.dart';
import '../preview/widget/network_video_widget.dart';

import '../image_compress_util/assetEntity_info_getter.dart';

class CQImageOrPhotoGridCell extends StatelessWidget {
  final double? width;
  final double? height;
  final double? cornerRadius;
  final ImageChooseBean imageChooseModel;

  final int index;
  final String? flagText;
  final VoidCallback onPressed;

  CQImageOrPhotoGridCell({
    Key? key,
    this.width,
    this.height,
    this.cornerRadius,
    required this.imageChooseModel, // 类型可为 AssetEntity 或 String
    required this.index,
    this.flagText,
    required this.onPressed,
  }) : super(key: key);

  String? _lastNetworImagekUrl;
  Widget _getCustomImageWidget(BuildContext context) {
    if (imageChooseModel.assetEntity != null) {
      AssetEntity entity = imageChooseModel.assetEntity!;

      // ImageProvider imageProvider = AssetEntityImageProvider(
      //   entity,
      //   isOriginal: false,
      // );
      return AssetEntityWidget(assetEntity: entity);
    } else if (imageChooseModel.networkUrl != null &&
        imageChooseModel.networkUrl!.isNotEmpty) {
      String imageUrl = imageChooseModel.networkUrl!;
      // imageProvider = NetworkImage(imageUrl);
      // imageProvider = CachedNetworkImageProvider(imageUrl);

      UploadMediaType mediaType = imageChooseModel.mediaType;
      if (mediaType == UploadMediaType.video) {
        return NetworkVideoWidget(
          networkUrl: imageUrl,
          showCenterIcon: true,
        );
      }

      return TolerantNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: width,
        height: height,
        lastImageUrlGetBlock: (String lastImageUrl) {
          _lastNetworImagekUrl = lastImageUrl;
        },
      );
    } else if (imageChooseModel.compressImageBean != null &&
        imageChooseModel.compressImageBean!.compressPath != null) {
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
    } else {
      // String imagePath = imageChooseModel.assetEntityPath;
      // Image image = Image.file(File(imagePath));
      // imageProvider = image.image;
      // // imageProvider = AssetImage(photoAlbumPath);
      // imagePathOrUrl = imagePath;

      return Container();
    }
  }

  Widget _getLastCustomImageWidget(BuildContext context) {
    bool showFlagView = flagText != null && flagText!.isNotEmpty;

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
        width: constraints.maxWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: [
            _getCustomImageWidget(context),
            Positioned(
              left: 2,
              bottom: 2,
              child: Visibility(
                visible: flagText != null && flagText!.isNotEmpty,
                child: ThemeBGButton(
                  width: 50,
                  height: 20,
                  cornerRadius: 10,
                  bgColorType: ThemeBGType.theme,
                  title: flagText ?? '',
                  // titleStyle: RegularTextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget customImageWidget = _getLastCustomImageWidget(context);

    return CQImageBaseGridCell(
      width: width,
      height: height,
      cornerRadius: this.cornerRadius ?? 8,
      customImageWidget: customImageWidget,
      message: '',
      index: this.index,
      onTap: this.onPressed,
      onDoubleTap: () async {
        // 以下代码纯测试，实际生产中没用
        List<String> pathOrUrls = [];

        String? assetEntityFilePath;
        if (imageChooseModel.assetEntity != null) {
          /// 危险！！！！获取相册的文件流，此方法会产生极大的内存开销，请勿连续调用比如在for中
          File? file = await AssetEntityInfoGetter.getAssetEntityFile(
              imageChooseModel.assetEntity!);
          if (file != null) {
            assetEntityFilePath = file.path;
            if (assetEntityFilePath != null) {
              pathOrUrls.add('本地路径:${assetEntityFilePath}');
            }
          }
        }

        if (_lastNetworImagekUrl != null) {
          pathOrUrls.add('网络路径:${_lastNetworImagekUrl}');
        }

        String? compressPath;
        if (imageChooseModel.compressImageBean != null) {
          compressPath = imageChooseModel.compressImageBean!.compressPath;
          if (compressPath != null) {
            pathOrUrls.add('压缩路径:${compressPath}');
          }
        }

        String pathOrUrlString = pathOrUrls.join('\n');
        Clipboard.setData(ClipboardData(text: pathOrUrlString));
      },
    );

    // if (imageChooseModel is Media) {
    //   Media media = imageChooseModel;

    //   Image image = Image.file(
    //     File(media.thumbPath),
    //     width: 90,
    //     height: 90,
    //     fit: BoxFit.cover,
    //   );
    //   ImageProvider imageProvider = image.image;

    //   return GestureDetector(
    //     onTap: onPressed,
    //     child: ClipRRect(
    //       borderRadius: BorderRadius.circular(8),
    //       child: image,
    //     ),
    //   );
    // }
  }
}
