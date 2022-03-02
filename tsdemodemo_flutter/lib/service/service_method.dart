// 网络请求
import 'package:dio/dio.dart';

typedef T JsonParse<T>(dynamic data);

Future<T> postUrl<T>(
  url, {
  Map<String, dynamic> params,
  cancelToken,
  JsonParse<T> jsonParse,
}) async {
  if (cancelToken == null) {
    cancelToken = CancelToken();
  }

  try {
    BaseOptions options =
        BaseOptions(connectTimeout: 60000, receiveTimeout: 60000);
    Dio _dio = Dio(options);

    Response response;
    if (params == null) {
      params = {};
      // response = await Service().dio.post(url, cancelToken: cancelToken);
    }
    response = await _dio.post(url, data: params, cancelToken: cancelToken);

    if (response.statusCode == 200) {
      var err = response.data['err'];
      if (err is int && err == 0) {
        if (jsonParse != null) {
          return jsonParse(response.data["data"]);
        } else {
          return response.data["data"] ?? true;
        }
      } else {
        print("${response.data}");
        return Future.error(response.data);
      }
    } else {
      throw Exception('后端接口出现异常');
    }
  } catch (e) {
    String errorMessage = e.toString();

    String fullUrl = url;
    String message = '请求$fullUrl的时候，发生网络错误:$errorMessage';

    // Response response = Response(
    //   statusCode: -1,
    //   data: null,
    // );
    return null;
  }
}
