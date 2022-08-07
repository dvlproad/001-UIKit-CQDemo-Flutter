/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 14:44:29
 * @Description: 图片选择器的单元视图
 */
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_images_action_list/flutter_images_action_list.dart'
    show CQImageBaseGridCell;
// import 'package:image_pickers/image_pickers.dart';
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;

import 'package:flutter_image_kit/flutter_image_kit.dart';

class AssetEntityWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final AssetEntity assetEntity;

  AssetEntityWidget({
    Key? key,
    this.width,
    this.height,
    required this.assetEntity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AssetEntity entity = assetEntity;

    switch (entity.type) {
      case AssetType.audio:
        return _audioAssetWidget(context);
      case AssetType.video:
        return _videoAssetWidget(context);
      case AssetType.image:
      case AssetType.other:
        return _imageAssetWidget(context);
    }
  }

  Widget _imageAssetWidget(BuildContext context) {
    AssetEntity entity = assetEntity;
    ImageProvider imageProvider = AssetEntityImageProvider(
      entity,
      isOriginal: false,
    );

    return Container(
      // color: Colors.red,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
    );
  }

  bool isDisplayingDetail = false;
  Widget _videoAssetWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // 设置子组件的宽高比为1:1,避免显示不全
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: _imageAssetWidget(context)),
          ColoredBox(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            child: Center(
              child: Icon(
                Icons.video_library,
                color: Colors.white,
                size: isDisplayingDetail ? 24.0 : 16.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _audioAssetWidget(BuildContext context) {
    AssetEntity entity = assetEntity;
    return ColoredBox(
      color: Theme.of(context).dividerColor,
      child: Stack(
        children: <Widget>[
          AnimatedPositionedDirectional(
            duration: kThemeAnimationDuration,
            top: 0.0,
            start: 0.0,
            end: 0.0,
            bottom: isDisplayingDetail ? 20.0 : 0.0,
            child: Center(
              child: Icon(
                Icons.audiotrack,
                size: isDisplayingDetail ? 24.0 : 16.0,
              ),
            ),
          ),
          AnimatedPositionedDirectional(
            duration: kThemeAnimationDuration,
            start: 0.0,
            end: 0.0,
            bottom: isDisplayingDetail ? 0.0 : -20.0,
            height: 20.0,
            child: Text(
              entity.title ?? '',
              style: const TextStyle(height: 1.0, fontSize: 10.0),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
