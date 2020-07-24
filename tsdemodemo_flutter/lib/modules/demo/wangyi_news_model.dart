import 'package:dio/dio.dart';
import 'package:tsdemodemo_flutter/service/service_method.dart';

class WangyiNiewsModel {
  CancelToken cancelToken;

  void dispose() {
    cancelToken?.cancel();
  }

  // 获取网易新闻POST
  Future requestWangYiNews() async {
    return await postUrl(
      'https://api.apiopen.top/getWangYiNews',
      params: {"page": 1, "count": 5},
      cancelToken: cancelToken,
    );
  }
}