/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 23:01:15
 * @Description: 应用层的网络库(含正常请求+埋点请求)
 */
library app_network;

export 'package:dio/dio.dart' show CancelToken;
export 'package:flutter_network_base/flutter_network_base.dart'
    show ResponseModel, DioChangeUtil;

// url
export './url/app_url_path.dart';
export './url/wish_url_path.dart';

// 正常请求+埋点请求
export './src/app_network/app_network_manager.dart';
export './src/app_network/app_network_cache_manager.dart';
export './src/app_response_model_util.dart';
export './src/app_api_simulate_util.dart';
// future
export './src/app_env_network_util.dart';
// callback
export './src/app_network_callback_util.dart';

// upload
export './src/app_upload_util.dart';
export './src/upload/app_upload_bean.dart';
export 'package:flutter_image_process/flutter_image_process.dart'
    show UploadMediaType;

// params helper
export './src/dev_common_params.dart';

export './src/trace/trace_util.dart';
