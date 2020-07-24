import 'package:dio/dio.dart';
import 'package:tsdemodemo_flutter/service/service_method.dart';

class ReportUploadModel {
  CancelToken cancelToken;

  void dispose() {
    cancelToken?.cancel();
  }

  // 发起举报
  Future<dynamic> requestSubmitReport(String reportTypeId, int reportTypeValue, String reportDetailTypeId, String reportDetailTypeReasonDescription) async {
    Map<String, dynamic> params = {
      'reprotID': reportTypeId,
      'type': reportTypeValue,
      'id': reportDetailTypeId,
      'desc': reportDetailTypeReasonDescription,
    };

    return await postUrl(
      'http://www.1nian.xyz:3000/mock/11/media/report/add',
      params: params,
      cancelToken: cancelToken,
//      jsonParse: (data) => ReportUploadBean(data),
    );
  }
}