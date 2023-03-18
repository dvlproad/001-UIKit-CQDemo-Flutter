/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-16 18:17:59
 * @Description: 应用层的网络更新管理库
 */
library app_updateversion_kit;

// common
export 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show BranchPackageInfo, UpdateAppType;
// app
export './src/check_version_util.dart';
export './src/widget/app_download_widget.dart';

// mock
export './src/mock/mock_new_version_page.dart';
