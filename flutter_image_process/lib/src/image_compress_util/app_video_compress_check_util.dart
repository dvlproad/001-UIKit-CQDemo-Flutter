// ignore_for_file: constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-04-12 23:04:04
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-02-27 14:02:54
 * @Description: 视频是否可以使用的检查(是否会太长或者太大)
 */

import 'dart:io' show File;
import 'package:video_compress/video_compress.dart';

enum VideoCheckResultType {
  success, // 可以使用
  failure_tooBig, // 太大不压缩
  failure_tooLong, // 太长不压缩
}

// ignore: non_constant_identifier_names
VideoCheckResultType VideoCheckResultTypeFromString(String value) {
  // if (value == null) {
  //   return VideoCheckResultType.success;
  // }

  Iterable<VideoCheckResultType> values = [
    VideoCheckResultType.success, // 可以使用
    VideoCheckResultType.failure_tooBig, // 太大不压缩
    VideoCheckResultType.failure_tooLong, // 太长不压缩
  ];

  return values.firstWhere((type) {
    return type.toString().split('.').last == value;
  });
}

/// 视频检查结果
class VideoCheckResponseBean {
  String message;
  VideoCheckResultType type;
  dynamic reslut;

  VideoCheckResponseBean({
    required this.message,
    required this.type,
    this.reslut,
  });

  static VideoCheckResponseBean fromJson(dynamic json) {
    String message = json['message'] ?? '';

    VideoCheckResultType type = VideoCheckResultType.success;
    if (json['type'] != null) {
      type = VideoCheckResultTypeFromString(json['type']);
    }

    return VideoCheckResponseBean(
      message: message,
      type: type,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};

    map['message'] = message;

    map['type'] = type.toString().split('.').last;

    return map;
  }
}

class AppVideoCompressCheckUtil {
  static Future<VideoCheckResponseBean> getVideoCheckResponseBean(
    File file,
  ) async {
    // 原始视频信息(大小、长度等)
    final MediaInfo originMediaInfo =
        await VideoCompress.getMediaInfo(file.path);
    int? originFilesize = originMediaInfo.filesize; // bytes
    if (originFilesize != null) {
      /*
      if (originFilesize > 200 * 1000 * 1000) {
        // > 200M
        return VideoCheckResponseBean(
          message: '失败,因为视频太大',
          type: VideoCheckResultType.failure_tooBig,
          reslut: null,
        );
      }
      */
    }
    double? originDuration = originMediaInfo.duration; // milliseconds
    if (originDuration != null) {
      int originDurationSecond = (originDuration / 1000).truncate();
      if (originDurationSecond > 30 * 60) {
        // 30分钟
        return VideoCheckResponseBean(
          message: '所选视频的时长不能超过30分钟',
          type: VideoCheckResultType.failure_tooLong,
          reslut: null,
        );
      }
    }

    return VideoCheckResponseBean(
      message: '成功,视频可以使用(不会太长、也不会太大)',
      type: VideoCheckResultType.success,
      reslut: null,
    );
  }
}
