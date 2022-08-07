import 'dart:async' show Completer, StreamSubscription;
import 'dart:developer' as developer;

import 'dart:io' show NetworkInterface, InternetAddressType, InternetAddress;
import 'dart:ui' show window;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_network/src/cache/dio_cache_util.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
// network client
import './network_client.dart';
// log
import '../log/api_log_util.dart';
// cache
import '../cache/cache_helper.dart';

class CacheNetworkClient extends NetworkClient {
  DioCacheManager? _dioCacheManager;
  DioCacheManager getCacheManager({String? baseUrl}) {
    if (null == _dioCacheManager) {
      _dioCacheManager = DioCacheManager(CacheConfig(
        baseUrl: baseUrl,
        maxMemoryCacheCount: 100,
      ));
    }
    return _dioCacheManager!;
  }

  void clearAllCache() {
    _dioCacheManager?.clearAll();
  }

  /// delete local cache by primaryKey and optional subKey
  Future<bool> delete(String primaryKey,
      {String? requestMethod, String? subKey}) {
    return _dioCacheManager!
        .delete(primaryKey, requestMethod: requestMethod, subKey: subKey);
  }

  /// no matter what subKey is, delete local cache if primary matched.
  Future<bool> deleteByPrimaryKeyWithUri(Uri uri, {String? requestMethod}) {
    return _dioCacheManager!
        .deleteByPrimaryKeyAndSubKeyWithUri(uri, requestMethod: requestMethod);
  }

  /// delete local cache when both primaryKey and subKey matched.
  Future<bool> deleteByPrimaryKeyAndSubKeyWithUri(Uri uri,
      {String? requestMethod, String? subKey, dynamic data}) {
    return _dioCacheManager!.deleteByPrimaryKeyAndSubKeyWithUri(uri,
        requestMethod: requestMethod, subKey: subKey, data: data);
  }

  /// 初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  void cache_start({
    required String baseUrl,
    String?
        contentType, // "application/json""application/x-www-form-urlencoded"
    required Map<String, dynamic> headerCommonFixParams, // header 中公共但不变的参数
    Map<String, dynamic> Function()?
        headerCommonChangeParamsGetBlock, // header 中公共但会变的参数
    required String headerAuthorization,
    required Map<String, dynamic> bodyCommonFixParams, // body 中公共但不变的参数
    Map<String, dynamic> Function()?
        bodyCommonChangeParamsGetBlock, // body 中公共但会变的参数
    List<String>?
        commonIgnoreKeysForCache, // 缓存key的生成忽略一些特殊的参数(如trace_id,retry_count等)
    bool allowMock = false, // 是否允许 mock api
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    String Function(String apiPath)?
        localApiDirBlock, // 本地网络所在的目录,需要本地模拟时候才需要设置
  }) {
    List<Interceptor> extraInterceptors = [
      getCacheManager(baseUrl: baseUrl).interceptor,
    ];

    super.normal_start(
      baseUrl: baseUrl,
      contentType: contentType,
      extraInterceptors: extraInterceptors,
      headerCommonFixParams: headerCommonFixParams,
      headerCommonChangeParamsGetBlock: headerCommonChangeParamsGetBlock,
      headerAuthorization: headerAuthorization,
      bodyCommonFixParams: bodyCommonFixParams,
      bodyCommonChangeParamsGetBlock: bodyCommonChangeParamsGetBlock,
      dealRequestOptionsAction: (RequestOptions options) {
        CacheHelper.addSubKeyToOptions(
          options,
          ignoreKeys: commonIgnoreKeysForCache,
        );
      },
      localApiDirBlock: localApiDirBlock,
    );

    DioCacheUtil.initDioCacheUtil(
      isCacheRequestCheckBlock: (options) {
        bool isRequestCache = CacheHelper.isCacheRequest(options);
        return isRequestCache;
      },
      isCacheErrorCheckBlock: (err) {
        bool isFromCache = CacheHelper.isCacheError(err);
        return isFromCache;
      },
      isCacheResponseCheckBlock: (response) {
        bool isFromCache = CacheHelper.isCacheResponse(response);
        return isFromCache;
      },
    );
  }

  /// 通用的POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  /*
  Future<ResponseModel> _post(
    String api, {
    Map<String, dynamic> customParams,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
  }) async {
    Completer<ResponseModel> completer = Completer();
    postWithCallback(
      api,
      customParams: customParams,
      cacheLevel: cacheLevel,
      completeCallBack: (responseModel) {
        if (responseModel.isCache != true) {
          completer.complete(responseModel);
        }
      },
    );

    return completer.future;
  }
  */

  /// 具有更丰富功能的 post 接口(因为即使有缓存也只会返回一次，所以无法使用)
  Future<ResponseModel> cache_post(
    String api, {
    Map<String, dynamic>? customParams,
    int retryCount = 0,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
  }) async {
    Completer _requestCompleter = Completer<String>();

    late ResponseModel responseModel;
    cache_postWithCallback(
      api,
      customParams: customParams,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      completeCallBack: (ResponseModel bResponseModel) {
        if (_requestCompleter.isCompleted != true) {
          _requestCompleter.complete('所有请求(含重试、缓存)结束');
        }

        responseModel = bResponseModel;
      },
    );

    await _requestCompleter.future;
    return responseModel;
  }

  void cache_postWithCallback(
    String api, {
    Map<String, dynamic>? customParams,
    int retryCount = 0,
    NetworkCacheLevel cacheLevel = NetworkCacheLevel.none,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) {
    postWithRetryCallback(
      api,
      customParams: customParams,
      retryCount: retryCount,
      options: CacheHelper.buildOptions(cacheLevel),
      completeCallBack: (ResponseModel responseModel) async {
        if (completeCallBack == null) {
          debugPrint('温馨提示:本次请求，你没有实现回调方法$api');
          return;
        }

        // 不是真正的网络请求返回的Response\Error结果(eg:比如是取缓存的结果时候)
        bool noRealRequest = cacheLevel == NetworkCacheLevel.one;
        if (responseModel.isCache != true) {
          // 1、当请求结果是后台实际请求返回的时候:
          if (responseModel.isSuccess) {
            // ①.如果实际的请求成功，则直接返回
            completeCallBack(responseModel);
          } else {
            // ②.如果实际的请求失败，由于 statusCode 在200到300之间的请求结果都会被保存起来，但我们此系统里他们可能是错误的。
            // 如500，就不要保存起来了，防止请求的时候发现有缓存数据，使得页面使用到了保存的数据
            if (cacheLevel != NetworkCacheLevel.none) {
              Uri uri = getUri(api);
              bool deleteSuccess = await deleteByPrimaryKeyAndSubKeyWithUri(uri,
                  requestMethod: 'POST', data: customParams);
              if (deleteSuccess == false) {
                debugPrint("Warning:本不该纯，但存了，现在必须删却又没删除成功的接口");
              }
            }
            completeCallBack(responseModel);
          }
        } else {
          // 2、请求结果是之前缓存的数据返回的(即结果是真正的网络请求返回的Response\Error结果)的时候，
          // ①先把缓存返回回去，
          // ②再继续发起实际的请求，且新请求为后台实际请求并且其要会保存请求成功的数据
          completeCallBack(responseModel);

          late NetworkCacheLevel newCacheLevel;
          if (cacheLevel == NetworkCacheLevel.one) {
            newCacheLevel = NetworkCacheLevel.forceRefreshAndCacheOne;
          } else {
            debugPrint('Error：判断出错啦，此结果不是缓存数据，却走到了isCache==true');
            newCacheLevel = NetworkCacheLevel
                .none; //TODO:临时为了走下去，应该自始至终都不会走到这里，这里之后要 throw Exception
          }

          cache_postWithCallback(
            api,
            customParams: customParams,
            cacheLevel: newCacheLevel,
            completeCallBack: completeCallBack,
          );
        }
      },
    );
  }
}