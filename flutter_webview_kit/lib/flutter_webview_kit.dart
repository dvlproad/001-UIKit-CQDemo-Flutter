/*
 * @Author: dvlproad
 * @Date: 2023-04-07 14:58:44
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-05-10 13:49:23
 * @Description: 
 */
library flutter_webview_kit;

export 'package:webview_flutter/webview_flutter.dart';

// user-agent
export './src/user_agent/webview_controller_user_agent_extension.dart';

// js: add check run
export './src/js_add_check_run/webview_controller_add_check_run_js.dart';
export './src/js_add_check_run/h5_call_bridge_response_model.dart'; // (调用 cj2_addJavaScriptChannel 进行自定义的 js 添加时候需要使用到)
// js: h5_call_app
export './src/js/webview_controller_js_base_extension.dart';
export './src/js/base/webview_controller_js_share_extension.dart';
export './src/js/base/webview_controller_js_cache_extension.dart';
// js: app_call_h5
export './src/js_app_call_h5/webview_controller_js_app_call_h5_extension.dart';

// webview: error / reshow
export './src/web_error_or_reshow/webview_controller_web_error_reshow_extension.dart';
