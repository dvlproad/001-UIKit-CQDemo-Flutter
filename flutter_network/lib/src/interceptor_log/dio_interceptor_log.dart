/*
 * @Author: dvlproad
 * @Date: 2022-04-28 13:07:39
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-03 16:50:22
 * @Description: log日志的处理类
 */
import 'package:dio/dio.dart';
import 'package:meta/meta.dart';
import '../network_bean.dart'
    show
        CJNetworkClientGetSuccessResponseModelBlock,
        CJNetworkClientGetFailureResponseModelBlock;
// manager
import './manager/log_pool_manager.dart';
// bean
import '../bean/net_options.dart';
import '../bean/err_options.dart';
import '../bean/req_options.dart';
import '../bean/res_options.dart';
// util
import '../bean/net_options_convert_util.dart';

import '../log/dio_log_util.dart';

class DioLogInterceptor implements Interceptor {
  LogPoolManager logManage = LogPoolManager.getInstance();

  late CJNetworkClientGetSuccessResponseModelBlock
      _getSuccessResponseModelBlock;
  // 打印请求各阶段出现的不同等级的日志信息
  // apiInfo: api信息
  // apiProcessType: api 请求的阶段类型
  late void Function(NetOptions apiInfo, ApiProcessType apiProcessType)
      _logApiInfoAction;
  DioLogInterceptor({
    required CJNetworkClientGetSuccessResponseModelBlock
        getSuccessResponseModelBlock,
    required void Function(NetOptions apiInfo, ApiProcessType apiProcessType)
        logApiInfoAction,
  }) {
    logManage = LogPoolManager.getInstance();
    _getSuccessResponseModelBlock = getSuccessResponseModelBlock;

    if (logApiInfoAction == null) {
      throw Exception(
          "Error：网络api日志输出接口未定义，请先调用 DioLogUtil.initDioLogUtil 来实现");
    }
    _logApiInfoAction = logApiInfoAction;
  }

  /// 请求体数据采集
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ReqOptions reqOpt = NetworkModelConvertUtil.newRequestOptions(options);
    logManage.onRequest(
      reqOpt,
      getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
      completeBlock: (NetOptions apiInfo) {
        _logApiInfoAction(apiInfo, ApiProcessType.request);
      },
    );

    return handler.next(options);
  }

  /// 错误数据采集
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    ErrOptions errOptions = NetworkModelConvertUtil.newError(err);
    logManage.onError(
      errOptions,
      getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
      completeBlock: (NetOptions apiInfo) {
        _logApiInfoAction(apiInfo, ApiProcessType.error);
      },
    );
    /*
    if (errOptions.response != null) {
      logManage.onResponse(
        errOptions.response!,
        getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
        completeBlock: (NetOptions apiInfo) {
          _logApiInfoAction(apiInfo, ApiProcessType.error); // 这里应该采用 ApiProcessType.error,前面却没设置 errOptions,会导致出错
        },
      );
    }
    */

    return handler.next(err);
  }

  /// 响应体数据采集
  @override
  Future onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    ResOptions newResponse = NetworkModelConvertUtil.newResponse(response);
    logManage.onResponse(
      newResponse,
      getSuccessResponseModelBlock: _getSuccessResponseModelBlock,
      completeBlock: (NetOptions apiInfo) {
        _logApiInfoAction(apiInfo, ApiProcessType.response);
      },
    );

    return handler.next(response);
  }
}
