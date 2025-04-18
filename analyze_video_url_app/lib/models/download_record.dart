/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-18 20:33:15
 * @Description: 
 */
import 'package:path_provider/path_provider.dart';

class DownloadRecord {
  final String videoId;
  final String videoUrl;
  late String uniqueId; // 改为 late，允许在构造后修改
  final DateTime addTime;
  String? saveRelativePath; // 更改字段名
  String? thumbnailPath;
  DownloadStatus status;
  double progress;
  int? totalSize;

  DownloadRecord({
    required this.videoId,
    required this.videoUrl,
    required this.addTime,
    this.saveRelativePath, // 更改字段名
    this.thumbnailPath,
    this.status = DownloadStatus.pending,
    this.progress = 0.0,
    this.totalSize,
  }) : uniqueId = '${videoId}_${DateTime.now().millisecondsSinceEpoch}';

  Map<String, dynamic> toJson() => {
        'videoId': videoId,
        'videoUrl': videoUrl,
        'uniqueId': uniqueId,
        'saveRelativePath': saveRelativePath, // 更改字段名
        'thumbnailPath': thumbnailPath,
        'status': status.index,
        'progress': progress,
        'addTime': addTime.toIso8601String(),
        'totalSize': totalSize,
      };

  factory DownloadRecord.fromJson(Map<String, dynamic> json) => DownloadRecord(
        videoId: json['videoId'],
        videoUrl: json['videoUrl'],
        saveRelativePath:
            json['saveRelativePath'] ?? json['savedPath'], // 兼容旧数据
        thumbnailPath: json['thumbnailPath'],
        status: DownloadStatus.values[json['status']],
        progress: json['progress'] ?? 0.0,
        addTime: DateTime.parse(json['addTime']),
        totalSize: json['totalSize'],
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
    if (thumbnailPath == null) return null;
    return _getAbsolutePath(thumbnailPath!);
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
    thumbnailPath = await _getRelativePath(absolutePath);
  }
}

enum DownloadStatus {
  pending, // 等待下载
  downloading, // 下载中
  completed, // 下载完成
  failed, // 下载失败
}
