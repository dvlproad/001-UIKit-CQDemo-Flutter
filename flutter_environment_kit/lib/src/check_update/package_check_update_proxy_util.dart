// ignore_for_file: unused_local_variable

/*
 * @Author: dvlproad
 * @Date: 2022-09-09 10:58:55
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-15 22:38:02
 * @Description: 
 */
import 'package:flutter/material.dart';

import 'package:flutter_environment_base/flutter_environment_base.dart';

import './env_page_util.dart';

class PackageCheckUpdateProxyUtil {
  /// 设置页点击添加代理的时候，检查包的环境
  static checkProxyAllowForPackage({
    void Function()?
        goChangeHandle, // 是否允许有进入添加代理的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  }) {
    TSEnvNetworkModel originNetworkModel =
        NetworkPageDataManager().originNetworkModel;

    if (goChangeHandle == null) {
      throw Exception('进入添加代理的操作不能为空，请检查');
    }

    BuildContext? currentContext = EnvPageUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }

    goChangeHandle();
  }
}
