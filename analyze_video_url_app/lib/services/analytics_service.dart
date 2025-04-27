/*
 * @Author: dvlproad
 * @Date: 2025-04-27 22:35:48
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-27 22:35:51
 * @Description: 
 */
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final _analytics = FirebaseAnalytics.instance;
  final _crashlytics = FirebaseCrashlytics.instance;

  // 开始解析视频
  Future<void> logStartAnalyze(String url) async {
    await _analytics.logEvent(
      name: 'start_analyze_video',
      parameters: {'url': url},
    );
  }

  // 解析成功
  void logAnalyzeSuccess(String videoId, String originalUrl) {
    _analytics.logEvent(
      name: 'analyze_success',
      parameters: {
        'video_id': videoId,
        'original_url': originalUrl,
      },
    );
  }

  // 解析失败
  void logAnalyzeFailed(String error, String url) {
    _analytics.logEvent(
      name: 'analyze_failed',
      parameters: {
        'error': error,
        'url': url,
      },
    );

    _crashlytics.recordError(
      'URL Parse Failed: $error',
      StackTrace.current,
      reason: 'URL: $url',
      fatal: false,
    );
  }

  // 意外错误
  void logError(dynamic error, StackTrace stack, String url) {
    _crashlytics.recordError(error, stack);
    _analytics.logEvent(
      name: 'analyze_error',
      parameters: {
        'error': error.toString(),
        'url': url,
      },
    );
  }
}
