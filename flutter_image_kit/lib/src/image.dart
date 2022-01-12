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

  TolerantNetworkImage({
    this.width,
    this.height,
    this.imageUrl,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
        errorWidget: errorWidget,
      );
    } else {
      return Container(
        width: width,
        height: height,
        color: Color(0xFFF2F2F2),
      );
    }
  }
}
