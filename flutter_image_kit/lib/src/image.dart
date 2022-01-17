// 兼容错误的 图片视图
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TolerantNetworkImage extends StatelessWidget {
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

  TolerantNetworkImage({
    this.width,
    this.height,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.placeholderFadeInDuration = Duration.zero,
    this.fadeOutDuration = Duration.zero,
    this.fadeInDuration = Duration.zero,
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
        placeholderFadeInDuration: placeholderFadeInDuration,
        fadeOutDuration: fadeOutDuration,
        fadeInDuration: fadeInDuration,
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
