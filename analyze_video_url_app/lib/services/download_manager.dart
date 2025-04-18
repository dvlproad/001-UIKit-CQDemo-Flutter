/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:33
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-19 01:14:39
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
import 'package:path/path.dart' show dirname;

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
        _downloads.clear();

        final basePath = await _getBasePath();
        for (var record in records) {
          final downloadRecord = DownloadRecord.fromJson(record);

          // 检查临时文件和进度
          if (downloadRecord.status == DownloadStatus.downloading) {
            final tempPath =
                '$basePath/videos/${downloadRecord.videoId}.mp4.temp';
            final tempFile = File(tempPath);
            if (await tempFile.exists()) {
              final totalSize = downloadRecord.totalSize ?? 0;
              if (totalSize > 0) {
                final currentSize = await tempFile.length();
                downloadRecord.progress = currentSize / totalSize;
              }
            }
            downloadRecord.status = DownloadStatus.pending;
          }

          _downloads.add(downloadRecord);
        }

        await _saveDownloads();
        notifyListeners();
      }
    } catch (e) {
      print('加载下载记录失败: $e');
    }
  }

  Future<void> _startDownload(DownloadRecord record) async {
    try {
      record.status = DownloadStatus.downloading;
      notifyListeners();

      final savePath = await record.getSaveVideoPath();
      final tempPath = await record.getSaveTempPath();

      // 确保目录存在
      final saveDir = Directory(dirname(savePath));
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      // 检查临时文件
      final tempFile = File(tempPath);
      int startBytes = 0;
      if (await tempFile.exists()) {
        tempFile.delete(); // 注意：断点续传拼接的视频有问题，这里删除掉旧文件，以强制改成重新下载
        //startBytes = await tempFile.length();
      }

      // 先获取文件总大小
      final response = await _dio.head(record.videoUrl);
      final totalSize =
          int.parse(response.headers.value('content-length') ?? '0');
      record.totalSize = totalSize;

      await _dio.download(
        record.videoUrl,
        tempPath,
        options: Options(
          headers: {
            if (startBytes > 0) 'Range': 'bytes=$startBytes-',
          },
        ),
        onReceiveProgress: (received, total) {
          if (total != -1) {
            record.progress = (startBytes + received) / (startBytes + total);
            _saveDownloads();
            notifyListeners();
          }
        },
      );

      // 下载完成后的处理
      if (await tempFile.exists()) {
        final downloadedSize = await tempFile.length();
        if (downloadedSize != totalSize) {
          throw Exception('下载的文件大小不正确，无法正确播放和获取视频预览图');
        }
        final videoFile = File(savePath);
        if (await videoFile.exists()) {
          await videoFile.delete();
        }
        await tempFile.rename(savePath);

        // 确保视频文件存在并保存相对路径
        if (await File(savePath).exists()) {
          final basePath = await _getBasePath();
          final relativePath = savePath.replaceFirst(basePath, '');
          record.saveRelativePath = relativePath;
          record.status = DownloadStatus.completed;
          await _saveDownloads();

          // 生成缩略图
          await _generateThumbnail(record);

          notifyListeners();
        } else {
          throw Exception('视频文件移动失败');
        }
      } else {
        throw Exception('临时文件不存在');
      }
    } catch (e) {
      print('下载失败: $e');
      record.status = DownloadStatus.failed;
      await _saveDownloads();
      notifyListeners();
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
      if (record.saveRelativePath != null) {
        // 更改字段名
        try {
          final videoPath =
              _getAbsolutePath(record.saveRelativePath!, basePath); // 更改字段名
          final videoFile = File(videoPath);
          if (await videoFile.exists()) {
            await videoFile.delete();
          }
        } catch (e) {
          print('删除视频文件失败: $e');
        }
      }

      // 删除缩略图
      if (record.thumbnailRelativePath != null) {
        try {
          final thumbnailPath =
              _getAbsolutePath(record.thumbnailRelativePath!, basePath);
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

  String _getAbsolutePath(String relativePath, String basePath) {
    return '$basePath$relativePath';
  }

  Future<void> _generateThumbnail(DownloadRecord record) async {
    if (record.saveRelativePath == null) return;

    try {
      final absoluteVideoPath = await record.getVideoAbsolutePath();
      if (absoluteVideoPath == null) {
        print('获取视频绝对路径失败');
        return;
      }

      final thumbnailPath = await record.getNewThumbnailPath();

      // 确保缩略图目录存在
      final thumbnailDir = Directory(dirname(thumbnailPath));
      if (!await thumbnailDir.exists()) {
        await thumbnailDir.create(recursive: true);
      }

      // 确保视频文件存在且可访问
      final videoFile = File(absoluteVideoPath);
      if (!await videoFile.exists()) {
        print('视频文件不存在: $absoluteVideoPath');
        return;
      }

      // 删除可能存在的旧缩略图
      final thumbnailFile = File(thumbnailPath);
      if (await thumbnailFile.exists()) {
        await thumbnailFile.delete();
      }

      // 生成缩略图
      final String? thumbnail = await VideoThumbnail.thumbnailFile(
        video: absoluteVideoPath,
        thumbnailPath: thumbnailPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 200,
        quality: 75,
        timeMs: 1000, // 从视频开始1秒处截取缩略图
      );

      if (thumbnail != null && await File(thumbnail).exists()) {
        await record.saveThumbnailPath(thumbnail);
        await _saveDownloads();
        print('缩略图生成成功: $thumbnail'); // 添加日志
        print('保存的相对路径: ${record.thumbnailRelativePath}'); // 添加日志
        notifyListeners();
      } else {
        print('生成缩略图失败: thumbnail path = $thumbnail');
      }
    } catch (e, stackTrace) {
      print('生成缩略图失败: $e');
      print('堆栈信息: $stackTrace');
    }
  }

  void retryDownload(DownloadRecord record) {
    if (record.status == DownloadStatus.failed ||
        record.status == DownloadStatus.pending) {
      if (record.status == DownloadStatus.failed) {
        record.progress = 0.0;
      }
      record.status = DownloadStatus.pending;
      notifyListeners();
      _startDownload(record);
    }
  }
}
