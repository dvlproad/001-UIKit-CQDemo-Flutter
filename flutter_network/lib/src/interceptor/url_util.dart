import 'package:dio/dio.dart';
import './appendPathExtension.dart';

class UrlUtil {
  static String _fullUrl(String baseUrl, String path) {
    String url;
    if (path.startsWith(RegExp(r'https?:'))) {
      url = path;
    } else {
      url = baseUrl.appendPathString(path);
    }
    return url;
  }

  static String fullUrlFromDioError(DioError err) {
    return _fullUrl(err.requestOptions.baseUrl, err.requestOptions.path);
  }

  static String fullUrlFromDioRequestOptions(RequestOptions options) {
    return _fullUrl(options.baseUrl, options.path);
  }
}
