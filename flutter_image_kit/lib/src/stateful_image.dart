/*
 * @Author: dvlproad
 * @Date: 2022-07-22 15:26:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-24 16:06:44
 * @Description: 图片403、404错误不上报(TODO:暂未实现)
 */
// 参考文章:[Flutter cached_network_image图片缓存异常/加载失败优化 403\404](https://www.cnblogs.com/maqingyuan/p/13717437.html)
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './image.dart';
import './data_vientiane.dart';

class StatefulImage extends StatefulWidget {
  ImageDealType? imageDealType;
  void Function(String lastImageUrl)? lastImageUrlGetBlock; // 获取最后显示的url(打印用)

  final double? prepageImageWidth; // 前一个页面图片的点宽高(用于先提前用前一页图片展示)
  final double? prepageImageHeight; // 前一个页面图片的点宽高(用于先提前用前一页图片展示)

  final double? width;
  final double? height;

  final String imageUrl;

  final BoxFit? fit;

  final PlaceholderWidgetBuilder? placeholder;
  final LoadingErrorWidgetBuilder? errorWidget;

  /// The duration of the fade-in animation for the [placeholder].
  final Duration? placeholderFadeInDuration;

  /// The duration of the fade-out animation for the [placeholder].
  final Duration? fadeOutDuration;

  /// The duration of the fade-in animation for the [imageUrl].
  final Duration? fadeInDuration;

  /// Widget displayed while the target [imageUrl] is loading.
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  StatefulImage({
    Key? key,
    this.imageDealType,
    this.lastImageUrlGetBlock,
    this.prepageImageWidth,
    this.prepageImageHeight,
    this.width,
    this.height,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.placeholderFadeInDuration,
    this.fadeOutDuration,
    this.fadeInDuration,
    this.progressIndicatorBuilder,
  }) : super(key: key);

  @override
  State<StatefulImage> createState() => _StatefulImageState();
}

class _StatefulImageState extends State<StatefulImage> {
  late ImageProvider _imageProvider;
  bool imgCheck = true;

  @override
  void initState() {
    super.initState();

    _imageProvider = NetworkImage(widget.imageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(CachedNetworkImageProvider(widget.imageUrl), context,
        onError: (e, stackTrace) {
      print(('Image failed to load with error：$e'));
      setState(() {
        imgCheck = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseTolerantNetworkImage(
      width: widget.width,
      height: widget.height,
      imageUrl: DataVientiane.newImageUrl(
        widget.imageUrl,
        widget.imageDealType ?? ImageDealType.default2,
        width: widget.width,
        height: widget.height,
        lastImageUrlGetBlock: widget.lastImageUrlGetBlock,
      ),
      fit: widget.fit,
      placeholder: widget.placeholder,
      errorWidget: widget.errorWidget,
      placeholderFadeInDuration: widget.placeholderFadeInDuration,
      fadeOutDuration: widget.fadeOutDuration,
      fadeInDuration: widget.fadeInDuration,
      progressIndicatorBuilder: widget.progressIndicatorBuilder,
    );
  }
}
