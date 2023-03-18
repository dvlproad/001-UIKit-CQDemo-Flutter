import 'dart:io';

import 'package:flutter_media_picker/flutter_media_picker.dart';
import 'package:flutter/material.dart';
import 'package:tsdemo_player/tsdemo_player.dart';
import 'package:video_player/video_player.dart';

import 'package:flutter_image_process/flutter_image_process.dart';

typedef OnChangeFrameListener = void Function(ImageChooseBean? image);

class VideoFrameBar extends StatefulWidget {
  final AppImageChooseBean video;
  final List<File> images;
  final OnChangeFrameListener? listener;
  final BJPlayerController? controller;
  final ImageChooseBean? customChooseCover;
  final VideoPlayerController? videoController;
  final Function(double)? onDragUpdate;

  const VideoFrameBar(
      {Key? key,
      required this.video,
      required this.images,
      required this.customChooseCover,
      this.listener,
      required this.controller,
      required this.videoController,
      this.onDragUpdate})
      : super(key: key);

  @override
  State<VideoFrameBar> createState() => _VideoFrameBarState();
}

class _VideoFrameBarState extends State<VideoFrameBar>
    with SingleTickerProviderStateMixin {
  double _currentPosition = 0.0;

  int _textureId = -1;

  ImageProvider? _currentFrameImageProvider;

  late AnimationController animationController;

  bool init = false;

  double get aspectRatio {
    if (Platform.isAndroid) {
      return widget.controller!.videoWidth / widget.controller!.videoHeight;
    } else {
      return widget.videoController!.value.aspectRatio;
    }
  }

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      widget.controller!.textureId.then((value) {
        _textureId = value ?? -1;
        setState(() {});
      });
    }
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));

    initCover();
  }

  void initCover() async {
    if (widget.customChooseCover != null &&
        widget.customChooseCover!.frameDuration < 0) {
      // 上传的图片
      _currentFrameImageProvider = widget.customChooseCover!.imageProvider;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrained) {
      var width = (constrained.maxWidth - 13) / (6 + 1);
      if (_currentFrameImageProvider != null) {
        return _renderChooseImage(width);
      }
      initCoverPosition(width);
      return Row(
        children: [
          renderUploadBtn(width),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.images.isNotEmpty)
                  Row(
                      children: widget.images
                          .map<Widget>((e) => _renderFrameThumb(width, e))
                          .toList())
                else
                  Container(),
                if (widget.images.isNotEmpty) _renderCurrentFrameBox(width),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    debugPrint('onTapDown');
                    _changFrame(width, details.localPosition.dx);
                  },
                  onTapUp: (TapUpDetails detail) {
                    debugPrint('onTapUp');
                    _changFrame(width, detail.localPosition.dx);
                  },
                  onHorizontalDragStart: (DragStartDetails details) {
                    _changFrame(width, details.localPosition.dx);
                    animationController.forward();
                  },
                  onHorizontalDragUpdate: (DragUpdateDetails details) {
                    _changFrame(width, details.localPosition.dx);
                  },
                  onHorizontalDragEnd: (DragEndDetails details) {
                    animationController.reverse();
                  },
                  onHorizontalDragCancel: () {
                    animationController.reverse();
                  },
                  child: Container(
                    height: width,
                    width: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  void initCoverPosition(double width) {
    if (!init && widget.customChooseCover != null && _getVideoDuration() != 0) {
      var allWidth = width * 6;
      var process =
          widget.customChooseCover!.frameDuration / _getVideoDuration();
      _currentPosition = (allWidth * process) - (width / 2);
      _currentPosition = _currentPosition.clamp(0, width * 5);
      init = true;
    }
  }

  Container _renderFrameThumb(double width, File e) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(widget.images.indexOf(e) == 0 ? 4 : 0),
              bottomLeft:
                  Radius.circular(widget.images.indexOf(e) == 0 ? 4 : 0),
              topRight: Radius.circular(
                  widget.images.indexOf(e) == widget.images.length - 1 ? 4 : 0),
              bottomRight: Radius.circular(
                  widget.images.indexOf(e) == widget.images.length - 1
                      ? 4
                      : 0)),
          image: DecorationImage(image: FileImage(e), fit: BoxFit.cover)),
      foregroundDecoration: const BoxDecoration(color: Color(0x33000000)),
    );
  }

  // 更改封面框位置
  void _changFrame(double width, double localX) async {
    var allWidth = width * widget.images.length;
    _currentPosition =
        (localX - width / 2).clamp(0, width * widget.images.length - width);

    var videoDuration = _getVideoDuration();
    var positionDuration =
        (videoDuration * localX / allWidth).clamp(0.01, videoDuration - 0.01);
    debugPrint('positionDuration:$positionDuration');

    if (Platform.isAndroid) {
      await widget.controller!.seek(positionDuration);
      widget.controller!.currentDuration = positionDuration;
      widget.controller!.pause();
    } else {
      widget.videoController!
          .seekTo(Duration(milliseconds: (positionDuration * 1000).toInt()));
    }

    setState(() {});
    widget.onDragUpdate?.call(positionDuration);
  }

  GestureDetector renderUploadBtn(double width) {
    return GestureDetector(
      onTap: () {
        PickUtil.chooseOneMedia(
          context,
          pickAllowType: PickPhotoAllowType.imageOnly,
          completeBlock: (ImageChooseBean item) async {
            _currentFrameImageProvider = item.imageProvider;
            widget.listener?.call(item);
            setState(() {});
          },
        );
      },
      child: Container(
        width: width,
        height: width,
        margin: const EdgeInsets.only(right: 13),
        decoration: BoxDecoration(
          color: const Color(0xFF363738),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            SizedBox(
              height: 2,
            ),
            Text(
              "上传封面",
              style: TextStyle(fontSize: 10, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  _renderCurrentFrameBox(double width) {
    double realWidgetWidth = width;
    double realWidgetHeight = width;
    double top = 0;
    double left = 0;

    if (aspectRatio != null && !aspectRatio.isNaN) {
      // 处理texture cover显示
      if (aspectRatio > 1) {
        realWidgetHeight = width;
        realWidgetWidth = realWidgetHeight * aspectRatio;
        left = -((realWidgetWidth - width) / 2) - 2;
      } else {
        realWidgetWidth = width;
        realWidgetHeight = realWidgetWidth / aspectRatio;
        top = -((realWidgetHeight - width) / 2) - 2;
      }
    }

    return Positioned(
      top: 0,
      left: _currentPosition,
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeIn))
            .animate(animationController),
        child: Container(
          width: width,
          height: width,
          margin: const EdgeInsets.only(right: 13),
          decoration: BoxDecoration(
            color: const Color(0xFF363738),
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(4),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned(
                  top: top,
                  left: left,
                  child: SizedBox(
                      width: realWidgetWidth,
                      height: realWidgetHeight,
                      child: _renderTexture()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderTexture() {
    if (Platform.isAndroid) {
      return Texture(textureId: _textureId);
    }
    if (widget.videoController != null) {
      return Texture(textureId: widget.videoController!.textureId);
    }
    return Container();
  }

  Widget _renderChooseImage(double width) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6, right: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image(
              image: _currentFrameImageProvider!,
              width: width,
              height: width,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              _currentFrameImageProvider = null;
              widget.listener?.call(null);
              setState(() {});
            },
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 12,
              ),
            ),
          ),
        )
      ],
    );
  }

  double _getVideoDuration() {
    num duration =
        widget.video.assetEntity?.duration ?? widget.video.videoDuration;
    if (duration == 0) {
      if (Platform.isAndroid) {
        duration = widget.controller?.videoDuration ?? 0;
      } else {
        duration =
            (widget.videoController?.value.duration.inMilliseconds ?? 0) / 1000;
      }
    }
    return duration.toDouble();
  }
}
