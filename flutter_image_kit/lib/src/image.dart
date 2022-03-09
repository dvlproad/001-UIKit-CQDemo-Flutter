// 兼容错误的 图片视图
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// [图片处理方式:快速缩略模板](https://cloud.tencent.com/document/product/460/6929)
enum ImageDealType {
  default2, // 默认等比限定缩略图的宽高最小值
  origin, // 原图
}

class TolerantNetworkImage extends BaseTolerantNetworkImage {
  TolerantNetworkImage({
    ImageDealType imageDealType,
    double width,
    double height,
    String imageUrl,
    BoxFit fit,
    PlaceholderWidgetBuilder placeholder,
    LoadingErrorWidgetBuilder errorWidget,
    Duration placeholderFadeInDuration,
    Duration fadeOutDuration,
    Duration fadeInDuration = Duration.zero,
    ProgressIndicatorBuilder progressIndicatorBuilder,
    Key key,
  }) : super(
          key: key,
          width: width,
          height: height,
          imageUrl: newImageUrl(
            imageUrl,
            imageDealType ?? ImageDealType.default2,
            width: width,
            height: height,
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

String newImageUrl(
  String imageUrl,
  ImageDealType imageDealType, {
  double width,
  double height,
}) {
  // https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com
  if (imageDealType == ImageDealType.origin) {
    return imageUrl;
  }

  int index = imageUrl.indexOf('.myqcloud.com');
  bool isCloudImage = index != -1;

  String newImageUrl = imageUrl;
  if (isCloudImage) {
    String thumbnail = '';
    if (width != null && width > 0) {
      thumbnail = '/w/${width * 2}';
    }

    if (height != null && height > 0) {
      thumbnail = '/h/${height * 2}';
    }

    if (thumbnail.isNotEmpty) {
      thumbnail = '/1$thumbnail';
    }

    String webP = 'format/webp';
    newImageUrl = imageUrl + "?imageView2/$webP" + thumbnail;
  }

  return newImageUrl;
}

class BaseTolerantNetworkImage extends StatelessWidget {
  final double width;
  final double height;

  final String imageUrl;

  final BoxFit fit;

  final PlaceholderWidgetBuilder placeholder;
  final LoadingErrorWidgetBuilder errorWidget;

  /// The duration of the fade-in animation for the [placeholder].
  final Duration placeholderFadeInDuration;

  /// The duration of the fade-out animation for the [placeholder].
  final Duration fadeOutDuration;

  /// The duration of the fade-in animation for the [imageUrl].
  final Duration fadeInDuration;

  /// Widget displayed while the target [imageUrl] is loading.
  final ProgressIndicatorBuilder progressIndicatorBuilder;

  BaseTolerantNetworkImage({
    this.width,
    this.height,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.placeholderFadeInDuration,
    this.fadeOutDuration,
    this.fadeInDuration,
    this.progressIndicatorBuilder,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool urlValid = imageUrl != null && imageUrl.isEmpty == false;
    if (urlValid == true) {
      bool isNetworkUrl = imageUrl.startsWith(RegExp(r'https?:'));
      urlValid = isNetworkUrl;
    }

    if (urlValid) {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: imageUrl,
        placeholder: placeholder,
        errorWidget: (context, url, error) {
          if (this.errorWidget != null) {
            return this.errorWidget(context, url, error);
          } else {
            return Container();
          }
        },
        placeholderFadeInDuration: placeholderFadeInDuration ?? Duration.zero,
        fadeOutDuration: fadeOutDuration ?? Duration.zero,
        fadeInDuration: fadeInDuration ?? Duration.zero,
        progressIndicatorBuilder: (context, url, progress) {
          if (this.progressIndicatorBuilder != null) {
            return this.progressIndicatorBuilder(context, url, progress);
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
