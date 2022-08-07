/*
 * @Author: dvlproad
 * @Date: 2022-07-22 15:26:15
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-29 14:05:16
 * @Description: 图片过度(TODO:暂未实现)
 */
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './data_vientiane.dart';
import 'image.dart';

class PreviewAndCurrentImage extends TolerantNetworkImage {
  PreviewAndCurrentImage({
    Key? key,
    ImageDealType? imageDealType,
    double? prepageImageWidth, // 前一个页面图片的点宽高(用于先提前用前一页图片展示)
    double? prepageImageHeight, // 前一个页面图片的点宽高(用于先提前用前一页图片展示)
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
          imageUrl: imageUrl,
          fit: fit,
          placeholder: (BuildContext context, String url) {
            return TolerantNetworkImage(
              imageDealType: imageDealType,
              width: prepageImageWidth,
              height: prepageImageHeight,
              imageUrl: imageUrl,
              fit: fit,
              placeholder: placeholder,
              errorWidget: errorWidget,
              placeholderFadeInDuration: placeholderFadeInDuration,
              fadeOutDuration: fadeOutDuration,
              fadeInDuration: fadeInDuration,
              progressIndicatorBuilder: progressIndicatorBuilder,
            );
          },
          errorWidget: errorWidget,
          placeholderFadeInDuration: placeholderFadeInDuration,
          fadeOutDuration: fadeOutDuration,
          fadeInDuration: fadeInDuration,
          progressIndicatorBuilder: progressIndicatorBuilder,
        );
}

class FadeImage extends StatefulWidget {
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

  FadeImage({
    Key? key,
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
  State<FadeImage> createState() => _FadeImageState();
}

class _FadeImageState extends State<FadeImage> {
  String _prePageImageUrl = '';
  String _currentPageImageUrl = '';

  bool isShowMoney = false;

  @override
  void initState() {
    super.initState();

    if (widget.prepageImageWidth != null && widget.prepageImageWidth! > 0) {
      _getPreAndShow();
      // Future.delayed(const Duration(milliseconds: 2000)).then((value) {
      //   _getCurrentAndShow();
      // });
    } else {
      _getCurrentAndShow();
    }
  }

  void _getPreAndShow() {
    _prePageImageUrl = DataVientiane.newImageUrl(
      widget.imageUrl,
      ImageDealType.default2,
      width: widget.prepageImageWidth,
      height: widget.prepageImageHeight,
      lastImageUrlGetBlock: (String lastImageUrl) {
        debugPrint("lastImageUrl_prev = $lastImageUrl");
      },
    );

    _currentPageImageUrl = _prePageImageUrl;
  }

  void _getCurrentAndShow() {
    _currentPageImageUrl = DataVientiane.newImageUrl(
      widget.imageUrl,
      ImageDealType.default2,
      width: widget.width,
      height: widget.height,
      lastImageUrlGetBlock: (String lastImageUrl) {
        debugPrint("lastImageUrl_cur = $lastImageUrl");
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => isShowMoney = !isShowMoney,
      child: Container(
        padding: EdgeInsets.only(left: 3),
        child: AnimatedCrossFade(
          firstChild: Image.network(
            "https://img1.baidu.com/it/u=1966616150,2146512490&fm=253&fmt=auto&app=138&f=JPEG?w=751&h=500",
            width: 100,
            height: 200,
            fit: BoxFit.contain,
          ),
          secondChild: Image.network(
            "https://img2.baidu.com/it/u=1792249350,650626052&fm=253&fmt=auto&app=120&f=JPEG?w=1200&h=675.png",
            width: 100,
            height: 200,
            fit: BoxFit.contain,
          ),
          crossFadeState: isShowMoney
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: Duration(
            milliseconds: 500,
          ),
        ),
      ),
    );
  }
}
