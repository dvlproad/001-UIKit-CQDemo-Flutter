/*
 * @Author: dvlproad
 * @Date: 2022-06-20 18:46:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-04 18:13:46
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_player/tsdemo_player.dart';

class NetworkVideoWidget extends StatefulWidget {
  final double? width;
  final double? height;
  final String? networkUrl;
  final String? fileUrl;
  final bool showCenterIcon;
  final bool shouldDirectPlay;

  const NetworkVideoWidget({
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
  late BJPlayerController _controller;
  bool _showCenterIcon = false;

  @override
  void dispose() {
    _controller.releasePlayer();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _showCenterIcon = widget.showCenterIcon;
    initPlayer();
  }

  void initPlayer() {
    _controller = BJPlayerController();
    _controller.setLoop(true);
    var videoModel = SuperPlayerModel();
    videoModel.videoURL = (widget.fileUrl ?? widget.networkUrl)!;
    _controller.playWithModel(videoModel);
  }

  @override
  Widget build(BuildContext context) {
    return _videoAssetWidget(context);
  }

  Widget _videoAssetWidget(BuildContext context) {
    return Stack(
      children: <Widget>[
        _imageAssetWidget(context),
        Visibility(
          visible: _showCenterIcon,
          child: ColoredBox(
            color: Theme.of(context).dividerColor.withOpacity(0.3),
            child: const Center(
              child: Icon(
                Icons.video_library,
                color: Colors.white,
                size: 16.0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _imageAssetWidget(BuildContext context) {
    return BJVideoPlayerView(
      controller: _controller,
      needPlayBtn: false,
    );
  }

  void playOrPause() {
    setState(() {
      _controller.playerState == SuperPlayerState.PLAYING
          ? _controller.pause()
          : _controller.resume();
    });
  }
}
