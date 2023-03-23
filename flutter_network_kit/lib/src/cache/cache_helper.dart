/*
 * @Author: dvlproad
 * @Date: 2022-03-10 21:45:38
 * @LastEditTime: 2023-03-23 18:09:44
 * @LastEditors: dvlproad
 * @Description: 网络缓存帮助类
 */
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
// ignore: implementation_imports
import 'package:flutter_network/src/url/url_util.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

// ignore: constant_identifier_names
const DIO_CACHE_KEY_CACHE_LEVEL = "dio_cache_cache_level";

/// 网络缓存
enum NetworkCacheLevel {
  none, // 不需要缓存（接下来的request时候不取缓存，也不会对其response结果进行缓存来备下次使用）
  one, // 先取缓存，有结果再缓存一次(接下来的request时候先取缓存，同时会对其response结果进行缓存以备下次使用)
  forceRefreshAndCacheOne, // 强制刷新并缓存结果(即接下来的request直接请求后台接口，同时对返回结果response进行缓存以备下次使用)
}

class CacheHelper {
  static Options? buildOptions(
    NetworkCacheLevel cacheLevel, {
    Options? options,
  }) {
    // options = Options(
    //   contentType: "application/x-www-form-urlencoded",
    // );
    options ??= Options();
    options.extra ??= {};
    options.extra!.addAll({DIO_CACHE_KEY_CACHE_LEVEL: cacheLevel});

    Options? dioOptions;
    if (cacheLevel == NetworkCacheLevel.one) {
      dioOptions = buildCacheOptions(
        const Duration(days: 0, hours: 1),
        options: options,
        forceRefresh: false,
      );
    } else if (cacheLevel == NetworkCacheLevel.forceRefreshAndCacheOne) {
      dioOptions = buildCacheOptions(
        const Duration(days: 0, hours: 1),
        options: options,
        forceRefresh: true,
      );
    }

    return dioOptions;
  }

  static void addSubKeyToOptions(
    RequestOptions options, {
    List<String>? ignoreKeys,
  }) {
    // String cacheSubKey = '1';
    String cacheSubKey = _getSubKeyFromUri(options.uri,
        data: options.data, ignoreKeys: ignoreKeys);
    if (cacheSubKey.isNotEmpty) {
      options.extra.addAll({DIO_CACHE_KEY_SUB_KEY: cacheSubKey});
    }
  }

  // static String _getPrimaryKeyFromUri(Uri uri) => "${uri.host}${uri.path}";

  static String _getSubKeyFromUri(
    Uri uri, {
    dynamic data,
    List<String>? ignoreKeys,
  }) {
    late String subKey;

    if (data == null) {
      subKey = "_${uri.query}";
    } else {
      if (data is Map) {
        Map map = Map.from(data); // 深复制，防止入参丢失

        if (ignoreKeys != null) {
          for (var ignoreKey in ignoreKeys) {
            if (map.containsKey(ignoreKey)) {
              map.remove(ignoreKey);
            }
          }
        }
        subKey = "${map.toString()}_${uri.query}";
      } else {
        subKey = "${data.toString()}_${uri.query}";
      }
    }

    return subKey;
  }

  static bool isCacheRequest(RequestOptions options) {
    bool isTryCache = _isTryCacheRequestOptions(
        options); // 此方法只能判断一开始是否是尝试请求缓存，不代表一定是请求缓存，因为缓存不存在时候，会直接请求实际接口

    // bool isFromCache = _isCacheHeadersMap(options.headers);
    // bool isFromCache = options.headers["currentIsRequestCache"] ??
    //     false; // 需要在 DioCacheManager 中 自己添加 options.headers..addAll({"currentIsRequestCache": true});
    bool isFromCache =
        false; // TODO:暂时无明确方法，可判断该请求最后是请求缓存还是实际接口，干脆不标明接口是请求什么。目前考虑的方式是在 DioCacheManager 中 自己添加 options.headers..addAll({"currentIsRequestCache": true});但无效
    if (isTryCache == true) {
      String fullUrl = UrlUtil.fullUrlFromDioRequestOptions(options);
      _log(
          "友情提示:优先尝试请求缓存，但最后是缓存请求还是实际请求，取决于缓存请求的时候 _pullFromCacheBeforeMaxAge 有没有数据，若没有会直接在 _onRequest 中进行实际请求，而不会再开一个请求:$fullUrl");
    }

    return isFromCache;
  }

  static bool isCacheError(DioError err) {
    bool isTryCache = _isTryCacheRequestOptions(err.requestOptions);

    late bool isFromCache;
    if (err.response == null) {
      isFromCache = false;
    } else {
      isFromCache = _isCacheHeadersMap(err.response!.headers.map);
    }
    if (isTryCache == true && isFromCache == false) {
      String fullUrl = UrlUtil.fullUrlFromDioError(err);
      _log("本来是尝试优先请求缓存的，但最后因为没有缓存数据，变成了直接取请求实际后台接口:$fullUrl");
    }
    return isFromCache;
  }

  static bool isCacheResponse(Response response) {
    bool isTryCache = _isTryCacheRequestOptions(response.requestOptions);
    bool isFromCache = _isCacheHeadersMap(response.headers
        .map); // 此方法很重要，用于处理避免在尝试请求缓存的时候，因为是第一次或无缓存，导致实际直接请求的是后台接口，如果这个时候你还认为稍后返回的结果是缓存的，那会导致，待会要再重新请求一遍后台接口的错误，导致后台接口请求了两次。
    if (isTryCache == true && isFromCache == false) {
      String fullUrl =
          UrlUtil.fullUrlFromDioRequestOptions(response.requestOptions);
      _log("本来是尝试优先请求缓存的，但最后因为没有缓存数据，变成了直接取请求实际后台接口:$fullUrl");
    }
    return isFromCache;
  }

  static bool _isTryCacheRequestOptions(RequestOptions options) {
    // NetworkCacheLevel networkCacheLevel =
    //     options.extra[DIO_CACHE_KEY_CACHE_LEVEL] ?? NetworkCacheLevel.none;

    bool tryCache = options.extra[DIO_CACHE_KEY_TRY_CACHE] ?? false;
    bool forceRefresh = options.extra[DIO_CACHE_KEY_FORCE_REFRESH] ?? false;
    bool isTryCache = (tryCache == true && forceRefresh == false);
    return isTryCache;
  }

  static bool _isCacheHeadersMap(Map headersMap) {
    if (headersMap == null) {
      return false;
    }
    // String fromCacheValue = headersMap.values.last[0];
    // bool isFromCache = fromCacheValue == 'from_cache';
    bool isFromCache = false;
    List<String> cacheHeaders = headersMap[DIO_CACHE_HEADER_KEY_DATA_SOURCE];
    if (cacheHeaders != null && cacheHeaders.isNotEmpty) {
      String fromCacheValue = cacheHeaders[0];
      isFromCache = fromCacheValue == 'from_cache';
    }

    return isFromCache;
  }

  static void _log(String message) {
    String dateTimeString = DateTime.now().toString().substring(0, 19);
    debugPrint('$dateTimeString:$message');
  }
}
