/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:33
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-16 22:01:06
 * @Description: 
 */
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
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
      notifyListeners();
    } catch (e) {
      record.status = DownloadStatus.failed;
      notifyListeners();
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
}
