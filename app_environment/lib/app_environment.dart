/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 17:32:35
 * @Description: app环境、设备信息相关的库
 */
library app_environment;

export './src/env_manager_util.dart';

export 'package:flutter_environment_base/flutter_environment_base.dart';

export './src/init/environment_datas_util.dart';
export './src/env_extension_bean.dart';
export 'src/app_env_config.dart';

// check and update
export './src/check_update/env_page_util.dart';
export './src/check_update/env_page.dart';
export './src/check_update/env_widget.dart';
export './src/check_update/package_check_update_network_util.dart';
export './src/check_update/package_check_update_target_util.dart';
export './src/check_update/package_check_update_proxy_util.dart';

// eventbus
export './src/eventbus/environment_eventbus.dart';

export 'src/keys/app_env_keys.dart';
