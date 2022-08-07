// 兼容错误的 图片视图
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './data_vientiane.dart';

/// [图片处理方式:快速缩略模板](https://cloud.tencent.com/document/product/460/6929)
/// [图片处理方式:数据万象]https://cloud.tencent.com/document/product/460/36542
class TolerantNetworkImage extends BaseTolerantNetworkImage {
  TolerantNetworkImage({
    Key? key,
    ImageDealType? imageDealType,
    double? width,
    double? height,
    required String imageUrl,
    void Function(String lastImageUrl)? lastImageUrlGetBlock, // 获取最后显示的url(打印用)
    BoxFit? fit,
    PlaceholderWidgetBuilder? placeholder,
    LoadingErrorWidgetBuilder? errorWidget,
    Duration? placeholderFadeInDuration,
    Duration? fadeOutDuration,
    Duration fadeInDuration = Duration.zero,
    ProgressIndicatorBuilder? progressIndicatorBuilder,
  }) : super(
          key: key,
          width: width,
          height: height,
          imageUrl: DataVientiane.newImageUrl(
            imageUrl,
            imageDealType ?? ImageDealType.default2,
            width: width,
            height: height,
            lastImageUrlGetBlock: lastImageUrlGetBlock,
          ),
          fit: fit,
          placeholder: placeholder,
          errorWidget: errorWidget,
          placeholderFadeInDuration: placeholderFadeInDuration,
          fadeOutDuration: fadeOutDuration,
          fadeInDuration: fadeInDuration,
          progressIndicatorBuilder: progressIndicatorBuilder,
        );
}

class BaseTolerantNetworkImage extends StatelessWidget {
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

  BaseTolerantNetworkImage({
    Key? key,
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
  Widget build(BuildContext context) {
    bool urlValid = imageUrl != null && imageUrl.isEmpty == false;
    if (urlValid == true) {
      bool isNetworkUrl = imageUrl.startsWith(RegExp(r'https?:'));
      urlValid = isNetworkUrl;
    }

    if (urlValid) {
      // print("BaseTolerantNetworkImage imageUrl = $imageUrl");
      /*
      return Image(
        image: NetworkImage(imageUrl),
        // image: CachedNetworkImageProvider(imageUrl),
        width: width,
        height: height,
        fit: BoxFit.fill,
      );
      */

      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: imageUrl,
        placeholder: placeholder,
        errorWidget: (context, url, error) {
          if (this.errorWidget != null) {
            return this.errorWidget!(context, url, error);
          } else {
            return Container();
          }
        },
        placeholderFadeInDuration: placeholderFadeInDuration ?? Duration.zero,
        fadeOutDuration: fadeOutDuration ?? Duration.zero,
        fadeInDuration: fadeInDuration ?? Duration.zero,
        progressIndicatorBuilder: (context, url, progress) {
          if (this.progressIndicatorBuilder != null) {
            return this.progressIndicatorBuilder!(context, url, progress);
          } else {
            return Container(color: Color(0xFFF0F0F0));
          }
        },
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Color(0xFFF0F0F0),
      );
    }
  }
}
