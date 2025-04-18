/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-18 19:03:53
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import './services/download_manager.dart';
import './models/download_record.dart';
import 'dart:io';

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
    _absolutePath =
        await _downloadManager.getAbsolutePath(widget.record.savedPath!);
    _controller = VideoPlayerController.file(File(_absolutePath!))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String videoPath = widget.record.savedPath!;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Colors.white),
            onPressed: () async {
              if (_absolutePath == null) return;
              try {
                final result = await ImageGallerySaver.saveFile(_absolutePath!);
                if (result['isSuccess']) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('视频已保存到相册')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('保存失败')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('保存失败: $e')),
                );
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () async {
              if (_absolutePath == null) return;
              try {
                await Share.shareXFiles(
                  [XFile(_absolutePath!)],
                  sharePositionOrigin: Rect.fromLTWH(0, 0, 100, 100),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('分享失败: $e')),
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
        child: _isInitialized
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
        title: Text('确认删除'),
        content: Text('确定要删除这个视频吗？'),
        actions: [
          TextButton(
            child: Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('删除'),
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
}
