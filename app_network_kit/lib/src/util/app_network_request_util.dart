import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import '../app_network/app_network_cache_manager.dart';
import '../app_network/app_network_manager.dart';
import '../monitor_network/monitor_network_manager.dart';

class AppNetworkRequestUtil {
  /// 通用的GET请求
  static Future<ResponseModel> get(
    String api, {
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return AppNetworkManager().get(
      api,
      customParams: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的POST请求(即使设置缓存，只要从缓存中取到了数据，那想要执行的正常请求会被跳过，不会执行)
  static Future<ResponseModel> post(
    String api, {
    Map<String, dynamic>? params,
    int retryCount = 0, // 轮询次数,最后一次不管成功与否都要返回
    Duration? retryDuration, // 轮询间隔
    bool Function(ResponseModel responseModel)?
        retryStopConditionConfigBlock, // 是否请求停止的判断条件(为空时候,默认请求成功即停止)
    bool withLoading = false,
    bool? showToastForNoNetwork,
  }) async {
    return AppNetworkManager().post(
      api,
      customParams: params,
      retryCount: retryCount,
      retryDuration: retryDuration,
      retryStopConditionConfigBlock: retryStopConditionConfigBlock,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
    );
  }

  /// 通用的GET、POST请求(如果设置缓存，可实现如果从缓存中取到数据，仍然能继续执行正常的请求)
  static void getWithCallback(
    String api, {
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkManager().requestWithCallback(
      api,
      requestMethod: RequestMethod.get,
      customParams: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  static void postWithCallback(
    String api, {
    Map<String, dynamic>? params,
    bool? ifNoAuthorizationForceGiveUpRequest, // 没有 Authorization 的时候是否强制放弃请求
    int retryCount = 0,
    withLoading = false,
    AppNetworkCacheLevel cacheLevel = AppNetworkCacheLevel.none,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkManager().requestWithCallback(
      api,
      requestMethod: RequestMethod.post,
      customParams: params,
      ifNoAuthorizationForceGiveUpRequest: ifNoAuthorizationForceGiveUpRequest,
      retryCount: retryCount,
      cacheLevel: cacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  /// 列表的请求(未设置会自动补上 pageNum pageSize 参数)
  static void postListWithCallback(
    String api, {
    required Map<String, dynamic> params,
    int retryCount = 0,
    AppListCacheLevel listCacheLevel = AppListCacheLevel.one,
    withLoading = false,
    bool? showToastForNoNetwork,
    required void Function(ResponseModel responseModel) completeCallBack,
  }) async {
    AppNetworkManager().postListWithCallback(
      api,
      customParams: params,
      retryCount: retryCount,
      listCacheLevel: listCacheLevel,
      withLoading: withLoading,
      showToastForNoNetwork: showToastForNoNetwork,
      completeCallBack: completeCallBack,
    );
  }

  //*
  static bool Function()? _loginStateGetBlock;
  static List<String>?
      _ignoreRequestApiIfLogout; // 如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断)

  /// 是否不请求(如果是未登录状态下，默认不请求(可省去外部加isLoginState()的判断))
  // ignore: unused_element
  static bool _shouldIgnoreRequest(String api) {
    if (_loginStateGetBlock != null &&
        _ignoreRequestApiIfLogout != null &&
        _ignoreRequestApiIfLogout!.isNotEmpty) {
      bool isLogin = _loginStateGetBlock!();
      if (isLogin == false) {
        String apiPath;
        int index = api.indexOf('/hapi/');

        if (index != -1) {
          apiPath = api.substring(index + '/hapi'.length);
        } else {
          apiPath = api;
        }
        if (_ignoreRequestApiIfLogout!.contains(apiPath)) {
          return true;
        } else {
          return false;
        }
      } else {
        return true;
      }
    } else {
      return false;
    }
  }
  //*/

  ////////// ----------------- 埋点请求 ----------------- //////////

  static Future<ResponseModel> postMonitorMessage(
    String messageParam,
  ) async {
    String api = '/bi/sendMessage';

    Map<String, dynamic> customParams = {
      // "DataHubId": "datahub-y32g29n6", // 已添加到 commonParams 中
      // "Message": "[{\"Key\":\"\",\"Body\":{\"lib\":\"MiniProgram_app\"}},{\"Body\":{\"lib\":\"MiniProgram_app\"}}]",
      "Message": messageParam,
    };

    return MonitorNetworkManager().mock_requestUrl(
      api,
      requestMethod: RequestMethod.post,
      customParams: customParams,
      withLoading: false,
      showToastForNoNetwork: false,
    );
  }

  static Future<bool> isNetWorkAvailable({bool needShowToast = true}) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      if (needShowToast) {
        ToastUtil.showMessage('网络开小差了，请检查下网络再试！');
      }
      return false;
    } else {
      return true;
    }
  }

  /*
  List<String>? _getHeaderAuthorizationWhiteList() async {
    return [
      "config/biz-config",
      "config/home",
      "config/getResources",

      "login/device-config", //获取活动落地页

      "login/loginOut", //退出登录
      "login/doLogin", //用户一键登录
      "login/checkAuthorizationAccount", //获取当前微信登录用户是否存在手机号
      "user/account/getTelCaptcha", //用户发送验证码
      "user/account/get_city", //获取全国地址
      // 以上是自己整的
    ];

    // 以下是后台给的
    List<String>? headerAuthorizationWhiteList;
    try {
      // import 'package:flutter/services.dart'; // 用于使用 rootBundle
      //var value = await rootBundle.loadString("assets/data/app_info.json");
      var value = await rootBundle
          .loadString("packages/app_network/assets/data/whitelist.json");
      if (value != null) {
        Map<String, dynamic> data =
            json.decode(value); // import 'dart:convert'; // 用于使用json.decode

        List<String>? monitorHeaderAuthorizationWhiteList =
            data['monitor_white_list'];
        if (monitorHeaderAuthorizationWhiteList != null) {
          headerAuthorizationWhiteList ??= [];
          headerAuthorizationWhiteList.add(monitorHeaderAuthorizationWhiteList);
        }
        List<String>? appHeaderAuthorizationWhiteList = data['app_white_list'];
        if (monitorHeaderAuthorizationWhiteList != null) {
          headerAuthorizationWhiteList ??= [];
          headerAuthorizationWhiteList.add(appHeaderAuthorizationWhiteList);
        }

        return headerAuthorizationWhiteList;
      }
    } catch (e) {
      if (_isDebug() == false) {
        print('whitelist.json文件内容获取失败,可能未存在或解析过程出错');
      }
    }
  }
  */
}
