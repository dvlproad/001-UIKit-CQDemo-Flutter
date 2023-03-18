// 兼容错误的 图片视图
import 'dart:math';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

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
        gaplessPlayback: true, // //图片路径发生改变后，加载新图片过程中是否显示旧图
      );
      */
      return ExtendedImage.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        cache: true,
        gaplessPlayback: true,
        // clearMemoryCacheWhenDispose: true,
        loadStateChanged: (ExtendedImageState state) {
          return FadeWidget(
            state: state,
            duration: fadeInDuration ?? const Duration(milliseconds: 500),
            progressIndicatorBuilder: progressIndicatorBuilder,
            errorWidgetBuilder: errorWidget,
            imageUrl: imageUrl,
            child: ExtendedRawImage(
              image: state.extendedImageInfo?.image,
              width: width,
              height: height,
              fit: fit,
            ),
          );
        },
      );

      // return CachedNetworkImage(
      //   width: width,
      //   height: height,
      //   fit: fit,
      //   imageUrl: imageUrl,
      //   placeholder: placeholder,
      //   useOldImageOnUrlChange: true,
      //   errorWidget: (context, url, error) {
      //     if (this.errorWidget != null) {
      //       return this.errorWidget!(context, url, error);
      //     } else {
      //       return Container();
      //     }
      //   },
      //   placeholderFadeInDuration: placeholderFadeInDuration ?? Duration.zero,
      //   fadeOutDuration: fadeOutDuration ?? Duration.zero,
      //   fadeInDuration: fadeInDuration ?? Duration(milliseconds: 500),
      //   progressIndicatorBuilder: (context, url, progress) {
      //     if (this.progressIndicatorBuilder != null) {
      //       return this.progressIndicatorBuilder!(context, url, progress);
      //     } else {
      //       return Container(color: Color(0xFFF0F0F0));
      //     }
      //   },
      // );
    } else {
      return Container(
        width: width,
        height: height,
        color: Color(0xFFF0F0F0),
      );
    }
  }
}

class FadeWidget extends StatefulWidget {
  final LoadingErrorWidgetBuilder? errorWidgetBuilder;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final ExtendedImageState state;
  final Duration duration;
  final Widget child;
  final String imageUrl;

  const FadeWidget(
      {Key? key,
      required this.state,
      required this.child,
      this.duration = Duration.zero,
      this.errorWidgetBuilder,
      this.progressIndicatorBuilder,
      required this.imageUrl})
      : super(key: key);

  @override
  State<FadeWidget> createState() => _FadeWidgetState();
}

class _FadeWidgetState extends State<FadeWidget>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController _controller;
  late bool hideWidget;

  late bool _hasCache;

  bool _isControllerDisposed = false;

  ExtendedImageState get state => widget.state;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hideWidget = false;

    _controller = AnimationController(vsync: this, duration: widget.duration);
    final curved = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    opacity = Tween<double>(begin: 0.0, end: 1.0).animate(curved);
    _checkCacheExists();
  }

  Future<void> _checkCacheExists() async {
    _hasCache = false;
    if (widget.state.imageProvider is ExtendedNetworkImageProvider) {
      final ExtendedNetworkImageProvider provider =
          widget.state.imageProvider as ExtendedNetworkImageProvider;
      _hasCache = await cachedImageExists(provider.url);
      if (_hasCache && !_isControllerDisposed) {
        _controller.value = 1.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (state.extendedImageLoadState) {
      case LoadState.loading:
        if (widget.progressIndicatorBuilder != null) {
          return widget.progressIndicatorBuilder?.call(context, widget.imageUrl,
                  DownloadProgress(widget.imageUrl, 0, 0)) ??
              Container();
        }
        return Container(color: const Color(0xFFF0F0F0));
      case LoadState.completed:
        if (!state.wasSynchronouslyLoaded) {
          if (!_hasCache) {
            _controller.forward();
          }
        } else {
          return state.completedWidget;
        }
        return FadeTransition(
          opacity: opacity,
          child: widget.child,
        );
      case LoadState.failed:
        return widget.errorWidgetBuilder?.call(
              context,
              widget.imageUrl,
              state.extendedImageLoadState,
            ) ??
            Container();
    }
    return const SizedBox.shrink();
  }

  @override
  void didUpdateWidget(covariant FadeWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    _isControllerDisposed = true;
    super.dispose();
  }
}
