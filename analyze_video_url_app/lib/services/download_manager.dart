/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:33
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-17 17:18:28
 * @Description: 
 */
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/download_record.dart';
import 'package:flutter/foundation.dart';

class DownloadManager extends ChangeNotifier {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;
  DownloadManager._internal();

  final List<DownloadRecord> _downloads = [];
  final Dio _dio = Dio();

  List<DownloadRecord> get downloads => List.unmodifiable(_downloads);

  void addDownload(String videoId, String videoUrl) {
    final record = DownloadRecord(
      videoId: videoId,
      videoUrl: videoUrl,
      addTime: DateTime.now(),
    );
    _downloads.add(record);
    notifyListeners();
    _startDownload(record);
  }

  Future<void> _startDownload(DownloadRecord record) async {
    try {
      record.status = DownloadStatus.downloading;
      notifyListeners();

      final directory = await getApplicationDocumentsDirectory();
      final savePath = '${directory.path}/videos/${record.videoId}.mp4';

      await Directory('${directory.path}/videos').create(recursive: true);

      await _dio.download(
        record.videoUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            record.progress = received / total;
            notifyListeners();
          }
        },
      );

      record.savedPath = savePath;
      record.status = DownloadStatus.completed;

      // 生成缩略图
      await _generateThumbnail(record);

      notifyListeners();
    } catch (e) {
      record.status = DownloadStatus.failed;
      notifyListeners();
    }
  }

  Future<void> _generateThumbnail(DownloadRecord record) async {
    if (record.savedPath == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final thumbnailPath =
          '${directory.path}/thumbnails/${record.videoId}.jpg';

      await Directory('${directory.path}/thumbnails').create(recursive: true);

      await VideoThumbnail.thumbnailFile(
        video: record.savedPath!,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );

      record.thumbnailPath = thumbnailPath;
      notifyListeners();
    } catch (e) {
      print('Error generating thumbnail: $e');
    }
  }

  void retryDownload(String videoId) {
    final record = _downloads.firstWhere((r) => r.videoId == videoId);
    if (record.status == DownloadStatus.failed) {
      record.status = DownloadStatus.pending;
      record.progress = 0.0;
      notifyListeners();
      _startDownload(record);
    }
  }

  void removeDownloadByPath(String path) {
    try {
      File(path).delete();
      _downloads.removeWhere((record) => record.savedPath == path);
      notifyListeners();
    } catch (e) {
      print('Error removing download: $e');
    }
  }

  void cancelDownload(String videoId) {
    final record = _downloads.firstWhere(
      (r) => r.videoId == videoId,
      orElse: () => throw StateError('Download record not found'),
    );

    if (record != null) {
      // 如果文件已经部分下载，删除文件
      if (record.savedPath != null) {
        File(record.savedPath!).exists().then((exists) {
          if (exists) {
            File(record.savedPath!).delete();
          }
        });
      }
      // 如果有缩略图，删除缩略图
      if (record.thumbnailPath != null) {
        File(record.thumbnailPath!).exists().then((exists) {
          if (exists) {
            File(record.thumbnailPath!).delete();
          }
        });
      }

      _downloads.remove(record);
      notifyListeners();
    }
  }

  void deleteDownload(String videoId) async {
    final record = _downloads.firstWhere(
      (r) => r.videoId == videoId,
      orElse: () => throw StateError('Download record not found'),
    );

    if (record != null) {
      // 如果正在下载，先取消下载任务
      if (record.status == DownloadStatus.downloading) {
        // TODO: 取消 dio 下载任务
        // _dio.cancel(record.videoId);
      }

      // 删除已下载的文件（如果存在）
      if (record.savedPath != null) {
        try {
          final file = File(record.savedPath!);
          if (await file.exists()) {
            await file.delete();
          }
        } catch (e) {
          print('删除视频文件失败: $e');
        }
      }

      // 删除缩略图（如果存在）
      if (record.thumbnailPath != null) {
        try {
          final thumbnailFile = File(record.thumbnailPath!);
          if (await thumbnailFile.exists()) {
            await thumbnailFile.delete();
          }
        } catch (e) {
          print('删除缩略图失败: $e');
        }
      }

      // 从下载列表中移除记录
      _downloads.remove(record);
      notifyListeners();
    }
  }
}
