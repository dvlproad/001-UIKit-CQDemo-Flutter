/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-09 10:30:59
 * @Description: 网络库
 */
library flutter_network_kit;

export 'package:dio/dio.dart'
    show Dio, DioError, BaseOptions, Options, CancelToken;
export 'package:flutter_network/flutter_network.dart'
    show
        RequestMethod,
        ResponseModel,
        HttpStatusCode,
        NetworkUtil,
        NetOptions,
        ErrOptions,
        NetworkErrorType;

export './src/error_response_model_util.dart';

export './src/base/cache_network_client.dart';
export './src/cache/cache_helper.dart' show CacheHelper, NetworkCacheLevel;

export './src/log/util/api_post_util.dart';
export './src/log/bean/apihost_robot_bean.dart';

export './src/log/api_log_util.dart';
export 'package:flutter_log/flutter_log.dart' show LogLevel;

// network status
export './src/networkStatus/network_eventbus.dart';
export './src/networkStatus/network_status_manager.dart';
