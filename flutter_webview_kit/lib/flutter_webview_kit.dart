/*
 * @Author: dvlproad
 * @Date: 2023-04-07 14:58:44
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-04-30 12:12:30
 * @Description: 
 */
library flutter_webview_kit;

export 'package:webview_flutter/webview_flutter.dart';

// js: add check run
export './src/js_add_check_run/webview_controller_add_check_run_js.dart';

// js: h5_call_app
export './src/js/webview_controller_js_base_extension.dart';

// js: app_call_h5
export './src/js/app_call_h5/webview_controller_js_app_call_h5_extension.dart';

// webview: error / reshow
export './src/web_error_or_reshow/webview_controller_web_error_reshow_extension.dart';