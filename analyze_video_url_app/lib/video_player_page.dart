/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-29 08:53:56
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import './services/download_manager.dart';
import './models/download_record.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:analyze_video_url_app/l10n/l10n.dart';

class VideoPlayerPage extends StatefulWidget {
  final DownloadRecord record;
  const VideoPlayerPage({required this.record});

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  final DownloadManager _downloadManager = DownloadManager();
  String? _absolutePath;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final absolutePath = await widget.record.getVideoAbsolutePath();
      if (absolutePath == null) {
        throw Exception(AppLocalizations.of(context)!.videoFilePathNotFound);
      }

      final file = File(absolutePath);
      if (!await file.exists()) {
        throw Exception(AppLocalizations.of(context)!.videoFileNotFound);
      }

      _absolutePath = absolutePath; // 保存绝对路径
      _controller = VideoPlayerController.file(file);
      await _controller.initialize();
      setState(() {
        _isInitialized = true; // 设置初始化状态
      });

      // 自动开始播放
      _controller.play();
    } catch (e) {
      print(AppLocalizations.of(context)!
          .videoInitializationFailed(e.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(AppLocalizations.of(context)!.videoLoadingFailed)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Colors.white),
            onPressed: _absolutePath == null
                ? null
                : () async {
                    try {
                      final result =
                          await ImageGallerySaver.saveFile(_absolutePath!);
                      if (result['isSuccess']) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(AppLocalizations.of(context)!
                                  .videoSavedToAlbum)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  AppLocalizations.of(context)!.saveFailed)),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .saveFailedWithError(e.toString()))),
                      );
                    }
                  },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: _absolutePath == null
                ? null
                : () async {
                    // 禁用状态判断
                    try {
                      await Share.shareXFiles(
                        [XFile(_absolutePath!)],
                        sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(AppLocalizations.of(context)!
                                .saveError(e.toString()))),
                      );
                    }
                  },
          ),
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white),
            onPressed: () {
              _deleteVideo();
            },
          ),
        ],
      ),
      body: Center(
        child: _isInitialized && _controller.value.isInitialized // 添加控制器初始化状态检查
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_controller),
                    _buildControls(),
                  ],
                ),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildControls() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // 播放/暂停按钮
        GestureDetector(
          onTap: () {
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },
          child: Container(
            color: Colors.transparent,
            child: Center(
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 50.0,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ),
        // 进度条
        VideoProgressIndicator(_controller, allowScrubbing: true),
      ],
    );
  }

  void _deleteVideo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.confirmDeleteVideo),
        content: Text(AppLocalizations.of(context)!.confirmDeleteVideoPrompt),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.delete),
            onPressed: () async {
              // 先停止播放并释放资源
              await _controller.pause();
              await _controller.dispose();

              await DownloadManager().deleteDownload(widget.record);
              Navigator.pop(context); // 关闭对话框
              Navigator.pop(context, true); // 返回上一页，并传递删除标记
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 先暂停视频播放
    _controller.pause();
    // 释放视频控制器资源
    _controller.dispose();
    super.dispose();
  }
}
