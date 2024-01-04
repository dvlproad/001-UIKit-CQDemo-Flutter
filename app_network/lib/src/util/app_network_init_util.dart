import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:flutter_foundation_base/flutter_foundation_base.dart';
import 'package:flutter_network_kit/flutter_network_kit.dart';
import 'package:flutter_log_with_env/flutter_log_with_env.dart';

import '../app_network/app_network_manager.dart';
import '../monitor_network/monitor_network_manager.dart';
import '../sm_network/sm_network_manager.dart';
import '../td_network/td_network_manager.dart';
import '../dev_common_params.dart';

import './app_network_change_util.dart';
import '../app_response_model_util.dart';

class AppNetworkInitUtil {
  static Future<void> start({
    required TSEnvNetworkModel selectedNetworkModel,
    required PackageTargetModel selectedTargetModel,
    required TSEnvProxyModel selectedProxyModel,
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    String? token,
    required String channelName,
    required void Function(ResponseModel responseModel) needReloginHandle, // 401等需要重新登录时候，执行的操作
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
    // 应用层信息的获取
    required String Function() uidGetBlock,
    required String Function() accountIdGetBlock,
    required String Function() nicknameGetBlock,
    void Function(String localPath, bool multipart)?
        assetUploadMonitorHandle, // 待上传资源文件的埋点
  }) async {
    _start(
      appFeatureType: selectedTargetModel.envId,
      baseUrl: selectedNetworkModel.apiHost,
      monitorBaseUrl: selectedNetworkModel.monitorApiHost,
      token: token,
      channelName: channelName,
      mockApiHost: mockApiHost,
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
      uidGetBlock: uidGetBlock,
      accountIdGetBlock: accountIdGetBlock,
      nicknameGetBlock: nicknameGetBlock,
      assetUploadMonitorHandle: assetUploadMonitorHandle,
    );

    // proxy:
    AppNetworkChangeUtil.changeProxy(selectedProxyModel.proxyIp);
  }

  static void _start({
    required String appFeatureType,
    required String baseUrl, // 正常请求的 baseUrl
    required String monitorBaseUrl, // 埋点请求的 baseUrl
    String? token,
    required void Function(ResponseModel responseModel) needReloginHandle, // 401等需要重新登录时候，执行的操作
    List<int>? Function()?
        forceNoToastStatusCodesGetFunction, // 获取哪些真正的statusCode药强制不弹 toast
    String? mockApiHost, // 允许 mock api 的情况下，mock 到哪个地址
    // 应用层信息的获取
    required String Function() uidGetBlock,
    required String Function() accountIdGetBlock,
    required String Function() nicknameGetBlock,
    required String channelName,
    void Function(String localPath, bool multipart)?
        assetUploadMonitorHandle, // 待上传资源文件的埋点
  }) async {
    AppLogUtil.logMessage(
      logType: LogObjectType.sdk_other,
      logLevel: LogLevel.normal,
      shortMap: {
        "message": '初始化网络库开始',
      },
      detailMap: {
        "message": '初始化网络库开始',
      },
    );
    NetworkStatusManager(); // 提前开始获取网络类型环境

    Map<String, dynamic> commonHeaderParams =
        await CommonParamsHelper.commonHeaderParams(
      appFeatureType: appFeatureType,
      channel: channelName,
    );
    bool allowMock = true;

    CheckResponseModelUtil.init(
      needReloginHandle: needReloginHandle,
      forceNoToastStatusCodesGetFunction: forceNoToastStatusCodesGetFunction,
    );

    Map<String, dynamic> apiCommonBodyParams = {};
    AppNetworkManager().start(
      baseUrl: baseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerAuthorization: token,
      // headerAuthorizationWhiteList: await _getHeaderAuthorizationWhiteList(),
      bodyCommonFixParams: apiCommonBodyParams,
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      uidGetBlock: uidGetBlock,
      accountIdGetBlock: accountIdGetBlock,
      nicknameGetBlock: nicknameGetBlock,
      startCompleteBlock: () {
        AppLogUtil.logMessage(
          logType: LogObjectType.sdk_other,
          logLevel: LogLevel.normal,
          shortMap: {
            "message": '初始化网络库完成：业务网络库',
          },
          detailMap: {
            "message": '初始化网络库完成：业务网络库',
          },
        );
      },
      assetUploadMonitorHandle: assetUploadMonitorHandle,
    );

    Map<String, dynamic> monitorPublicParamsMap =
        await CommonParamsHelper.monitor_bodyCommonFixedParams(
      channel: channelName,
    );
    String monitorPublicParamsString =
        FormatterUtil.convert(monitorPublicParamsMap, 0);
    Map<String, dynamic> monitorCommonBodyParams = {
      "Public": monitorPublicParamsString,
    };
    MonitorNetworkManager().normal_start(
      baseUrl: monitorBaseUrl,
      headerCommonFixParams: commonHeaderParams,
      headerAuthorization: token,
      bodyCommonFixParams: monitorCommonBodyParams,
      bodyCommonChangeParamsGetBlock: () {
        String monitorDataHubId =
            NetworkPageDataManager().selectedNetworkModel.monitorDataHubId;
        return {
          "DataHubId": monitorDataHubId,
        };
      },
      allowMock: allowMock,
      mockApiHost: mockApiHost,
      localApiDirBlock: (apiPath) {
        return "asset/data";
      },
      startCompleteBlock: () {
        AppLogUtil.logMessage(
          logType: LogObjectType.sdk_other,
          logLevel: LogLevel.normal,
          shortMap: {
            "message": '初始化网络库完成：埋点网络库',
          },
          detailMap: {
            "message": '初始化网络库完成：埋点网络库',
          },
        );
      },
    );

    SMNetworkManager().normal_start(
      baseUrl: "",
      headerCommonFixParams: {},
      headerAuthorization: token,
      bodyCommonFixParams: {},
      // bodyCommonChangeParamsGetBlock: () {
      //   String monitorDataHubId =
      //       NetworkPageDataManager().selectedNetworkModel.monitorDataHubId;
      //   return {
      //     "DataHubId": monitorDataHubId,
      //   };
      // },
      // allowMock: allowMock,
      // mockApiHost: mockApiHost,
      localApiDirBlock: (apiPath) {
        return "asset/data";
      },
      startCompleteBlock: () {
        AppLogUtil.logMessage(
          logType: LogObjectType.sdk_other,
          logLevel: LogLevel.normal,
          shortMap: {
            "message": '初始化网络库完成：数美网络库',
          },
          detailMap: {
            "message": '初始化网络库完成：数美网络库',
          },
        );
      },
    );

    TDNetworkManager().normal_start(
      baseUrl: "",
      headerCommonFixParams: {},
      headerAuthorization: token,
      bodyCommonFixParams: {},
      // bodyCommonChangeParamsGetBlock: () {
      //   String monitorDataHubId =
      //       NetworkPageDataManager().selectedNetworkModel.monitorDataHubId;
      //   return {
      //     "DataHubId": monitorDataHubId,
      //   };
      // },
      // allowMock: allowMock,
      // mockApiHost: mockApiHost,
      localApiDirBlock: (apiPath) {
        return "asset/data";
      },
      startCompleteBlock: () {
        AppLogUtil.logMessage(
          logType: LogObjectType.sdk_other,
          logLevel: LogLevel.normal,
          shortMap: {
            "message": '初始化网络库完成：同盾网络库',
          },
          detailMap: {
            "message": '初始化网络库完成：同盾网络库',
          },
        );
      },
    );

    if (allowMock == true && mockApiHost != null) {
      // 允许 mock api 的情况下，要 mock 到的地址 mockApiHost 不能为空
      ApiManager().setup(
        allowMock: allowMock,
        mockApiHost: mockApiHost,
      );
    }
  }
}
