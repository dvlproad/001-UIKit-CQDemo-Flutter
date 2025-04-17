/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-17 16:51:15
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import './services/download_manager.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final String videoPath;

  const VideoPlayerPage({Key? key, required this.videoPath}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        // 初始化完成后自动播放
        _controller.play();
        // 设置循环播放
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
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.save_alt, color: Colors.white),
            onPressed: () async {
              try {
                final result =
                    await ImageGallerySaver.saveFile(widget.videoPath);
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
              try {
                await Share.shareXFiles(
                  [XFile(widget.videoPath)],
                  sharePositionOrigin:
                      Rect.fromLTWH(0, 0, 100, 100), // iOS 分享菜单的位置
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
                      onPressed: () {
                        // 从下载管理器中删除记录
                        DownloadManager()
                            .removeDownloadByPath(widget.videoPath);
                        Navigator.pop(context); // 关闭对话框
                        Navigator.pop(context, true); // 返回上一页，并传递删除成功的标志
                      },
                    ),
                  ],
                ),
              );
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
}
