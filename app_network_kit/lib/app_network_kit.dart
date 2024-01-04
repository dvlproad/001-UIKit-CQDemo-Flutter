/*
 * @Author: dvlproad
 * @Date: 2022-05-18 15:06:49
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 16:55:45
 * @Description: 应用层的网络库(含正常请求+埋点请求)
 */
library app_network_kit;

export 'package:dio/dio.dart' show CancelToken;
export 'package:flutter_network_base/flutter_network_base.dart'
    show ResponseModel, ResponseDateModel, DioChangeUtil;

// 正常请求+埋点请求
export './src/app_network/app_network_manager.dart';
export './src/app_network/app_network_cache_manager.dart';
export './src/monitor_network/monitor_network_manager.dart';
export './src/app_response_model_util.dart';
export './src/sm_network/sm_network_manager.dart';
export './src/td_network/td_network_manager.dart';
// util
export './src/util/app_network_init_util.dart';
export './src/util/app_network_change_util.dart';
export './src/util/app_network_request_util.dart';

// callback
export './src/app_network_callback_util.dart';

// upload
export './src/util/app_network_upload_util.dart';
export './src/upload/app_upload_bean.dart';
export 'package:flutter_image_process/flutter_image_process.dart'
    show UploadMediaType;

// params helper
export './src/dev_common_params.dart';

export './src/trace/trace_util.dart';

// mock
export './src/mock/app_api_mock_manager.dart';
