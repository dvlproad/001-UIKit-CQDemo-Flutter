import 'dart:async';
import 'dart:io';

import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:tsdemo_player/tsdemo_player.dart';
import 'package:video_player/video_player.dart';
// ignore: implementation_imports
import 'package:flutter_effect_kit/src/hud/loading_widget.dart';

// import '../../app_images_action_image_pickers.dart';

import 'package:flutter_image_process/flutter_image_process.dart';
import './widget/video_frame_bar.dart';

class ChooseFramePage extends StatefulWidget {
  final AppImageChooseBean video;
  final OnChangeFrameListener onSubmit;

  final ImageChooseBean? customChooseCover;

  const ChooseFramePage({
    Key? key,
    required this.video,
    required this.onSubmit,
    required this.customChooseCover,
  }) : super(key: key);

  @override
  State<ChooseFramePage> createState() => _ChooseFramePageState();
}

class _ChooseFramePageState extends State<ChooseFramePage> {
  List<File> list = [];
  ImageProvider? _currentFrameImageProvider;
  ImageChooseBean? _currentImageBean;
  BJPlayerController? _controller;
  VideoPlayerController? _videoController;
  bool _hasNewImageFromAlbum = false;
  bool _hasNewImageFromVideo = false;

  bool _showLoadingForFrame = true;
  bool _showLoadingForCover = true;

  bool _needCover = false;

  StreamSubscription<Map>? _subscription;

  Timer? _timer;
  @override
  void initState() {
    super.initState();
    _initFrame();
    _initController();

    // 如果已有封面
    if (widget.customChooseCover != null &&
        widget.customChooseCover!.frameDuration < 0) {
      _currentImageBean = widget.customChooseCover;
      // 上传的图片
      _currentFrameImageProvider = _currentImageBean!.imageProvider;
    }

    // 有封面先显示封面，延迟500毫秒后取消显示，避免视频加载时黑屏
    if (widget.customChooseCover?.imageProvider != null) {
      _needCover = true;
      Future.delayed(const Duration(milliseconds: 500)).then((value) {
        _needCover = false;
        setState(() {});
      });
    }
    if (Platform.isAndroid) {
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        if (_controller != null &&
            _controller!.playerState == SuperPlayerState.PLAYING) {
          _controller!.pause();
        }
      });
    }
  }

  // 初始化获取视频帧
  void _initFrame({int tryCount = 1}) {
    if (tryCount > 3) {
      _showLoadingForFrame = false;
      if (mounted) {
        setState(() {});
      }
      ToastUtil.showMessage("视频帧获取失败。");
      debugPrint('视频帧获取失败，请重试。已经重试$tryCount次');
      return;
    }
    widget.video.getVideoFrameBeans().then((value) {
      list = value.map((e) => File(e.compressPath!)).toList();
      _showLoadingForFrame = false;
      if (mounted) {
        setState(() {});
      }
    }).catchError((e) async {
      await Future.delayed(const Duration(seconds: 1));
      // 重试
      _initFrame(tryCount: ++tryCount);
    });
  }

  void _initVideoPlayerController() async {
    File file = await widget.video.assetEntity?.file ??
        File(widget.video.compressVideoBean!.compressPath ??
            widget.video.compressVideoBean!.originPath);
    _videoController = VideoPlayerController.file(file)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        if (widget.customChooseCover != null &&
            widget.customChooseCover!.frameDuration >= 0) {
          _videoController!.seekTo(Duration(
              milliseconds:
                  (widget.customChooseCover!.frameDuration * 1000).toInt()));
        }
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: MediaQuery.of(context).padding.top + 56,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                color: Colors.black,
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text(
                            "取消",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "选择封面",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: _submit,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: const Color(0xffff7f00)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: const Text(
                              "下一步",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: _renderFrame(),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).padding.bottom + 20,
                        top: 12)
                    .add(const EdgeInsets.symmetric(horizontal: 14)),
                width: double.infinity,
                color: Colors.black,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _currentFrameImageProvider == null
                          ? "左右拖动选择最适合的封面"
                          : "已选择封面",
                      style: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    VideoFrameBar(
                      video: widget.video,
                      images: list,
                      controller: _controller,
                      videoController: _videoController,
                      customChooseCover: widget.customChooseCover,
                      listener: (ImageChooseBean? bean) async {
                        _currentImageBean = bean;
                        _currentFrameImageProvider =
                            _currentImageBean?.imageProvider;
                        _hasNewImageFromAlbum = true;
                        if (mounted) {
                          setState(() {});
                        }
                      },
                      onDragUpdate: (position) {
                        _hasNewImageFromVideo = true;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Visibility(
              visible: _showLoadingForFrame || _showLoadingForCover,
              child: Center(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: LoadingWidget(
                    loadingFor: LoadingFor.videoPalyer,
                  ),
                ),
              ))
        ],
      ),
    );
  }

  Widget _renderFrame() {
    if (_currentFrameImageProvider != null) {
      return ExtendedImage(
        image: _currentFrameImageProvider!,
        loadStateChanged: (ExtendedImageState state) {
          if (state.extendedImageLoadState == LoadState.loading) {
            _showLoadingForCover = true;
            Future.delayed(const Duration(milliseconds: 50)).then((value) {
              if (mounted) {
                setState(() {});
              }
            });
          } else if (state.extendedImageLoadState == LoadState.completed) {
            Future.delayed(const Duration(milliseconds: 200)).then((value) {
              if (mounted) {
                setState(() {
                  _showLoadingForCover = false;
                });
              }
            });
          }
          return ExtendedImage(image: state.imageProvider);
        },
      );
    }
    Future.delayed(const Duration(milliseconds: 200)).then((value) {
      if (!_showLoadingForCover) return;
      if (mounted) {
        setState(() {
          _showLoadingForCover = false;
        });
      }
    });
    if (Platform.isIOS) {
      if (_videoController != null) {
        return _videoController!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              )
            : Container();
      }
      return Container();
    } else {
      return BJVideoPlayerView(
        controller: _controller!,
        coverImageProvider: _currentFrameImageProvider,
        needPlayBtn: false,
        needLoading: false,
        needCover: _needCover,
      );
    }
  }

  void _submit() async {
    // 未选择新封面且之前已有封面
    if (!_hasNewImageFromAlbum &&
        !_hasNewImageFromVideo &&
        _currentImageBean != null) {
      Navigator.pop(context);
      return;
    }
    // 从相册里选择新图片封面
    if (_hasNewImageFromAlbum && _currentImageBean != null) {
      widget.onSubmit.call(_currentImageBean);
      Navigator.pop(context);
      return;
    }
    _showLoadingForFrame = true;
    setState(() {});
    // 截取帧时间位置
    double duration = Platform.isAndroid
        ? _controller!.currentDuration
        : _videoController!.value.position.inMilliseconds / 1000;
    debugPrint('选中视频帧当做封面，帧位置: $duration');
    File? file;
    if (widget.video.assetEntity != null) {
      file = await widget.video.assetEntity!.file;
    } else {
      file = File(widget.video.compressVideoBean?.compressPath ??
          widget.video.compressVideoBean?.originPath ??
          "");
    }
    ImageChooseBean? bean = await _cutFrame(file!, duration);
    if (bean == null) {
      return;
    } else {
      widget.onSubmit.call(bean);
      Navigator.pop(context);
    }
  }

  Future<ImageChooseBean?> _cutFrame(File file, double duration,
      {int tryCount = 1}) async {
    if (tryCount > 3) {
      _showLoadingForFrame = false;
      setState(() {});
      ToastUtil.showMessage("视频帧获取失败。");
      debugPrint('视频帧获取失败，请重试。已经重试$tryCount次');
      return null;
    }
    try {
      ImageCompressBean? imageCompressBean =
          await AssetEntityVideoThumbUtil.getVideoFrameBean(file,
              position: duration);
      imageCompressBean?.originPathOrUrl =
          imageCompressBean.compressPath ?? ""; // 防止上次封面失败
      debugPrint(
          '提交：${imageCompressBean?.compressPath}，${imageCompressBean?.compressInfoProcess},$duration');
      var width = widget.video.assetEntity?.width ?? widget.video.width;
      var height = widget.video.assetEntity?.height ?? widget.video.height;

      ImageChooseBean bean = ImageChooseBean(width: width, height: height);
      bean.compressImageBean = imageCompressBean;
      bean.frameDuration = duration;
      return bean;
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      return _cutFrame(file, duration, tryCount: ++tryCount);
    }
  }

  @override
  void dispose() {
    _controller?.releasePlayer();
    _videoController?.dispose();
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  // 初始化播放器控制器，因为播放器平台原因，需要分开初始化
  void _initController() {
    if (Platform.isAndroid) {
      _initSuperPlayerController();
    } else {
      _initVideoPlayerController();
    }
  }

  Future<void> _initSuperPlayerController() async {
    _controller = BJPlayerController();
    // 安卓设备启动硬解会有花屏现象
    await _controller!.enableHardwareDecode(false);
    FTXVodPlayConfig config = FTXVodPlayConfig();
    config.progressInterval = 200;
    _controller!.setPlayConfig(config);
    if (widget.video.assetEntity != null) {
      widget.video.assetEntity?.file.then((value) {
        var videoModel = SuperPlayerModel();
        videoModel.videoURL = value!.path;
        if (Platform.isAndroid) {
          videoModel.playAction = SuperPlayerModel.PLAY_ACTION_PRELOAD;
        }
        _controller!.playWithModel(videoModel);
      });
    } else {
      var videoModel = SuperPlayerModel();
      videoModel.videoURL = widget.video.compressVideoBean!.compressPath!;
      if (Platform.isAndroid) {
        videoModel.playAction = SuperPlayerModel.PLAY_ACTION_PRELOAD;
      }
      _controller!.playWithModel(videoModel);
    }
    _registerListener();
  }

  void _registerListener() {
    _subscription = _controller?.onPlayerEventBroadcast.listen((event) async {
      int eventCode = event['event'];
      switch (eventCode) {
        case TXVodPlayEvent.PLAY_EVT_VOD_PLAY_PREPARED:
          if (widget.customChooseCover != null &&
              widget.customChooseCover!.frameDuration >= 0) {
            _controller!.seek(widget.customChooseCover!.frameDuration);
          }
          break;
        case TXVodPlayEvent.PLAY_ERR_HEVC_DECODE_FAIL:
          debugPrint('h265视频解码失败，尝试启动硬解');
          await _controller!.enableHardwareDecode(true);
          _controller!.pause();
          break;
      }
    });
  }
}
