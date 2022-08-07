/*
 * @Author: dvlproad
 * @Date: 2022-04-27 16:50:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-21 17:55:06
 * @Description: 环境初始化类
 */
import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

import './packageType_env_util.dart';
import './packageType_page_data_manager.dart';
import './packageType_page_data_bean.dart';
import './environment_datas_util.dart';
import './main_diff_util.dart';

import '../env_page_util.dart';

class PackageTargetEnvUtil {
  /************************* environment 环境设置 *************************/
  static Future<Null> initPackageTargetManager(
    PackageType packageType,
    PackageTargetType packageTargetType,
  ) async {
    String defaultPackageTargetId_whenNull =
        packageTargetType.toString().split('.').last;

    bool canUseCachePackageTarget;
    if (packageType == PackageType.develop1) {
      canUseCachePackageTarget = true;
    } else if (packageType == PackageType.develop2) {
      canUseCachePackageTarget = true;
    } else if (packageType == PackageType.preproduct) {
      canUseCachePackageTarget = true;
    } else if (packageType == PackageType.product) {
      if (packageTargetType == PackageTargetType.pgyer) {
        canUseCachePackageTarget = true;
      } else {
        canUseCachePackageTarget = false;
      }
    } else {
      canUseCachePackageTarget = false;
    }

    List<PackageTargetModel> packageTargetModels_whenNull = [
      PackageTargetModel.pgyerTargetModel,
      PackageTargetModel.formalTargetModel,
    ];

    return PackageTargetPageDataManager()
        .initWithDefaultPackageTargetIdAndModels(
      packageTargetModels_whenNull: packageTargetModels_whenNull,
      defaultPackageTargetId_whenNull: defaultPackageTargetId_whenNull,
      canUseCachePackageTarget: canUseCachePackageTarget,
    );
  }

  static void changePackageTarget(
    PackageTargetModel packageTargetModel, {
    @required BuildContext context,
  }) {
    /// ①修改网络环境_页面数据
    PackageTargetPageDataManager()
        .updatePackageTargetPageSelectedData(packageTargetModel);

    /// ②修改网络环境_SDK数据

    /// ③修改网络环境_更改完数据后，是否退出应用
    EnvPageUtil.exitApp(context);
  }
}
