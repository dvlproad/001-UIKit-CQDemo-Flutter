import 'package:dio/dio.dart';
import 'package:tsdemodemo_flutter/service/service_method.dart';

class ReportListModel {
  CancelToken cancelToken;

  void dispose() {
    cancelToken?.cancel();
  }

  // 获取举报列表
  Future<dynamic> requestReportList() async {
    Map<String, dynamic> params = {

    };

    return await postUrl(
      'http://www.1nian.xyz:3000/mock/11/getReports',
      params: params,
      cancelToken: cancelToken,
//      jsonParse: (data) => ReportListBean(data),
    );
  }
}