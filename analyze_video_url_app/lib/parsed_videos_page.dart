/*
 * @Author: dvlproad
 * @Date: 2025-03-31 20:51:29
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-19 01:35:27
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import './services/download_manager.dart';
import './models/download_record.dart';
import './video_player_page.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParsedVideosPage extends StatefulWidget {
  ParsedVideosPage();

  @override
  _ParsedVideosPageState createState() => _ParsedVideosPageState();
}

class _ParsedVideosPageState extends State<ParsedVideosPage> {
  final DownloadManager _downloadManager = DownloadManager();
  Map<String, bool> _processedDownloads = {};

  @override
  void initState() {
    super.initState();
    // 为每个下载添加状态变化回调
    for (var record in _downloadManager.downloads) {
      _addStatusChangeCallback(record);
    }
  }

  void _addStatusChangeCallback(DownloadRecord record) {
    record.onStatusChanged = (status) {
      if (status == DownloadStatus.completed &&
          !_processedDownloads.containsKey(record.videoId)) {
        _processedDownloads[record.videoId] = true;
        _showSaveToGalleryDialog(record);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.parsedVideos,
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.delete_sweep, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.confirmClear),
                  content:
                      Text(AppLocalizations.of(context)!.confirmClearPrompt),
                  actions: [
                    TextButton(
                      child: Text(AppLocalizations.of(context)!.cancel),
                      onPressed: () => Navigator.pop(dialogContext),
                    ),
                    TextButton(
                      child: Text(
                        AppLocalizations.of(context)!.clear,
                        style: TextStyle(color: Colors.red),
                      ),
                      onPressed: () {
                        _downloadManager.clearAllDownloads();
                        Navigator.pop(dialogContext);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _downloadManager,
        builder: (context, child) {
          final downloads = _downloadManager.downloads;
          if (downloads.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noDownloadRecords),
            );
          }
          return GridView.builder(
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 140 / 220.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: downloads.length,
            itemBuilder: (context, index) {
              final record = downloads[index];
              if (record.onStatusChanged == null) {
                _addStatusChangeCallback(record);
              }
              return _buildDownloadItem(context, record);
            },
          );
        },
      ),
    );
  }

  void _showSaveToGalleryDialog(DownloadRecord record) async {
    final absolutePath = await record.getVideoAbsolutePath();
    if (absolutePath == null || !mounted) return;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.saveToGallery),
        content: Text(AppLocalizations.of(context)!.downloadCompleteSavePrompt),
        actions: [
          TextButton(
            child: Text(AppLocalizations.of(context)!.cancel),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
          ),
          TextButton(
            child: Text(AppLocalizations.of(context)!.save),
            onPressed: () async {
              Navigator.pop(dialogContext);
              try {
                final result = await ImageGallerySaver.saveFile(absolutePath);
                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      result['isSuccess']
                          ? AppLocalizations.of(context)!.videoSavedToGallery
                          : AppLocalizations.of(context)!.saveFailed,
                    ),
                  ),
                );
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      AppLocalizations.of(context)!.saveError(e.toString()),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(BuildContext context, DownloadRecord record) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: record.status == DownloadStatus.completed
            ? () => _playVideo(context, record)
            : null,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // 背景图片或占位符
            if (record.status == DownloadStatus.completed &&
                record.thumbnailRelativePath != null)
              FutureBuilder<String?>(
                future: record.getThumbnailAbsolutePath(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.hasError ||
                      snapshot.data == null) {
                    print('加载缩略图失败: ${snapshot.error}');
                    return Container(color: Colors.grey[300]);
                  }
                  return Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('显示缩略图失败: $error');
                      return Container(color: Colors.grey[300]);
                    },
                  );
                },
              )
            else
              Container(
                color: Colors.grey[300],
                child: Icon(Icons.video_library,
                    color: Colors.grey[600], size: 40),
              ),
            // 渐变遮罩，使文字更容易阅读
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // 视频信息
            Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.videoId(record.videoId),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    AppLocalizations.of(context)!
                        .addTime(_formatDate(record.addTime)),
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  _buildProgressSection(context, record),
                  if (record.status == DownloadStatus.failed)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red, size: 12),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)!.downloadFailed,
                              style: TextStyle(color: Colors.red, fontSize: 10),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                DownloadManager().retryDownload(record),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.retry,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // 删除按钮
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(AppLocalizations.of(context)!.confirmDelete),
                      content: Text(
                          AppLocalizations.of(context)!.confirmDeletePrompt),
                      actions: [
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.cancel),
                          onPressed: () => Navigator.pop(context),
                        ),
                        TextButton(
                          child: Text(AppLocalizations.of(context)!.delete),
                          onPressed: () {
                            DownloadManager().deleteDownload(record);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child:
                      Icon(Icons.delete_outline, color: Colors.white, size: 20),
                ),
              ),
            ),

            // 状态图标（移到左上角）
            Positioned(
              top: 8,
              left: 8,
              child: _buildStatusIcon(record.status),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(date.month)}-${twoDigits(date.day)} ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
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

    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, color: color, size: 16),
    );
  }

  Widget _buildProgressSection(BuildContext context, DownloadRecord record) {
    switch (record.status) {
      case DownloadStatus.pending:
        if (record.progress > 0) {
          // 如果有进度，显示进度条
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LinearProgressIndicator(
                value: record.progress,
                backgroundColor: Colors.white24,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              SizedBox(height: 2),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.downloaded(
                          (record.progress * 100).toStringAsFixed(1)),
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ),
                  TextButton(
                    onPressed: () => _downloadManager.retryDownload(record),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size(0, 0),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.continueDownload,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 10,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        // 如果没有进度，显示原来的等待下载状态
        return Row(
          children: [
            Expanded(
              child: Text(
                AppLocalizations.of(context)!.waitingForDownload,
                style: TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ),
            TextButton(
              onPressed: () => _downloadManager.retryDownload(record),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 0),
              ),
              child: Text(
                AppLocalizations.of(context)!.continueDownload,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 10,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        );
      case DownloadStatus.downloading:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: record.progress,
              backgroundColor: Colors.white24,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            SizedBox(height: 2),
            Text(
              AppLocalizations.of(context)!
                  .downloaded((record.progress * 100).toStringAsFixed(1)),
              style: TextStyle(color: Colors.white70, fontSize: 10),
            ),
          ],
        );
      case DownloadStatus.completed:
        return Text(
          AppLocalizations.of(context)!.downloadComplete,
          style: TextStyle(color: Colors.green, fontSize: 10),
        );
      case DownloadStatus.failed:
        return Text(
          AppLocalizations.of(context)!.downloadFailed,
          style: TextStyle(color: Colors.red, fontSize: 10),
        );
    }
  }

  void _playVideo(BuildContext context, DownloadRecord record) async {
    final absolutePath = await record.getVideoAbsolutePath();
    if (absolutePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.videoFilePathNotExist)),
      );
      return;
    }

    final videoFile = File(absolutePath);
    if (!await videoFile.exists()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.videoFileNotExist)),
      );
      return;
    }

    Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPlayerPage(record: record),
      ),
    );
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
