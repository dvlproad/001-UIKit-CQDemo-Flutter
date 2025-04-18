/*
 * @Author: dvlproad
 * @Date: 2025-04-16 20:04:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-18 18:32:10
 * @Description: 
 */
class DownloadRecord {
  final String videoId;
  final String videoUrl;
  final DateTime addTime;
  String? savedPath;
  String? thumbnailPath;
  double progress = 0.0;
  DownloadStatus status = DownloadStatus.pending;

  DownloadRecord({
    required this.videoId,
    required this.videoUrl,
    required this.addTime,
    this.savedPath,
    this.thumbnailPath,
  });

  // 从 JSON 创建实例
  factory DownloadRecord.fromJson(Map<String, dynamic> json) {
    final record = DownloadRecord(
      videoId: json['videoId'],
      videoUrl: json['videoUrl'],
      addTime: DateTime.parse(json['addTime']),
    );

    record.status = DownloadStatus.values[json['status'] ?? 0];
    record.progress = (json['progress'] ?? 0.0).toDouble();

    // 保存相对路径
    record.savedPath = json['savedPath'];
    record.thumbnailPath = json['thumbnailPath'];

    return record;
  }

  // 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'videoId': videoId,
      'videoUrl': videoUrl,
      'addTime': addTime.toIso8601String(),
      'status': status.index,
      'progress': progress,
      'savedPath': savedPath,
      'thumbnailPath': thumbnailPath,
    };
  }
}

enum DownloadStatus {
  pending, // 等待下载
  downloading, // 下载中
  completed, // 下载完成
  failed, // 下载失败
}
