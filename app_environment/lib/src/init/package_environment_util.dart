import 'package:flutter/material.dart';

import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import '../dev_util.dart';

import './environment_datas_util.dart';
import './main_diff_util.dart';

class PackageEnvironmentUtil {
  // 启动时候，检查当前包的当前网络环境和默认的网络环境是否一样，如果不一样，提示切回默认的环境，避免用户使用不存在或者过期或者未上线的功能
  static checkShouldResetNetwork({
    void Function()
        goChangeHandle, // 是否允许有进入切换环境的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  }) {
    // 获取当前网络环境id
    TSEnvNetworkModel currentEnvNetworkModel =
        NetworkPageDataManager.instance.selectedNetworkModel;

    // 获取当前包应该的默认网络环境
    DiffPackageBean packageBean = MainDiffUtil.diffPackageBean();
    TSEnvNetworkModel defaultNetworkModel =
        _packageDefaultNetworkModel(packageBean);

    // 检查当前包的当前网络环境和默认的网络环境是否一样，如果不一样，提示切回默认的环境
    if (goChangeHandle == null) {
      // 启动时候
      _checkNetworkWhenStartForPackage(
        packageBean,
        defaultNetworkModel,
        currentEnvNetworkModel,
      );
    } else {
      // 设置界面里
      _checkNetworkNoStartForPackage(
        packageBean,
        defaultNetworkModel,
        currentEnvNetworkModel,
        goChangeHandle,
      );
    }
  }

  static TSEnvNetworkModel _packageDefaultNetworkModel(
      DiffPackageBean packageBean) {
    TSEnvNetworkModel defaultNetworkModel;

    PackageType packageType = packageBean.packageType;
    if (packageType == PackageType.develop1) {
      defaultNetworkModel = TSEnvironmentDataUtil.networkModel_dev1;
    } else if (packageType == PackageType.develop2) {
      defaultNetworkModel = TSEnvironmentDataUtil.networkModel_dev2;
    } else if (packageType == PackageType.preproduct) {
      defaultNetworkModel = TSEnvironmentDataUtil.networkModel_preProduct;
    } else {
      defaultNetworkModel = TSEnvironmentDataUtil.networkModel_product;
    }

    return defaultNetworkModel;
  }

  /// 启动时候检查包的环境
  static _checkNetworkWhenStartForPackage(
    DiffPackageBean packageBean,
    TSEnvNetworkModel defaultNetworkModel,
    TSEnvNetworkModel currentEnvNetworkModel,
  ) {
    BuildContext currentContext = EnvUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }

    String defaultEnvId = defaultNetworkModel.envId;

    String currentEnvId = currentEnvNetworkModel.envId;

    if (currentEnvId != defaultEnvId) {
      String title = '是否恢复默认的【${defaultNetworkModel.name}】';
      String message =
          '您当前${packageBean.des}不是默认环境，而是[${currentEnvNetworkModel.name}]，建议切回默认，以免影响使用！';
      AlertUtil.showCancelOKAlert(
        context: currentContext,
        title: title,
        message: message,
        cancelTitle: '继续${currentEnvNetworkModel.shortName}',
        okTitle: '恢复${defaultNetworkModel.shortName}',
        okHandle: () {
          _reset(defaultNetworkModel, context: currentContext);
        },
      );
    }
  }

  static _reset(TSEnvNetworkModel defaultNetworkModel, {BuildContext context}) {
    EnvUtil.changeEnv(defaultNetworkModel, true, context: context);
    EnvUtil.changeProxyToNone();
  }

  /// 设置页点击切换环境的时候，检查包的环境
  static _checkNetworkNoStartForPackage(
    DiffPackageBean packageBean,
    TSEnvNetworkModel defaultNetworkModel,
    TSEnvNetworkModel currentEnvNetworkModel,
    void Function()
        goChangeHandle, // 是否允许有进入切换环境的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  ) {
    if (goChangeHandle == null) {
      throw Exception('进入切换环境的操作不能为空，请检查');
    }

    BuildContext currentContext = EnvUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }

    if (packageBean.packageType == PackageType.product) {
      ToastUtil.showMsg(
          '温馨提示：您当前包为${packageBean.des}，不支持切换环境。', currentContext);
      return;
    }

    String defaultEnvId = defaultNetworkModel.envId;

    String currentEnvId = currentEnvNetworkModel.envId;

    String title;
    String message;
    List<String> buttonTitles = [];
    buttonTitles.add('继续${currentEnvNetworkModel.shortName}');
    buttonTitles.add('其他');
    if (currentEnvId != defaultEnvId) {
      title = '是否恢复默认的【${defaultNetworkModel.name}】';
      message =
          '您当前${packageBean.des}不是默认环境，而是[${currentEnvNetworkModel.name}]，建议切回默认，以免影响使用！';
      buttonTitles.add('恢复${defaultNetworkModel.shortName}');
    } else {
      title = '不建议切换环境';
      message =
          '您当前${packageBean.des}已是默认的【${defaultNetworkModel.shortName}】，不建议切换，以免影响使用！';
    }

    AlertUtil.showFlexWidthButtonsAlert(
      context: currentContext,
      title: title,
      message: message,
      buttonTitles: buttonTitles,
      onPressedButton: (buttonIndex) {
        if (buttonIndex == 1) {
          // 继续切换
          Navigator.pop(currentContext);
          goChangeHandle();
        } else if (buttonIndex == 2) {
          // 恢复默认
          Navigator.pop(currentContext);
          _reset(defaultNetworkModel);
        } else {
          // 取消
          Navigator.pop(currentContext);
        }
      },
    );
  }

  /// 设置页点击添加代理的时候，检查包的环境
  static checkProxyAllowForPackage({
    void Function()
        goChangeHandle, // 是否允许有进入添加代理的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  }) {
    DiffPackageBean packageBean = MainDiffUtil.diffPackageBean();

    if (goChangeHandle == null) {
      throw Exception('进入添加代理的操作不能为空，请检查');
    }

    BuildContext currentContext = EnvUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }

    if (packageBean.packageType == PackageType.product) {
      ToastUtil.showMsg(
          '温馨提示：您当前包为${packageBean.des}，不支持添加代理。', currentContext);
      return;
    }

    goChangeHandle();
  }
}
