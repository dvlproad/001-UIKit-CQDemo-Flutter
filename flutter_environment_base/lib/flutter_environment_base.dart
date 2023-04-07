/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-25 00:37:56
 * @Description: 网络环境和代理环境库
 */
library flutter_environment_base;

// 网络环境 network
export 'src/network_page_data_manager.dart';
export 'src/network_page_data_bean.dart';
export 'src/environment_change_notifiter.dart';

// 平台环境
export 'src/data_target/packageType_page_data_manager.dart';
export 'src/data_target/packageType_page_data_bean.dart';

// 代理环境 proxy
export 'src/proxy_page_data_manager.dart';
export 'src/proxy_page_data_bean.dart';
export 'src/page/network_page_content.dart';
export 'src/page/proxy_page_content.dart';

// 数据模拟之apimock
export 'src/apimock/manager/api_manager.dart';
export 'src/apimock/manager/api_data_bean.dart';
export 'src/page/api_mock_page_content.dart';

export 'src/environment_util.dart';
export 'src/network_page_data_cache.dart';

export './darg/draggable_manager.dart';

// 设备信息(临时写在此库中)
export './src/device/device_info_util.dart';
export './src/device/device_info_page.dart';
