/*
 * @Author: dvlproad
 * @Date: 2023-03-18 22:26:35
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 23:17:23
 * @Description: 
 */

import 'dart:async';

import 'package:flutter/material.dart';

enum SuperPlayerState {
  INIT, // 初始状态
  PLAYING, // 播放中
  PAUSE, // 暂停中
  LOADING, // 缓冲中
  END, // 播放结束
}

// enum SuperPlayerType {
//   VOD,        // 点播
//   LIVE,       // 直播
//   LIVE_SHIFT  // 直播回
// }

class BJPlayerController {
  BJPlayerController();

  SuperPlayerState playerState = SuperPlayerState.INIT;
  // SuperPlayerType playerType = SuperPlayerType.VOD;

  double currentDuration = 0;
  double videoDuration = 0;

  int? _playerId = -1;

  // final Completer<int> _initPlayer;
  // final Completer<int> _createTexture;
  bool _isDisposed = false;
  bool _isNeedDisposed = false;
  // late MethodChannel _channel;
  // TXPlayerValue? _value;
  // TXPlayerState? _state;

  // TXPlayerState? get playState => _state;
  StreamSubscription? _eventSubscription;
  StreamSubscription? _netSubscription;

  // final StreamController<TXPlayerState?> _stateStreamController =
  //     StreamController.broadcast();

  final StreamController<Map<dynamic, dynamic>> _eventStreamController =
      StreamController.broadcast();

  final StreamController<Map<dynamic, dynamic>> _netStatusStreamController =
      StreamController.broadcast();

  // Stream<TXPlayerState?> get onPlayerState => _stateStreamController.stream;
  Stream<Map<dynamic, dynamic>> get onPlayerEventBroadcast =>
      _eventStreamController.stream;
  Stream<Map<dynamic, dynamic>> get onPlayerNetStatusBroadcast =>
      _netStatusStreamController.stream;

  double _seekPos = 0; // 记录切换硬解时的播放时间
  /// 该值会改变新播放视频的播放开始时间点
  double startPos = 0;
  double videoWidth = 0;
  double videoHeight = 0;
  double currentPlayRate = 1.0;

  bool _needPreload = false;

  Future<int> get textureId async {
    return 2;
  }

  /// 设置是否循环播放
  Future<void> setLoop(bool loop) async {
    //
  }

  void _initVodPlayer() async {
    //
  }

  void _checkVodPlayerIsInit() {
    //
  }

  /// 播放视频
  void playWithModel(SuperPlayerModel videoModel) {
    //
  }

  Future<void> _playWithModelInner(SuperPlayerModel videoModel) async {
    //
  }

  Future<void> _sendRequest() async {
    //
  }

  // Future<double> getPlayableDuration() async {
  //   double? playableDuration =
  //       await _vodPlayerController?.getPlayableDuration();
  //   return playableDuration ?? 0;
  // }

  // void _playModeVideo(PlayInfoProtocol protocol) {
  //   String? videoUrl = protocol.getUrl();
  //   _playVodUrl(videoUrl);
  //   List<VideoQuality>? qualityList = protocol.getVideoQualityList();

  //   _isMultiBitrateStream = protocol.getResolutionNameList() != null ||
  //       qualityList != null ||
  //       (videoUrl != null && videoUrl.contains("m3u8"));

  //   _updateVideoQualityList(qualityList, protocol.getDefaultVideoQuality());
  // }

  void _playUrlVideo(SuperPlayerModel? model) {
    //
  }

  void _playWithUrl(SuperPlayerModel model) {
    //
  }

  Future<void> _playVodUrl(String? url) async {
    //
  }

  /// 暂停视频
  /// 涉及到_updatePlayerState相关的方法，不使用异步,避免异步调用导致的playerState更新不及时
  void pause() {
    //
  }

  /// 继续播放视频
  void resume() {
    //
    _updatePlayerState(SuperPlayerState.PLAYING);
  }

  /// 重新开始播放视频
  Future<void> reStart() async {
    //
  }

  // void _updatePlayerType(SuperPlayerType type) {
  //   //
  // }

  void _updatePlayerState(SuperPlayerState state) {
    playerState = state;
    //
  }

  String _getPlayName() {
    String title = "";

    return title;
  }

  // void _updateVideoQualityList(
  //     List<VideoQuality>? qualityList, VideoQuality? defaultQuality) {
  //   currentQuality = defaultQuality;
  //   currentQualiyList = qualityList;
  //   for (var element in _observers) {
  //     element.onVideoQualityListChange(qualityList, defaultQuality);
  //   }
  // }

  void _addSimpleEvent(String event) {}

  void _updateFullScreenState(bool fullScreen) {
    //
  }

  /// just for inner invoke
  Future<void> _stopPlay() async {
    //
  }

  /// 重置播放器状态
  Future<void> resetPlayer() async {
    //

    _updatePlayerState(SuperPlayerState.INIT);
  }

  /// 释放播放器，播放器释放之后，将不能再使用
  Future<void> releasePlayer() async {
    // 先移除widget的事件监听
    //
  }

  /// return true : 执行了退出全屏等操作，消耗了返回事件  false：未消耗事件
  bool onBackPress() {
    return false;
  }

  // void _onBackTap() {
  //   _addSimpleEvent(SuperPlayerViewEvent.onSuperPlayerBackAction);
  // }

  // /// 切换清晰度
  // void switchStream(VideoQuality videoQuality) async {
  //   currentQuality = videoQuality;
  //   if (playerType == SuperPlayerType.VOD) {
  //     if (null != _vodPlayerController) {
  //       if (videoQuality.url.isNotEmpty) {
  //         // url stream need manual seek
  //         double currentTime =
  //             await _vodPlayerController!.getCurrentPlaybackTime();
  //         await _vodPlayerController?.stop(isNeedClear: false);
  //         LogUtils.d(TAG, "onQualitySelect quality.url:${videoQuality.url}");
  //         await _vodPlayerController?.setStartTime(currentTime);
  //         await _vodPlayerController?.startVodPlay(videoQuality.url);
  //       } else {
  //         LogUtils.d(
  //             TAG, "setBitrateIndex quality.index:${videoQuality.index}");
  //         await _vodPlayerController?.setBitrateIndex(videoQuality.index);
  //       }
  //       for (var element in _observers) {
  //         element.onSwitchStreamStart(true, SuperPlayerType.VOD, videoQuality);
  //       }
  //     }
  //   } else {
  //     // todo implements live player
  //   }
  // }

  /// seek 到需要的时间点进行播放
  Future<void> seek(double progress) async {
    //
  }

  /// 配置播放器
  Future<void> setPlayConfig(FTXVodPlayConfig config) async {
    // await _vodPlayerController?.setConfig(config);
  }

  /// 进入画中画模式，进入画中画模式，需要适配画中画模式的界面，安卓只支持7.0以上机型
  /// <h1>
  /// 由于android系统限制，传递的图标大小不得超过1M，否则无法显示
  /// </h1>
  /// @param backIcon playIcon pauseIcon forwardIcon 为播放后退、播放、暂停、前进的图标，如果赋值的话，将会使用传递的图标，否则
  /// 使用系统默认图标，只支持flutter本地资源图片，传递的时候，与flutter使用图片资源一致，例如： images/back_icon.png
  // Future<int?> enterPictureInPictureMode(
  //     {String? backIcon,
  //     String? playIcon,
  //     String? pauseIcon,
  //     String? forwardIcon}) async {
  //   return _vodPlayerController?.enterPictureInPictureMode(
  //       backIconForAndroid: backIcon,
  //       playIconForAndroid: playIcon,
  //       pauseIconForAndroid: pauseIcon,
  //       forwardIconForAndroid: forwardIcon);
  // }

  /// 开关硬解编码播放
  Future<void> enableHardwareDecode(bool enable) async {
    //
  }

  Future<void> setPlayRate(double rate) async {
    //
  }

  /// 获得当前播放器状态
  SuperPlayerState getPlayerState() {
    return playerState;
  }

  /// 进度监听
  // setOnPlayProgressListener(OnPlayProgress onPlayProgress) {
  //   this._onPlayProgress = onPlayProgress;
  // }

  // void addObserver(SuperPlayerObserver observer) {
  //   _observers.add(observer);
  // }

  // void removeObserver(SuperPlayerObserver observer) {
  //   _observers.remove(observer);
  // }
}

class BJVideoPlayerView extends StatefulWidget {
  final BJPlayerController controller;
  final bool showBottomProgress; // 底部进度条
  final String? coverUrl;
  final ImageProvider? coverImageProvider;
  final bool needPlayBtn; // 是否需要点击暂停按钮
  final bool needCover; // 是否需要Cover
  final bool needLoading;
  // 注意 这个是封面的宽高比
  final double aspectRatio;
  final EdgeInsets bottomProgressPadding; // 进度条padding
  const BJVideoPlayerView({
    Key? key,
    required this.controller,
    this.coverUrl = "",
    this.coverImageProvider,
    this.showBottomProgress = false,
    this.needPlayBtn = true,
    this.needCover = true,
    this.needLoading = true,
    this.aspectRatio = 16.0 / 9.0,
    this.bottomProgressPadding = EdgeInsets.zero,
  }) : super(key: key);

  @override
  State<BJVideoPlayerView> createState() => _BJVideoPlayerViewState();
}

class _BJVideoPlayerViewState extends State<BJVideoPlayerView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    //
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Container(
            child: Text('123'),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}

/// TXVodPlayer config
class FTXVodPlayConfig {
  // 播放器重连次数
  int connectRetryCount = 3;
  // 播放器重连间隔
  int connectRetryInterval = 3;
  // 播放器连接超时时间
  int timeout = 10;
  // 仅iOS平台生效 [PlayerType]
  int playerType = PlayerType.THUMB_PLAYER;
  // 自定义http headers
  Map<String, String> headers = {};
  // 是否精确seek，默认true
  bool enableAccurateSeek = true;
  // 播放mp4文件时，若设为true则根据文件中的旋转角度自动旋转。
  // 旋转角度可在PLAY_EVT_CHANGE_ROTATION事件中获得。默认true
  bool autoRotate = true;
  // 平滑切换多码率HLS，默认false。设为false时，可提高多码率地址打开速度;
  // 设为true，在IDR对齐时可平滑切换码率
  bool smoothSwitchBitrate = false;
  // 缓存mp4文件扩展名,默认mp4
  String cacheMp4ExtName = "mp4";
  // 设置进度回调间隔,若不设置，SDK默认间隔0.5秒回调一次,单位毫秒
  int progressInterval = 0;
  // 最大播放缓冲大小，单位 MB。此设置会影响playableDuration，设置越大，提前缓存的越多
  int maxBufferSize = 0;
  // 预加载最大缓冲大小，单位：MB
  int maxPreloadSize = 0;
  // 首缓需要加载的数据时长，单位ms，默认值为100ms
  int firstStartPlayBufferTime = 0;
  // 缓冲时（缓冲数据不够引起的二次缓冲，或者seek引起的拖动缓冲）
  // 最少要缓存多长的数据才能结束缓冲，单位ms，默认值为250ms
  int nextStartPlayBufferTime = 0;
  // HLS安全加固加解密key
  String overlayKey = "";
  // HLS安全加固加解密Iv
  String overlayIv = "";
  // 设置一些不必周知的特殊配置
  Map<String, Object> extInfoMap = {};
  // 是否允许加载后渲染后处理服务,默认开启，开启后超分插件如果存在，默认加载
  bool enableRenderProcess = true;
  // 优先播放的分辨率，preferredResolution = width * height
  int preferredResolution = 720 * 1280;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json["connectRetryCount"] = connectRetryCount;
    json["connectRetryInterval"] = connectRetryInterval;
    json["timeout"] = timeout;
    json["headers"] = headers;
    json["playerType"] = playerType;
    json["enableAccurateSeek"] = enableAccurateSeek;
    json["autoRotate"] = autoRotate;
    json["smoothSwitchBitrate"] = smoothSwitchBitrate;
    json["cacheMp4ExtName"] = cacheMp4ExtName;
    json["progressInterval"] = progressInterval;
    json["maxBufferSize"] = maxBufferSize;
    json["maxPreloadSize"] = maxPreloadSize;
    json["firstStartPlayBufferTime"] = firstStartPlayBufferTime;
    json["nextStartPlayBufferTime"] = nextStartPlayBufferTime;
    json["overlayKey"] = overlayKey;
    json["overlayIv"] = overlayIv;
    json["extInfoMap"] = extInfoMap;
    json["enableRenderProcess"] = enableRenderProcess;
    json["preferredResolution"] = preferredResolution.toString();
    return json;
  }
}

/// 仅iOS平台有效
class PlayerType {
  static const int AVPLAYER = 0; // 系统播放
  static const int THUMB_PLAYER = 1; // ThumbPlayer播放器
}

/// superplayer play model
class SuperPlayerModel {
  static const PLAY_ACTION_AUTO_PLAY = 0;
  static const PLAY_ACTION_MANUAL_PLAY = 1;
  static const PLAY_ACTION_PRELOAD = 2;

  int appId = 0;
  String videoURL = "";
  // List<SuperPlayerUrl> multiVideoURLs = [];
  int defaultPlayIndex = 0;
  // SuperPlayerVideoId? videoId;
  String title = "";
  String coverUrl = ""; // coverUrl from net
  String customeCoverUrl = ""; // custome video cover image
  int duration = 0; // video duration

  // feed流视频描述
  String videoDescription = "";
  String videoMoreDescription = "";

  int playAction = PLAY_ACTION_AUTO_PLAY;
}
