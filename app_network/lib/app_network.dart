/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-13 14:18:49
 * @Description: 应用层的网络库(含正常请求+埋点请求)
 */
library app_network;

export 'package:dio/dio.dart' show CancelToken;
export 'package:flutter_network/flutter_network.dart'
    show ResponseModel, DioChangeUtil;

// url
export './url/app_url_path.dart';
export './url/wish_url_path.dart';

// 正常请求+埋点请求
export './src/app_network/app_network_manager.dart';
export './src/app_network/app_network_cache_manager.dart';
export './src/app_env_network_util.dart';
export './src/app_env_network_util_upload.dart';
export './src/app_response_model_util.dart';
export './src/app_api_simulate_util.dart';
