/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 18:28:29
 * @Description: app环境、设备信息相关的库
 */
library app_environment;

export './src/env_manager_util.dart';
export './src/env_page_util.dart';
export './src/env_page.dart';
export './src/env_widget.dart';

export './src/init/main_diff_util.dart'
    show MainDiffUtil, DiffPackageBean, PackageTargetType;
export './src/init/package_environment_util.dart' show PackageEnvironmentUtil;

export 'package:flutter_environment/flutter_environment.dart'
    show DeviceInfoPage, PackageType;

export './src/init/packageType_page_data_manager.dart';
export './src/init/packageType_page_data_bean.dart';
export './src/init/packageType_env_util.dart';
