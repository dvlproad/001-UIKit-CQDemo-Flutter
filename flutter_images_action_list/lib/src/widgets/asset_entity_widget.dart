/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-18 15:05:32
 * @Description: 图片选择器的单元视图
 */
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart'
    show AssetEntity, AssetEntityImageProvider, AssetType;

class AssetEntityWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final AssetEntity assetEntity;
  final bool showCenterIconIfVideo;
  final bool isDisplayingDetail;

  const AssetEntityWidget({
    Key? key,
    this.width,
    this.height,
    required this.assetEntity,
    this.showCenterIconIfVideo = true, // 是视频文件的时候是否在中间显示icon播放图标
    this.isDisplayingDetail = false,
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
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
    );
  }

  Widget _videoAssetWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0, // 设置子组件的宽高比为1:1,避免显示不全
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: _imageAssetWidget(context)),
          ColoredBox(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            child: showCenterIconIfVideo == true
                ? Center(
                    child: Icon(
                      Icons.video_library,
                      color: Colors.white,
                      size: isDisplayingDetail ? 24.0 : 16.0,
                    ),
                  )
                : Container(),
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
