class DownloadRecord {
  final String videoId;
  final String videoUrl;
  final DateTime addTime;
  String? savedPath;
  double progress = 0.0;
  DownloadStatus status = DownloadStatus.pending;

  DownloadRecord({
    required this.videoId,
    required this.videoUrl,
    required this.addTime,
    this.savedPath,
  });
}

enum DownloadStatus {
  pending, // 等待下载
  downloading, // 下载中
  completed, // 下载完成
  failed, // 下载失败
}
