/*
 * @Author: dvlproad
 * @Date: 2022-04-16 19:19:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-17 23:48:44
 * @Description: dio的缓存判断工具
 */
import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class DioCacheUtil {
  static bool Function(RequestOptions options) isRequestCacheCheckFunction;
  static bool Function(DioError err) isCacheErrorCheckFunction;
  static bool Function(Response response) isCacheResponseCheckFunction;

  static void initDioLogUtil({
    bool Function(RequestOptions options) isCacheRequestCheckBlock,
    bool Function(DioError err) isCacheErrorCheckBlock,
    bool Function(Response response) isCacheResponseCheckBlock,
  }) {
    isRequestCacheCheckFunction = isCacheRequestCheckBlock;
    isCacheErrorCheckFunction = isCacheErrorCheckBlock;
    isCacheResponseCheckFunction = isCacheResponseCheckBlock;
  }
}
