/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-03 15:08:15
 * @Description: 本地接口模拟工具
 */
import 'dart:io' show File;
import 'dart:convert' show json;
import 'package:meta/meta.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../network_bean.dart';
import '../url/appendPathExtension.dart';
import '../log/dio_log_util.dart';
import '../interceptor_log/dio_interceptor_log.dart';
import 'package:flutter_log/src/string_format_util/formatter_object_util.dart';
import 'package:flutter_log/src/log_console/long_string_print_util.dart';

import '../bean/net_options_convert_util.dart';
import '../bean/net_options.dart';
import '../bean/req_options.dart';
import '../bean/err_options.dart';
import '../bean/res_options.dart';

import '../url/url_util.dart';

class LocalMockUtil {
  static String localApiHost = "local_api_json_file";

  // 本地网络所在的目录
  static String Function(String apiPath)? localApiDirBlock;
  // var value = await rootBundle.loadString("assets/data/app_info.json");
  // var value = await rootBundle.loadString("packages/flutter_updateversion_kit/assets/data/app_info.json");

  // 网络请求的最底层方法
  static Future<ResponseModel> requestLocalFilePath(
    String apiPath, {
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
  }) async {
    try {
      if (localApiDirBlock == null) {
        throw Exception("请先设置 localApiDirBlock");
      }
      String localApiFileDir = localApiDirBlock!(apiPath);
      String localFileName = apiPath.splitMapJoin(
        "/",
        onMatch: (Match match) {
          return ":";
        },
      );

      String localFilePath =
          localApiFileDir.appendPathString("$localFileName.json");
      /* // 以下判断文件是否存在的方式，不准确
      File pdf = File(localFilePath);
      bool exist = await pdf.exists();
      if (exist == false) {
        localFilePath = localApiFileDir.appendPathString("$localFileName");
        pdf = File(localFilePath);
        exist = await pdf.exists();
      }
      */

      String responseString = await rootBundle.loadString(localFilePath);

      Map<String, dynamic> responseMap = json.decode(responseString);
      /*
      var errorCode = responseMap['code'];
      var msg = responseMap['msg'];
      dynamic result = responseMap["data"];
      ResponseModel responseModel = ResponseModel(
        statusCode: errorCode,
        message: msg,
        result: result,
      );
      */

      ReqOptions reqOptions = ReqOptions(
        baseUrl: localApiHost,
        path: apiPath,
      );

      ResOptions resOpt = ResOptions(
        statusCode: 0,
        data: responseMap,
        requestOptions: reqOptions,
      );

      NetOptions apiInfo = NetOptions(
        reqOptions: reqOptions,
        resOptions: resOpt,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );

      String fullUrl = reqOptions.fullUrl;
      ResponseModel responseModel =
          getSuccessResponseModelBlock(fullUrl, responseMap, false);
      // 此类不会走拦截器，也就不会有 headers 等信息
      // String responseLogString =
      //     FormatterUtil.convert(responseMap, 0, isObject: true);
      // DioLogInterceptor.logApi(apiInfo, ApiProcessType.response);

      return responseModel;
    } catch (e) {
      String message = '请求$apiPath的时候，发生网络错误,未设置json文件';
      if (e is NoSuchMethodError) {
        // do something
      }
      // String message = '请求$apiPath的时候，发生网络错误,未设置json文件${e.message}';
      String responseLogString = "Error:接口本地模拟发生错误:$message"; // 此类不会走拦截器

      // 此类不会走拦截器，也就不会有 headers 等信息
      // // DioLogUtil.logApi(apiPath, responseLogString, ApiProcessType.error, ApiLogLevel.error);

      ReqOptions reqOptions = ReqOptions(
        baseUrl: localApiHost,
        path: apiPath,
      );

      ErrOptions errOptions = ErrOptions(
        message: responseLogString,
        type: NetworkErrorType.other,
        requestOptions: reqOptions,
      );

      NetOptions apiInfo = NetOptions(
        reqOptions: reqOptions,
        errOptions: errOptions,
        getSuccessResponseModelBlock: getSuccessResponseModelBlock,
      );

      // DioLogInterceptor.logApi(apiInfo, ApiProcessType.error);

      return ResponseModel.tryCatchErrorResponseModel(message);
    }
  }
}
