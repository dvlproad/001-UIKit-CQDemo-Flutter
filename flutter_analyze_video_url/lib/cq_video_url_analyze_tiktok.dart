/*
 * @Author: dvlproad
 * @Date: 2025-03-31 16:08:51
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-03-31 21:54:43
 * @Description: Tiktok 的视频地址地址
 */
import 'dart:convert';
import 'package:dio/dio.dart';

enum CQAnalyzeVideoUrlType {
  audio, // 音频
  videoOriginal, // 原始视频
  videoWithoutWatermark, // 视频有水印
  videoWithoutWatermarkHD, // 视频无水印
  imageCover, // 封面图片
}

extension UrlValueExtractor on String {
  String? cjnetworkUrlValueForKey(String key) {
    final pattern = RegExp("/$key/(\\d+)");
    final match = pattern.firstMatch(this);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }
    return null;
  }
}

class CQVideoUrlAnalyzeTiktok {
  static final Dio _dio = Dio(BaseOptions(
    // headers: {'User-Agent': 'Mozilla/5.0'},
    // followRedirects: false,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    // validateStatus: (status) {
    //   return status != null && status < 500;
    // },
  ));

  /// 从短链中获取指定类型的地址（先扩展短链，再获取id，再根据类型拼接得到最终地址）
  static Future<void> requestUrlFromShortenedUrl(
    String shortenedUrl,
    CQAnalyzeVideoUrlType type, {
    required Function(String expandedUrl, String videoId, String resultUrl)
        success,
    required Function(String errorMessage) failure,
  }) async {
    try {
      String? expandedUrl = await expandShortenedUrl(shortenedUrl);
      //String? expandedUrl = "https://www.tiktok.com/@vokhangg_/video/7473862728306674951?_t=ZT-8uEtlflgN8Y&_r=1";
      if (expandedUrl == null) {
        failure("获取短链重定向/扩展后的 videoId 失败");
        return;
      }

      String? videoId =
          expandedUrl.cjnetworkUrlValueForKey("video"); // 输出：123456789
      if (videoId == null || videoId.isEmpty) {
        failure("无法解析 videoId");
        return;
      }

      String resultUrl = getVideoInfo(type, videoId);
      success(expandedUrl, videoId, resultUrl);
    } catch (e) {
      failure(e.toString());
    }
  }

  /// 获取不同类型的视频地址
  static const String baseUrl = "https://www.tikwm.com/video";
  static String getVideoInfo(CQAnalyzeVideoUrlType type, String videoId) {
    switch (type) {
      case CQAnalyzeVideoUrlType.audio:
        return "$baseUrl/music/$videoId.mp3";
      case CQAnalyzeVideoUrlType.videoOriginal:
        return "$baseUrl/media/play/$videoId.mp4";
      case CQAnalyzeVideoUrlType.videoWithoutWatermark:
        return "$baseUrl/media/wmplay/$videoId.mp4";
      case CQAnalyzeVideoUrlType.videoWithoutWatermarkHD:
        return "$baseUrl/media/hdplay/$videoId.mp4";
      case CQAnalyzeVideoUrlType.imageCover:
        return "$baseUrl/cover/$videoId.webp";
    }
  }

  /// 扩展短链
  static Future<String?> expandShortenedUrl(String shortenedUrl) async {
    try {
      final response = await Dio().get(shortenedUrl);
      if (response.statusCode == 200) {
        if (response.redirects.isNotEmpty) {
          final redirectUrl = response.redirects.last.location.toString();
          print('Redirected to: $redirectUrl');
          return redirectUrl;
        } else {
          print('No redirects, using original shortenedUrl: $shortenedUrl');
        }
      } else {
        print('No redirects, using original shortenedUrl: $shortenedUrl');
      }

      return shortenedUrl;
    } catch (e) {
      print("Error expanding URL: $e");
      return null;
    }
  }
}
