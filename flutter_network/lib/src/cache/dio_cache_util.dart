/*
 * @Author: dvlproad
 * @Date: 2022-04-16 19:19:30
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-03 15:17:12
 * @Description: dio的缓存判断工具
 */
import 'dart:convert' as convert;
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

class DioCacheUtil {
  static bool Function(RequestOptions options) isRequestCacheCheckFunction =
      (options) {
    return false;
  };
  static bool Function(DioError err) isCacheErrorCheckFunction = (err) {
    return false;
  };
  static bool Function(Response response) isCacheResponseCheckFunction =
      (response) {
    return false;
  };

  static void initDioCacheUtil({
    required bool Function(RequestOptions options) isCacheRequestCheckBlock,
    required bool Function(DioError err) isCacheErrorCheckBlock,
    required bool Function(Response response) isCacheResponseCheckBlock,
  }) {
    isRequestCacheCheckFunction = isCacheRequestCheckBlock;
    isCacheErrorCheckFunction = isCacheErrorCheckBlock;
    isCacheResponseCheckFunction = isCacheResponseCheckBlock;
  }
}
