/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-15 23:58:40
 * @Description: 环境、设备信息相关的库
 */
library flutter_environment_kit;

export 'src/base_env_singleton.dart';

export 'package:flutter_environment_base/flutter_environment_base.dart';

// check and update
export './src/check_update/env_page_util.dart';
export './src/check_update/env_page.dart';
export './src/check_update/env_widget.dart';
export './src/check_update/package_check_update_network_util.dart';
export './src/check_update/package_check_update_target_util.dart';
export './src/check_update/package_check_update_proxy_util.dart';

// eventbus
export './src/eventbus/environment_eventbus.dart';
