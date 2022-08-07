/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:13:46
 * @Description: 
 */
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class NetworkVideoWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String? networkUrl;
  final String? fileUrl;
  final bool showCenterIcon;
  final bool shouldDirectPlay;

  NetworkVideoWidget({
    Key? key,
    this.width,
    this.height,
    this.networkUrl,
    this.fileUrl,
    this.showCenterIcon = false, // 是否显示视频缩略图中间的icon
    this.shouldDirectPlay = false,
  })  : assert(fileUrl != null || networkUrl != null),
        super(key: key);

  @override
  NetworkVideoWidgetState createState() => NetworkVideoWidgetState();
}

class NetworkVideoWidgetState extends State<NetworkVideoWidget> {
  late VideoPlayerController _controller;
  bool _showCenterIcon = false;

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _showCenterIcon = widget.showCenterIcon;

    if (widget.fileUrl != null) {
      _controller = VideoPlayerController.file(File(widget.fileUrl!));
    } else {
      _controller = VideoPlayerController.network(widget.networkUrl!);
    }

    _controller.initialize().then((_) {
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() {});

      if (widget.shouldDirectPlay == true) {
        _controller.play();
        _controller.setLooping(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _videoAssetWidget(context);
  }

  Widget _videoAssetWidget(BuildContext context) {
    return AspectRatio(
      aspectRatio:
          1.0, // _controller.value.aspectRatio, // 设置子组件的宽高比为1:1,避免显示不全
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: _imageAssetWidget(context)),
          Visibility(
            visible: _showCenterIcon,
            child: ColoredBox(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              child: Center(
                child: Icon(
                  Icons.video_library,
                  color: Colors.white,
                  size: 16.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageAssetWidget(BuildContext context) {
    return Container(
      // width: widget.width,
      // height: widget.height,
      child: Center(
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            : Container(),
      ),
    );
  }

  void playOrPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
    _controller.setLooping(true);
  }
}
