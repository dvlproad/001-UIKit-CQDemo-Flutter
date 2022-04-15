import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import '../network_bean.dart';

class LocalMockUtil {
  // 网络请求的最底层方法
  static Future<ResponseModel> requestLocalFilePath(
      String localFilePath) async {
    try {
      String localFileName = localFilePath.splitMapJoin(
        "/",
        onMatch: (Match match) {
          return ":";
        },
      );
      localFilePath = "asset/data/$localFileName.json";

      String responseString = await rootBundle.loadString(localFilePath);
      Map<String, dynamic> responseMap = json.decode(responseString);

      var errorCode = responseMap['code'];
      var msg = responseMap['msg'];
      dynamic result = responseMap["data"];
      ResponseModel responseModel = ResponseModel(
        statusCode: errorCode,
        message: msg,
        result: result,
      );
      return responseModel;
    } catch (e) {
      String message = '请求$localFilePath的时候，发生网络错误,未设置json文件${e.message}';
      return ResponseModel.errorResponseModel(message);
    }
  }
}
