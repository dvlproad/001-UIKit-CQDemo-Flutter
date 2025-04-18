/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-18 20:33:15
 * @Description: 
 */
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class DownloadRecord {
  String videoId;
  String videoUrl;
  String? saveRelativePath;
  String? thumbnailRelativePath;
  int? totalSize;
  double progress;
  DateTime addTime;
  String uniqueId;

  // 添加状态变化回调
  Function(DownloadStatus)? onStatusChanged;

  // 内部状态字段
  DownloadStatus _status = DownloadStatus.pending;

  // 获取状态
  DownloadStatus get status => _status;

  // 设置状态并触发回调
  set status(DownloadStatus newStatus) {
    if (this._status != newStatus) {
      this._status = newStatus;
      onStatusChanged?.call(newStatus);
    }
  }

  CancelToken? cancelToken;

  DownloadRecord({
    required this.videoId,
    required this.videoUrl,
    this.saveRelativePath,
    this.thumbnailRelativePath,
    DownloadStatus? status,
    this.progress = 0.0,
    this.totalSize,
    DateTime? addTime,
    this.onStatusChanged,
  })  : uniqueId = '${videoId}_${DateTime.now().millisecondsSinceEpoch}',
        addTime = addTime ?? DateTime.now() {
    if (status != null) {
      this._status = status;
    }
  }

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'videoUrl': videoUrl,
        'uniqueId': uniqueId,
        'saveRelativePath': saveRelativePath,
        'thumbnailPath': thumbnailRelativePath,
        'status': status.index,
        'progress': progress,
        'addTime': addTime.toIso8601String(),
        'totalSize': totalSize,
      };

  factory DownloadRecord.fromJson(Map<String, dynamic> json) => DownloadRecord(
        videoId: json['videoId'],
        videoUrl: json['videoUrl'],
        saveRelativePath: json['saveRelativePath'],
        thumbnailRelativePath: json['thumbnailPath'],
        status: DownloadStatus.values[json['status']],
        progress: json['progress'] ?? 0.0,
        addTime: DateTime.parse(json['addTime']),
        totalSize: json['totalSize'],
        onStatusChanged: null, // 这里需要根据实际情况来实现
      )..uniqueId = json['uniqueId'] ??
          '${json['videoId']}_${DateTime.now().millisecondsSinceEpoch}'; // 恢复 uniqueId，如果没有则生成新的

  // 获取基础路径
  static Future<String> _getBasePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // 相对路径转绝对路径
  static Future<String> _getAbsolutePath(String relativePath) async {
    final basePath = await _getBasePath();
    return '$basePath$relativePath';
  }

  // 绝对路径转相对路径
  static Future<String> _getRelativePath(String absolutePath) async {
    final basePath = await _getBasePath();
    return absolutePath.replaceFirst(basePath, '');
  }

  // 获取视频保存路径
  Future<String> getSaveVideoPath() async {
    final basePath = await _getBasePath();
    return '$basePath/videos/${uniqueId}.mp4';
  }

  // 获取视频临时文件路径
  Future<String> getSaveTempPath() async {
    final videoPath = await getSaveVideoPath();
    return '$videoPath.temp';
  }

  // 获取视频绝对路径
  Future<String?> getVideoAbsolutePath() async {
    if (saveRelativePath == null) return null;
    return _getAbsolutePath(saveRelativePath!);
  }

  // 获取缩略图绝对路径
  Future<String?> getThumbnailAbsolutePath() async {
    if (thumbnailRelativePath == null) return null;
    return _getAbsolutePath(thumbnailRelativePath!);
  }

  // 获取新缩略图保存路径
  Future<String> getNewThumbnailPath() async {
    final basePath = await _getBasePath();
    return '$basePath/thumbnails/${uniqueId}.jpg'; // 使用 uniqueId 而不是 videoId
  }

  // 保存视频相对路径
  Future<void> saveVideoPath(String absolutePath) async {
    saveRelativePath = await _getRelativePath(absolutePath);
  }

  // 保存缩略图相对路径
  Future<void> saveThumbnailPath(String absolutePath) async {
    thumbnailRelativePath = await _getRelativePath(absolutePath);
  }
}

enum DownloadStatus {
  pending, // 等待下载
  downloading, // 下载中
  completed, // 下载完成
  failed, // 下载失败
}
