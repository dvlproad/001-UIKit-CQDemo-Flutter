// ignore_for_file: constant_identifier_names, unnecessary_string_interpolations

/*
 * @Author: dvlproad
 * @Date: 2022-06-01 15:54:52
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 11:50:20
 * @Description: 正常请求管理中心+埋点请求管理中心
 */
import 'dart:convert' as convert;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:flutter_image_process/flutter_image_process.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base/mock_network_manager.dart';
import '../app_response_model_util.dart';
import '../mock/mock_analy_util.dart';
import '../trace/trace_util.dart';

class AppNetworkManager extends MockNetworkManager {
  static const int CONNECT_TIMEOUT = 3000;
  static const int RECEIVE_TIMEOUT = 5000; // 会影响发视频这种大数据吗

  // 单例
  factory AppNetworkManager() => _getInstance();
  static AppNetworkManager get instance => _getInstance();
  static AppNetworkManager? _instance;
  static AppNetworkManager _getInstance() {
    _instance ??= AppNetworkManager._internal();
    return _instance!;
  }

  AppNetworkManager._internal() {
    //debugPrint('这个单例里的初始化方法只会执行一次');

    _init();
  }

  final uploadIdChannel = const MethodChannel("multipart.uploadId");

  _init() {
    if (dio == null) {
      BaseOptions options = BaseOptions(
        connectTimeout: CONNECT_TIMEOUT,
        receiveTimeout: RECEIVE_TIMEOUT,
        contentType: "application/json",
      );
      dio = Dio(options);

      normal_setup(
        getSuccessResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseMap, bool? isFromCache) {
          return _getResponseModel(
            fullUrl: fullUrl,
            statusCode: 200,
            responseData: responseMap,
            isResponseFromCache: isFromCache,
          );
        },
        getFailureResponseModelBlock: (String fullUrl, int statusCode,
            dynamic responseObject, bool? isCacheData) {
          String errorMessage = '后端接口出现异常';
          String message = '请求$fullUrl的时候，发生网络错误:$errorMessage';
          ResponseModel responseModel = ResponseModel(
            statusCode: statusCode,
            message: message,
            result: null,
            isCache: isCacheData,
          );

          return responseModel;
        },
        getDioErrorResponseModelBlock:
            (String url, ErrOptions errorModel, bool? isCacheData) {
          return ErrorResponseUtil.getErrorResponseModel(
            url,
            errorModel,
            isCacheData,
          );
        },
        checkResponseModelHandel: (ResponseModel responseModel,
            {bool? toastIfMayNeed}) {
          return CheckResponseModelUtil.checkResponseModel(
            responseModel,
            toastIfMayNeed: toastIfMayNeed,
            serviceProxyIp: serviceValidProxyIp,
          );
        },
      );
    }

    uploadIdChannel.setMethodCallHandler((call) async {
      final preferences = await SharedPreferences.getInstance();
      final uploadIdStr = preferences.getString("multipart.uploadId") ?? "{}";
      final Map map = json.decode(uploadIdStr);
      final path = call.arguments["filePath"] as String;
      final uploadId = call.arguments["uploadId"] as String;
      final cos = call.arguments["cos"] as String;
      String key = path.split("/").last;
      switch (call.method) {
        case "save":
          {
            map[key] = uploadId;
            map["cos_$key"] = cos;
            preferences.setString("multipart.uploadId", json.encode(map));
            return Future(() => "成功");
          }
        case "complete":
          {
            map.remove(key);
            map.remove("cos_$key");
            map["complete$key"] = true;
            map["complete_cos$key"] = cos;
            preferences.setString("multipart.uploadId", json.encode(map));
            return Future(() => "成功");
          }
      }
      return null;
    });
  }

  // late String Function() uidGetFunction;

  late String Function(UploadMediaType mediaType) bucketGetFunction;
  late String Function() regionGetFunction;
  late String Function() cosFilePrefixGetFunction;
  late String Function(
    String localPath, {
    UploadMediaType mediaType,
  }) cosFileRelativePathGetFunction;
  late String Function(UploadMediaType mediaType)
      cosFileUrlPrefixGetFunction; // cos文件的网络地址前缀

  void start({
    required String baseUrl,
    String?
        contentType, // "application/json""application/x-www-form-urlencoded"
    required Map<String, dynamic> headerCommonFixParams, // header 中公共但不变的参数
    String? headerAuthorization,
    List<String>?
        headerAuthorizationWhiteList, // 请求时候，检查到当前headerAuthorization为空,可继续请求的白名单
    required Map<String, dynamic> bodyCommonFixParams, // body 中公共但不变的参数
    bool allowMock = false, // 是否允许 mock api
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    // 应用层信息的获取
    required String Function() uidGetBlock,
  }) {
    // uidGetFunction = uidGetBlock;
    regionGetFunction = () {
      TSEnvNetworkModel currentNetworkModel =
          NetworkPageDataManager().selectedNetworkModel;
      return currentNetworkModel.cosParamModel.region;
    };

    bucketGetFunction = (UploadMediaType mediaType) {
      String bucket = "";
      // 环境
      TSEnvNetworkModel currentNetworkModel =
          NetworkPageDataManager().selectedNetworkModel;
      if (mediaType == UploadMediaType.image) {
        bucket = currentNetworkModel.cosParamModel.bucket_image;
      } else {
        bucket = currentNetworkModel.cosParamModel.bucket_other;
      }

      return bucket;
    };

    // String Function() regionGetFunction;
    cosFilePrefixGetFunction = () {
      TSEnvNetworkModel currentNetworkModel =
          NetworkPageDataManager().selectedNetworkModel;
      return currentNetworkModel.cosParamModel.cosFilePrefix;
    };
    cosFileRelativePathGetFunction = (
      String localPath, {
      UploadMediaType mediaType = UploadMediaType.unkonw,
    }) {
      String uid = uidGetBlock();

      String fileOriginNameAndExtensionType = localPath.split('/').last;

      // String str = " Hello Word! ";
      RegExp regExp = RegExp(r"\s+\b|\b\s"); // 去除字符串中的所有空格
      fileOriginNameAndExtensionType =
          fileOriginNameAndExtensionType.replaceAll(regExp, "");

      /*
      String fileExtensionType = fileOriginNameAndExtensionType.split('.').last;
      String fileOriginName = fileOriginNameAndExtensionType.substring(
          0, fileOriginNameAndExtensionType.length - fileExtensionType.length);
      fileOriginNameAndExtensionType = 'test.$fileExtensionType';
      */

      int nowTime = DateTime.now().microsecondsSinceEpoch;
      String cosFileName = "${nowTime.toString()}";
      cosFileName += "_$fileOriginNameAndExtensionType";

      // 头
      String cosPath = cosFilePrefixGetFunction();

      // 类别
      if (mediaType == UploadMediaType.image) {
        // 图片有自己的桶
      } else {
        // 视频、音频共用一个桶，需要再区分
        if (mediaType == UploadMediaType.audio) {
          cosPath += "/audio";
        } else if (mediaType == UploadMediaType.video) {
          cosPath += "/video";
        } else {
          cosPath += "/other";
        }
      }

      // 用户1级
      int uidMode = int.parse(uid) % 1000; // 取余数
      cosPath += "/$uidMode";
      // 用户2级
      cosPath += "/$uid";

      // 年月
      String dirTime = DateTime.now().toString().substring(0, 7);
      cosPath += "/$dirTime";

      // 文件名
      cosPath += "/$cosFileName";

      return cosPath;
    };
    cosFileUrlPrefixGetFunction = (UploadMediaType mediaType) {
      TSEnvNetworkModel currentNetworkModel =
          NetworkPageDataManager().selectedNetworkModel;
      if (mediaType == UploadMediaType.image) {
        return currentNetworkModel.cosParamModel.cosFileUrlPrefix_image;
      } else if (mediaType == UploadMediaType.video) {
        return currentNetworkModel.cosParamModel.cosFileUrlPrefix_video;
      } else if (mediaType == UploadMediaType.audio) {
        return currentNetworkModel.cosParamModel.cosFileUrlPrefix_audio;
      } else {
        return currentNetworkModel.cosParamModel.cosFileUrlPrefix_image;
      }
    };

    cache_start(
      baseUrl: baseUrl,
      contentType: contentType,
      headerCommonFixParams: headerCommonFixParams,
      headerCommonChangeParamsGetBlock: () {
        return {
          'trace_id': TraceUtil.traceId(),
        };
      },
      headerAuthorization: headerAuthorization,
      headerAuthorizationWhiteList: headerAuthorizationWhiteList,
      bodyCommonFixParams: bodyCommonFixParams,
      // bodyCommonChangeParamsGetBlock: () {
      //   return {
      //     'trace_id': TraceUtil.traceId(),
      //   };
      // },
      commonIgnoreKeysForCache: ['trace_id', 'retryCount'],
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      localApiDirBlock: (String apiPath) {
        return "asset/data";
      },
    );
  }

  ResponseModel _getResponseModel({
    required String fullUrl, // 用来判断是否是模拟的环境
    required int statusCode,
    dynamic responseData,
    bool? isResponseFromCache,
  }) {
    if (responseData == null) {
      ResponseModel responseModel = ResponseModel(
        statusCode: -1,
        message: "responseData == null",
        result: null,
        isCache: isResponseFromCache,
      );
      return responseModel;
    }

    if (responseData is String && (responseData).isEmpty) {
      // 后台把data按字符串返回的时候
      String responseDataString = "''"; // 空字符串
      String errorMessage =
          "Error:请求$fullUrl后台response用字符串返回,且值为$responseDataString,该字符串却无法转成标准的由code+msg+result组成的map结构(目前发现于503时候)";
      ResponseModel responseModel = ResponseModel(
        statusCode: statusCode,
        // message: response.m,
        result: {
          "code": -1001,
          "msg": errorMessage,
        },
        isCache: isResponseFromCache,
      );
      return responseModel;
    }

    dynamic responseObject;
    if (responseData is String) {
      // 后台把data按字符串返回的时候
      responseObject = convert.jsonDecode(responseData);
    } else {
      //String dataString = responseData.toString();
      String dataJsonString = convert.jsonEncode(responseData);
      responseObject = convert.jsonDecode(dataJsonString);
    }

    // Uri uri = response.requestOptions.uri;
    // String url = uri.toString();

    Map<String, dynamic> responseMap;

    EnvironmentMockType envMockType = MockAnalyUtil.envMockType(fullUrl);
    if (envMockType == EnvironmentMockType.mockWish) {
      // 是模拟的环境，不是本项目
      responseMap = MockAnalyUtil.responseMapFromMock(responseObject, fullUrl);
    } else {
      responseMap = responseObject;
    }

    // int businessCode = responseObject["code"];
    // String message = responseObject["msg"];
    // dynamic result = responseObject['data'];
    // ResponseModel responseModel = ResponseModel(
    //   statusCode: businessCode,
    //   message: message,
    //   result: result,
    //   isCache: isResponseFromCache,
    // );

    var errorCode = responseMap['code'];
    var msg = responseMap['msg'];
    dynamic result = responseMap['data'];
    ResponseModel responseModel = ResponseModel(
      statusCode: errorCode,
      message: msg,
      result: result,
      isCache: isResponseFromCache,
    );

    return responseModel;
  }
}
