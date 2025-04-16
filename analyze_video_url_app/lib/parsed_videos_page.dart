/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-16 22:41:07
 * @Description: 
 */
import 'package:flutter/material.dart';
import './services/download_manager.dart';
import './models/download_record.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class ParsedVideosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("已解析视频", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: DownloadManager(),
        builder: (context, child) {
          final downloads = DownloadManager().downloads;
          if (downloads.isEmpty) {
            return Center(
              child: Text('暂无下载记录'),
            );
          }
          return ListView.builder(
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final record = downloads[index];
              return _buildDownloadItem(context, record);
            },
          );
        },
      ),
    );
  }

  Widget _buildDownloadItem(BuildContext context, DownloadRecord record) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: record.status == DownloadStatus.completed
            ? () => _playVideo(context, record)
            : null,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.video_library, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '视频ID: ${record.videoId}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '添加时间: ${record.addTime.toString()}',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusIcon(record.status),
                ],
              ),
              SizedBox(height: 8),
              _buildProgressSection(context, record),
              if (record.status == DownloadStatus.failed)
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 16),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '下载失败',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                      TextButton(
                        onPressed: () => DownloadManager().retryDownload(record.videoId),
                        child: Text('重试'),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _playVideo(BuildContext context, DownloadRecord record) {
    if (record.savedPath == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(videoPath: record.savedPath!),
      ),
    );
  }

  Widget _buildStatusIcon(DownloadStatus status) {
    IconData iconData;
    Color color;

    switch (status) {
      case DownloadStatus.pending:
        iconData = Icons.hourglass_empty;
        color = Colors.orange;
        break;
      case DownloadStatus.downloading:
        iconData = Icons.downloading;
        color = Colors.blue;
        break;
      case DownloadStatus.completed:
        iconData = Icons.check_circle;
        color = Colors.green;
        break;
      case DownloadStatus.failed:
        iconData = Icons.error;
        color = Colors.red;
        break;
    }

    return Icon(iconData, color: color);
  }

  Widget _buildProgressSection(BuildContext context, DownloadRecord record) {
    switch (record.status) {
      case DownloadStatus.pending:
        return Text('等待下载...');
      case DownloadStatus.downloading:
        return Column(
          children: [
            LinearProgressIndicator(value: record.progress),
            SizedBox(height: 4),
            Text('${(record.progress * 100).toStringAsFixed(1)}%'),
          ],
        );
      case DownloadStatus.completed:
        return Text('下载完成', style: TextStyle(color: Colors.green));
      case DownloadStatus.failed:
        return Text('下载失败', style: TextStyle(color: Colors.red));
    }
  }
}

class VideoItem {
  String url;
  String size;
  double progress; // 0.0 ~ 1.0
  bool isDownloading;

  VideoItem(
      {required this.url,
      required this.size,
      this.progress = 0.0,
      this.isDownloading = false});
}

class VideoCard extends StatefulWidget {
  final VideoItem video;
  final VoidCallback onDelete;

  VideoCard({required this.video, required this.onDelete});

  @override
  _VideoCardState createState() => _VideoCardState();
}

class _VideoCardState extends State<VideoCard> {
  late VideoItem video;

  @override
  void initState() {
    super.initState();
    video = widget.video;
  }

  void _toggleDownload() {
    setState(() {
      video.isDownloading = !video.isDownloading;
    });

    if (video.isDownloading) {
      _startDownloading();
    }
  }

  void _startDownloading() async {
    while (video.isDownloading && video.progress < 1.0) {
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        video.progress += 0.1;
        if (video.progress >= 1.0) {
          video.progress = 1.0;
          video.isDownloading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Container(color: Colors.black12)), // 假设是视频封面
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(video.size, style: TextStyle(color: Colors.white)),
              ),
              if (video.progress > 0 && video.progress < 1.0)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(value: video.progress),
                ),
            ],
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: widget.onDelete,
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text("删除", style: TextStyle(color: Colors.white)),
            ),
          ),
        ),
        if (video.progress > 0 && video.progress < 1.0)
          Positioned(
            bottom: 8,
            right: 8,
            child: FloatingActionButton(
              mini: true,
              onPressed: _toggleDownload,
              child: Icon(video.isDownloading ? Icons.pause : Icons.play_arrow),
            ),
          ),
      ],
    );
  }
}

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
