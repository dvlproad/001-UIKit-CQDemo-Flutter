/*
 * @Author: dvlproad
 * @Date: 2022-03-10 21:45:38
 * @LastEditTime: 2022-04-13 03:10:01
 * @LastEditors: Please set LastEditors
 * @Description: 网络缓存帮助类
 */
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

const DIO_CACHE_KEY_CACHE_LEVEL = "dio_cache_cache_level";

/// 网络缓存
enum NetworkCacheLevel {
  none, // 不需要缓存
  one,
  forceRefreshAndCacheOne, // 强制刷新本次，并且缓存本次的数据以备下次使用

}

class CacheHelper {
  static Options buildOptions(
    NetworkCacheLevel cacheLevel, {
    Options options,
  }) {
    // options = Options(
    //   contentType: "application/x-www-form-urlencoded",
    // );
    options ??= Options();
    options.extra ??= {};
    options.extra.addAll({DIO_CACHE_KEY_CACHE_LEVEL: cacheLevel});

    Options dioOptions = null;
    if (cacheLevel == NetworkCacheLevel.one) {
      dioOptions = buildCacheOptions(
        Duration(days: 0, hours: 1),
        options: options,
        forceRefresh: false,
      );
    } else if (cacheLevel == NetworkCacheLevel.forceRefreshAndCacheOne) {
      dioOptions = buildCacheOptions(
        Duration(days: 0, hours: 1),
        options: options,
        forceRefresh: true,
      );
    }

    return dioOptions;
  }

  static bool isCacheRequest(RequestOptions options) {
    // bool isFromCache = options.extra[DIO_CACHE_KEY_TRY_CACHE] ?? false;
    NetworkCacheLevel cacheLevel =
        options.extra[DIO_CACHE_KEY_CACHE_LEVEL] ?? NetworkCacheLevel.none;
    bool isFromCache = cacheLevel == NetworkCacheLevel.one;
    return isFromCache;
  }

  static bool isCacheError(DioError err) {
    bool isFromCache =
        err.requestOptions.extra[DIO_CACHE_KEY_TRY_CACHE] ?? false;
    // bool isFromCache = _isCacheHeaders(err.response.headers);
    return isFromCache;
  }

  static bool isCacheResponse(Response response) {
    // bool isFromCache = response.requestOptions.extra[DIO_CACHE_KEY_TRY_CACHE] ?? false; // 此判断条件经测试不准
    bool isFromCache = _isCacheHeaders(response.headers);
    return isFromCache;
  }

  static bool _isCacheHeaders(Headers headers) {
    // String fromCacheValue = headers.map.values.last[0];
    // bool isFromCache = fromCacheValue == 'from_cache';
    bool isFromCache = false;
    List<String> cacheHeaders = headers.map['dio_cache_header_key_data_source'];
    if (cacheHeaders != null && cacheHeaders.isNotEmpty) {
      String fromCacheValue = cacheHeaders[0];
      isFromCache = fromCacheValue == 'from_cache';
    }

    return isFromCache;
  }
}
