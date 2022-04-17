/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-04-18 00:19:10
 * @Description: 本地接口模拟工具
 */
import 'dart:convert' show json;
import 'package:flutter/services.dart' show rootBundle;
import '../network_bean.dart';
import '../url/appendPathExtension.dart';
import '../interceptor/interceptor_log.dart';
import '../log/dio_log_util.dart';
import 'package:flutter_log/src/string_format_util/formatter_object_util.dart';
import 'package:flutter_log/src/string_format_util/long_string_print_util.dart';

class LocalMockUtil {
  static String localApiHost = "local_api_json_file";

  // 本地网络所在的目录
  static String Function(String apiPath) localApiDirBlock;
  // var value = await rootBundle.loadString("assets/data/app_info.json");
  // var value = await rootBundle.loadString("packages/flutter_updateversion_kit/assets/data/app_info.json");

  // 网络请求的最底层方法
  static Future<ResponseModel> requestLocalFilePath(String apiPath) async {
    try {
      if (localApiDirBlock == null) {
        throw Exception("请先设置 localApiDirBlock");
      }
      String localApiFileDir = localApiDirBlock(apiPath);
      String localFileName = apiPath.splitMapJoin(
        "/",
        onMatch: (Match match) {
          return ":";
        },
      );

      String localFilePath =
          localApiFileDir.appendPathString("$localFileName.json");

      String responseString = await rootBundle.loadString(localFilePath);
      Map<String, dynamic> responseMap = json.decode(responseString);

      String responseLogString =
          FormatterUtil.convert(responseMap, 0, isObject: true);
      DioLogUtil.logApi(apiPath, responseLogString, ApiProcessType.response,
          ApiLogLevel.normal); // 此类不会走拦截器

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
      String message = '请求$apiPath的时候，发生网络错误,未设置json文件${e.message}';
      String responseLogString = "Error:接口本地模拟发生错误:$message"; // 此类不会走拦截器

      DioLogUtil.logApi(
          apiPath, responseLogString, ApiProcessType.error, ApiLogLevel.error);

      return ResponseModel.errorResponseModel(message);
    }
  }
}
