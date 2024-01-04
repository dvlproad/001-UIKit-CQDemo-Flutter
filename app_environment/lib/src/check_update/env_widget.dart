// ignore_for_file: non_constant_identifier_names

/*
 * @Author: dvlproad
 * @Date: 2022-10-13 10:53:02
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-04 17:34:03
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_environment_base/flutter_environment_base.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:provider/provider.dart';
// import './package_check_update_network_util.dart';
// import './package_check_update_target_util.dart';
import './package_check_update_proxy_util.dart';

import './env_page_util.dart';
import './env_notifier.dart';

class EnvWidget extends StatefulWidget {
  const EnvWidget({Key? key}) : super(key: key);

  @override
  _EnvWidgetState createState() => _EnvWidgetState();
}

class _EnvWidgetState extends State<EnvWidget> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _getVersion();
  }

  // 获取版本号
  _getVersion() async {
    setState(() {});
  }

  final EnvChangeNotifier _devChangeNotifier = EnvChangeNotifier();

  final NetworkEnvironmentChangeNotifier _environmentChangeNotifier =
      NetworkEnvironmentChangeNotifier();

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider<DevNotifier>.value(
    //   value: DevNotifier(),
    //   child: Consumer<DevNotifier>(
    //     builder: (context, environmentChangeNotifier, child) {
    //       return _buildPageWidget(context);
    //     },
    //   ),
    // );
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EnvChangeNotifier>.value(
          value: _devChangeNotifier,
        ),
        ChangeNotifierProvider<NetworkEnvironmentChangeNotifier>.value(
          value: _environmentChangeNotifier,
        ),
      ],
      child: Consumer2<EnvChangeNotifier, NetworkEnvironmentChangeNotifier>(
        builder: (context, devChangeNotifier, environmentChangeNotifier, _) {
          return _buildPageWidget(context);
        },
      ),
    );
  }

  static double envCellHeight = 44.0;
  Widget _buildPageWidget(BuildContext context) {
    return Container(
      color: const Color(0xfff0f0f0),
      height: 3 * envCellHeight,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // 网络环境相关
          Consumer<NetworkEnvironmentChangeNotifier>(
            builder: (context, environmentChangeNotifier, child) {
              return _devtool_env_cell(context);
            },
          ),
          _change_packageUploadTarget_cell(context),
          _devtool_proxy_cell(context),
          _devtool_apimock_cell(context),
        ],
      ),
    );
  }

  // 切换环境
  Widget _devtool_env_cell(BuildContext context) {
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    // if (selectedNetworkModel == null) {
    //   return Container();
    //   throw Exception(
    //       '未设置选中的网络环境，请检查是否调用过 EnvironmentUtil.completeEnvInternal_whenNull');
    // }
    return ImageTitleTextValueCell(
      height: envCellHeight,
      title: "切换环境",
      textValue: selectedNetworkModel.name,
      textSubValue: selectedNetworkModel.apiHost,
      // onTap: () {
      //   PackageCheckUpdateNetworkUtil.checkShouldResetNetwork(
      //     goChangeHandle: () {
      //       EnvPageUtil.goChangeEnvironmentNetwork(context).then((value) {
      //         setState(() {});
      //       });
      //     },
      //   );
      // },
    );
  }

  /// 更换包的上传位置(内测inner、公测testFlight)
  Widget _change_packageUploadTarget_cell(BuildContext context) {
    PackageTargetModel packageTargetModel =
        PackageTargetPageDataManager().selectedTargetModel;

    return ImageTitleTextValueCell(
      height: envCellHeight,
      title: "切换平台",
      textValue: packageTargetModel.name,
      textSubValue: packageTargetModel.des,
      // onTap: () {
      //   PackageCheckUpdateTargetUtil.checkShouldResetTarget(
      //     goChangeHandle: () {
      //       EnvPageUtil.goChangeEnvironmentTarget(context).then((value) {
      //         setState(() {});
      //       });
      //     },
      //   );
      // },
    );
  }

  /*
  void _showPasswordAlert(
    BuildContext context, {
    String title,
    String message,
    String password,
    void Function() passwordCorrectAction,
  }) {
    BrnMiddleInputDialog(
      title: title,
      message: message,
      hintText: '请输入密码$password',
      cancelText: '取消',
      confirmText: '确定',
      autoFocus: true,
      maxLength: 1000,
      maxLines: 2,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      dismissOnActionsTap: false,
      barrierDismissible: true,
      onConfirm: (value) {
        if (value != '654321') {
          BrnToast.show('密码错误', context);
          return;
        }
        Navigator.pop(context);
        if (passwordCorrectAction != null) {
          passwordCorrectAction();
        }
      },
      onCancel: () {
        Navigator.pop(context);
      },
    ).show(context);
  }
  */

  Widget _devtool_proxy_cell(BuildContext context) {
    TSEnvProxyModel? selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;
    // if (selectedProxyModel == null) {
    //   return Container();

    //   throw Exception(
    //       '未设置选中的代理，请检查是否调用过 EnvironmentUtil.completeEnvInternal_whenNull');
    // }
    return ImageTitleTextValueCell(
      height: envCellHeight,
      leftMaxWidth: 80,
      title: "添加代理",
      textValue: selectedProxyModel.name,
      textSubValue: selectedProxyModel.proxyIp,
      onTap: () {
        PackageCheckUpdateProxyUtil.checkProxyAllowForPackage(
          goChangeHandle: () {
            EnvPageUtil.goChangeEnvironmentProxy(context).then((value) {
              setState(() {});
            });
          },
        );
      },
      onLongPress: () async {
        bool proxyHappenChange =
            await EnvironmentUtil.changeToNoneProxy_ifNoneTryToPhone();
        if (proxyHappenChange) {
          setState(() {});
        }
      },
    );
  }

  Widget _devtool_apimock_cell(BuildContext context) {
    int mockCount = ApiManager.mockCount();
    String mockCountString = '已mock:$mockCount个';
    return ImageTitleTextValueCell(
      height: envCellHeight,
      title: "Mock工具",
      textValue: mockCountString,
      onTap: () {
        PackageNetworkType packageNetworkType =
            NetworkPageDataManager().originNetworkModel.type;
        if (packageNetworkType == PackageNetworkType.develop1 ||
            packageNetworkType == PackageNetworkType.develop2) {
          EnvPageUtil.goChangeApiMock(context).then((value) {
            setState(() {});
          });
        } else {
          String message =
              "您当前包为${NetworkPageDataManager().originNetworkModel.name}，不支持Mock";
          ToastUtil.showMsg(message, context);
        }
      },
    );
  }

  /// 判断是否为Debug模式
  // ignore: unused_element
  static bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }
}
