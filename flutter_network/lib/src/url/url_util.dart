/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-03 16:24:59
 * @Description: Url获取工具
 */
import 'package:dio/dio.dart';
import '../bean/req_options.dart';
import '../bean/err_options.dart';
import '../bean/res_options.dart';
import './appendPathExtension.dart';

class UrlUtil {
  static String _fullUrl(String? baseUrl, String path) {
    String url;
    if (path.startsWith(RegExp(r'https?:'))) {
      url = path;
    } else {
      if (baseUrl == null) {
        url = path;
      } else {
        url = baseUrl.appendPathString(path);
      }
    }
    return url;
  }

  static String fullUrlFromError(ErrOptions err) {
    return _fullUrl(err.requestOptions.baseUrl, err.requestOptions.path);
  }

  static String fullUrlFromRequestOptions(ReqOptions options) {
    return _fullUrl(options.baseUrl, options.path);
  }

  static String fullUrlFromDioError(DioError err) {
    return _fullUrl(err.requestOptions.baseUrl, err.requestOptions.path);
  }

  static String fullUrlFromDioRequestOptions(RequestOptions options) {
    return _fullUrl(options.baseUrl, options.path);
  }
}
