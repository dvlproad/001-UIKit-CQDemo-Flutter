import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_effect_kit/flutter_effect_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import 'package:provider/provider.dart';
import './init/package_environment_util.dart';
import './init/packageType_env_util.dart';
import './init/packageType_page_data_manager.dart';
import './init/packageType_page_data_bean.dart';

import './env_page_util.dart';
import './env_notifier.dart';
import './init/main_diff_util.dart';

class EnvWidget extends StatefulWidget {
  const EnvWidget({Key key}) : super(key: key);

  @override
  _EnvWidgetState createState() => _EnvWidgetState();
}

class _EnvWidgetState extends State<EnvWidget> {
  BranchPackageInfo packageInfo;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    packageInfo = BranchPackageInfo.nullPackageInfo;

    _getVersion();
  }

  // 获取版本号
  _getVersion() async {
    packageInfo = await BranchPackageInfo.fromPlatform();

    setState(() {});
  }

  EnvChangeNotifier _devChangeNotifier = EnvChangeNotifier();

  NetworkEnvironmentChangeNotifier _environmentChangeNotifier =
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
        physics: NeverScrollableScrollPhysics(),
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

  Widget _devtool_env_cell(BuildContext context) {
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    if (selectedNetworkModel == null) {
      return Container();
      throw Exception(
          '未设置选中的网络环境，请检查是否调用过 EnvironmentUtil.completeEnvInternal_whenNull');
    }
    return ImageTitleTextValueCell(
      height: envCellHeight,
      title: "切换环境",
      textValue: selectedNetworkModel.name,
      textSubValue: selectedNetworkModel.apiHost,
      onTap: () {
        PackageEnvironmentUtil.checkShouldResetNetwork(
          goChangeHandle: () {
            EnvPageUtil.goChangeEnvironmentNetwork(context).then((value) {
              setState(() {});
            });
          },
        );
      },
    );
  }

  /// 更换包的上传位置(内测pgyer、公测testFlight)
  Widget _change_packageUploadTarget_cell(BuildContext context) {
    PackageTargetModel packageTargetModel =
        PackageTargetPageDataManager().selectedPackageTargetModel;

    return ImageTitleTextValueCell(
      height: envCellHeight,
      title: "切换内外测",
      textValue: packageTargetModel.name,
      textSubValue: '公测与蒲公英版本检测调用方法不一样而已',
      onTap: () {
        AlertUtil.showCancelOKAlert(
          context: context,
          barrierDismissible: true,
          title: '切换内外测',
          cancelTitle: '内测包',
          cancelHandle: () {
            PackageTargetEnvUtil.changePackageTarget(
              PackageTargetModel.pgyerTargetModel,
              context: context,
            );
          },
          okTitle: '外测包',
          okHandle: () {
            PackageTargetEnvUtil.changePackageTarget(
              PackageTargetModel.formalTargetModel,
              context: context,
            );
          },
        );
      },
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
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;
    if (selectedProxyModel == null) {
      return Container();

      throw Exception(
          '未设置选中的代理，请检查是否调用过 EnvironmentUtil.completeEnvInternal_whenNull');
    }
    return ImageTitleTextValueCell(
      height: envCellHeight,
      leftMaxWidth: 80,
      title: "添加代理",
      textValue: selectedProxyModel.name,
      textSubValue: selectedProxyModel.proxyIp,
      onTap: () {
        PackageEnvironmentUtil.checkProxyAllowForPackage(
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
        DiffPackageBean packageBean = MainDiffUtil.diffPackageBean();
        PackageType packageType = packageBean.packageType;
        if (packageType == PackageType.develop1 ||
            packageType == PackageType.develop2) {
          EnvPageUtil.goChangeApiMock(context).then((value) {
            setState(() {});
          });
        } else {
          String message = "您当前包为${packageBean.des}，不支持Mock";
          ToastUtil.showMsg(message, context);
        }
      },
    );
  }

  /// 判断是否为Debug模式
  static bool _isDebug() {
    bool inDebug = false;
    assert(inDebug =
        true); // 根据模式的介绍，可以知道Release模式关闭了所有的断言，assert的代码在打包时不会打包到二进制包中。因此我们可以借助断言，写出只在Debug模式下生效的代码
    return inDebug;
  }
}
