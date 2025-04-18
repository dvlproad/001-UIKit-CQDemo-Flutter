/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:33
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-18 19:09:39
 * @Description: 
 */
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../models/download_record.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadManager extends ChangeNotifier {
  static final DownloadManager _instance = DownloadManager._internal();
  factory DownloadManager() => _instance;

  List<DownloadRecord> get downloads => List.unmodifiable(_downloads);
  final List<DownloadRecord> _downloads = [];
  final Dio _dio = Dio();
  static const String _storageKey = 'download_records';

  DownloadManager._internal() {
    _loadDownloads(); // 初始化时加载保存的记录
  }

  // 加载保存的下载记录
  Future<void> _loadDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? recordsJson = prefs.getString(_storageKey);
      if (recordsJson != null) {
        final List<dynamic> records = json.decode(recordsJson);
        _downloads.addAll(
          records.map((record) => DownloadRecord.fromJson(record)).toList(),
        );
        notifyListeners();
      }
    } catch (e) {
      print('加载下载记录失败: $e');
    }
  }

  // 保存下载记录到本地
  Future<void> _saveDownloads() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final recordsJson = json.encode(
        _downloads.map((record) => record.toJson()).toList(),
      );
      await prefs.setString(_storageKey, recordsJson);
    } catch (e) {
      print('保存下载记录失败: $e');
    }
  }

  // 修改现有方法，在数据变化时保存
  void addDownload(String videoId, String videoUrl) {
    final record = DownloadRecord(
      videoId: videoId,
      videoUrl: videoUrl,
      addTime: DateTime.now(),
    );
    _downloads.insert(0, record); // 使用 insert(0) 替代 add，将新记录插入到列表开头
    _saveDownloads();
    notifyListeners();
    _startDownload(record);
  }

  Future<void> deleteDownload(DownloadRecord record) async {
    try {
      // 如果正在下载，先取消下载任务
      if (record.status == DownloadStatus.downloading) {
        // TODO: 取消 dio 下载任务
        // _dio.cancel(record.videoId);
      }

      final basePath = await _getBasePath();

      // 删除视频文件
      if (record.savedPath != null) {
        try {
          final videoPath = _getAbsolutePath(record.savedPath!, basePath);
          final videoFile = File(videoPath);
          if (await videoFile.exists()) {
            await videoFile.delete();
          }
        } catch (e) {
          print('删除视频文件失败: $e');
        }
      }

      // 删除缩略图
      if (record.thumbnailPath != null) {
        try {
          final thumbnailPath =
              _getAbsolutePath(record.thumbnailPath!, basePath);
          final thumbnailFile = File(thumbnailPath);
          if (await thumbnailFile.exists()) {
            await thumbnailFile.delete();
          }
        } catch (e) {
          print('删除缩略图失败: $e');
        }
      }

      _downloads.remove(record);
      await _saveDownloads();
      notifyListeners();
    } catch (e) {
      print('删除记录失败: $e');
    }
  }

  Future<String> _getBasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  String _getRelativePath(String absolutePath, String basePath) {
    return absolutePath.replaceFirst(basePath, '');
  }

  String _getAbsolutePath(String relativePath, String basePath) {
    return '$basePath$relativePath';
  }

  Future<void> _startDownload(DownloadRecord record) async {
    try {
      record.status = DownloadStatus.downloading;
      notifyListeners();

      final basePath = await _getBasePath();
      final savePath = '$basePath/videos/${record.videoId}.mp4';

      await Directory('$basePath/videos').create(recursive: true);

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

      // 保存相对路径
      record.savedPath = _getRelativePath(savePath, basePath);
      record.status = DownloadStatus.completed;
      await _saveDownloads();

      await _generateThumbnail(record);
      notifyListeners();
    } catch (e) {
      record.status = DownloadStatus.failed;
      await _saveDownloads();
      notifyListeners();
    }
  }

  Future<void> _generateThumbnail(DownloadRecord record) async {
    if (record.savedPath == null) return;

    try {
      final basePath = await _getBasePath();
      final absoluteVideoPath = _getAbsolutePath(record.savedPath!, basePath);
      final thumbnailPath = '$basePath/thumbnails/${record.videoId}.jpg';

      // 确保目录存在
      await Directory('$basePath/thumbnails').create(recursive: true);

      final String? thumbnail = await VideoThumbnail.thumbnailFile(
        video: absoluteVideoPath,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
      );

      if (thumbnail != null) {
        // 保存相对路径
        record.thumbnailPath = _getRelativePath(thumbnail, basePath);
        await _saveDownloads();
        notifyListeners();
      } else {
        print('生成缩略图失败: thumbnail is null');
      }
    } catch (e) {
      print('生成缩略图失败: $e');
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

  Future<String> getAbsolutePath(String relativePath) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}$relativePath';
  }
}
