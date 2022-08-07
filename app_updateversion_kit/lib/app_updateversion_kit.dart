/*
 * @Author: dvlproad
 * @Date: 2022-07-13 11:30:08
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-08 00:18:48
 * @Description: 应用层的网络更新管理库
 */
library app_updateversion_kit;

// common
export 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart'
    show BranchPackageInfo, UpdateAppType;
// pgyer
export 'package:pgyer_updateversion_kit/pgyer_updateversion_kit.dart';
// app
export './src/check_version_util.dart';
export './src/widget/app_download_widget.dart';
