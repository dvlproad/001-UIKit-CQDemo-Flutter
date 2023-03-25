import 'package:flutter/material.dart';

import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

import './env_page_util.dart';

class PackageCheckUpdateTargetUtil {
  // 启动时候，检查当前包的当前平台环境和默认的平台环境是否一样，如果不一样，提示切回默认的环境，避免用户使用不存在或者过期或者未上线的功能
  static checkShouldResetTarget({
    void Function()?
        goChangeHandle, // 是否允许有进入切换环境的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  }) {
    // 获取当前平台环境
    PackageTargetModel currentPackageTargetModel =
        PackageTargetPageDataManager().selectedTargetModel;
    // PackageTargetType currentTargetType = currentPackageTargetModel.type;

    // 获取当前包应该的默认平台环境
    PackageTargetType originTargetType =
        PackageTargetPageDataManager().originPackageTargetModel.type;
    PackageTargetModel originPackageTargetModel =
        PackageTargetModel.targetModelByType(originTargetType);

    // 检查当前包的当前平台环境和默认的平台环境是否一样，如果不一样，提示切回默认的环境
    if (goChangeHandle == null) {
      //   // 启动时候
      //   _checkNetworkWhenStartForPackage(
      //     packageBean,
      //     defaultNetworkModel,
      //     currentPackageTargetModel,
      //   );
    } else {
      // 设置界面里
      _checkNetworkNoStartForPackage(
        originPackageTargetModel: originPackageTargetModel,
        currentPackageTargetModel: currentPackageTargetModel,
        goChangeHandle: goChangeHandle,
      );
    }
  }

  /// 启动时候检查包的环境
  // ignore: unused_element
  static _checkNetworkWhenStartForPackage({
    required PackageTargetType originTargetType,
    required PackageTargetType currentTargetType,
  }) {
    BuildContext? currentContext = EnvPageUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }
    /*
    String defaultEnvId = defaultNetworkModel.envId;

    String currentEnvId = currentPackageTargetModel.envId;

    if (currentEnvId != defaultEnvId) {
      String title = '是否恢复默认的【${defaultNetworkModel.name}】';
      String message =
          '您当前${packageBean.des}不是默认环境，而是[${currentPackageTargetModel.name}]，建议切回默认，以免影响使用！';
      AlertUtil.showCancelOKAlert(
        context: currentContext,
        barrierDismissible: true,
        title: title,
        message: message,
        cancelTitle: '继续${currentPackageTargetModel.shortName}',
        okTitle: '恢复${defaultNetworkModel.shortName}',
        okHandle: () {
          _reset(defaultNetworkModel, context: currentContext);
        },
      );
    }
    */
  }

  static _reset(
    PackageTargetModel defaultTargetModel, {
    required BuildContext context,
  }) {
    EnvPageUtil.changePackageTarget(
      defaultTargetModel,
      context: context,
    );
  }

  /// 设置页点击切换环境的时候，检查包的环境
  static _checkNetworkNoStartForPackage({
    required PackageTargetModel originPackageTargetModel,
    required PackageTargetModel currentPackageTargetModel,
    void Function()?
        goChangeHandle, // 是否允许有进入切换环境的功能，如果允许的话，其执行的操作(如果为null，则不允许,如启动的时候，只有‘取消+恢复默认')
  }) {
    if (goChangeHandle == null) {
      throw Exception('进入切换平台的操作不能为空，请检查');
    }

    BuildContext? currentContext = EnvPageUtil.navigatorKey.currentContext;
    if (currentContext == null) {
      throw Exception('界面获取失败，请检查');
    }

    String originTargetDes = originPackageTargetModel.name;
    String currentTargetDes = currentPackageTargetModel.name;

    String title;
    String message;
    List<String> buttonTitles = [];
    buttonTitles.add('继续$currentTargetDes');
    buttonTitles.add('其他');
    if (currentPackageTargetModel.type != originPackageTargetModel.type) {
      title = '是否恢复默认的【$originTargetDes】';
      message =
          '您当前$currentTargetDes不是默认平台，而是[$originTargetDes]，建议切回默认，以免影响使用！';
      buttonTitles.add('恢复$originTargetDes');
    } else {
      title = '不建议切换平台';
      message = '您当前$currentTargetDes已是默认的平台，不建议切换，以免影响使用！';
    }

    AlertUtil.showFlexWidthButtonsAlert(
      context: currentContext,
      barrierDismissible: true,
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
          _reset(originPackageTargetModel, context: currentContext);
        } else {
          // 取消
          Navigator.pop(currentContext);
        }
      },
    );

    // AlertUtil.showCancelOKAlert(
    //   context: context,
    //   barrierDismissible: true,
    //   title: '切换人群',
    //   cancelTitle: packageTargetModel.type != PackageTargetType.inner
    //       ? '切到内测包'
    //       : '继续内测包',
    //   cancelHandle: () {
    //     EnvPageUtil.changePackageTarget(
    //       PackageTargetModel.innerTargetModel,
    //       context: context,
    //     );
    //   },
    //   okTitle: packageTargetModel.type != PackageTargetType.formal
    //       ? '切到外测包'
    //       : '继续外测包',
    //   okHandle: () {
    //     EnvPageUtil.changePackageTarget(
    //       PackageTargetModel.formalTargetModel,
    //       context: context,
    //     );
    //   },
    // );
  }
}
