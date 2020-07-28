import 'package:dio/dio.dart';
import 'package:tsdemodemo_flutter/service/service_method.dart';

class RankingListModel {
  CancelToken cancelToken;

  void dispose() {
    cancelToken?.cancel();
  }

  // 获取举报列表
  Future<dynamic> requestRankingList() async {
    return await postUrl(
      'http://www.1nian.xyz:3000/mock/11/aroundUsers_1595817233708',
      cancelToken: cancelToken,
//      jsonParse: (data) => ReportListBean(data),
    );
  }
}