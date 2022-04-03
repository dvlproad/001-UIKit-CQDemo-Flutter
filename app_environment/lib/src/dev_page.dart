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

import './dev_util.dart';
import './dev_notifier.dart';
import './init/main_diff_util.dart';

class DevPage extends StatefulWidget {
  static List<Widget> navbarActions; // 开发工具页面导航栏上的按钮

  const DevPage({Key key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  BranchPackageInfo packageInfo;

  @override
  void dispose() {
    LoadingUtil.dismissInContext(context);

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

  DevChangeNotifier _devChangeNotifier = DevChangeNotifier();

  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();

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
        ChangeNotifierProvider<DevChangeNotifier>.value(
          value: _devChangeNotifier,
        ),
        ChangeNotifierProvider<EnvironmentChangeNotifier>.value(
          value: _environmentChangeNotifier,
        ),
      ],
      child: Consumer2<DevChangeNotifier, EnvironmentChangeNotifier>(
        builder: (context, devChangeNotifier, environmentChangeNotifier, _) {
          return _buildPageWidget(context);
        },
      ),
    );
  }

  Widget _buildPageWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('环境工具'),
        actions: DevPage.navbarActions,
      ),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            // 网络环境相关
            Consumer<EnvironmentChangeNotifier>(
              builder: (context, environmentChangeNotifier, child) {
                return _devtool_env_cell(context);
              },
            ),
            _devtool_proxy_cell(context),
            _devtool_apimock_cell(context),
          ],
        ),
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
    String envName = selectedNetworkModel.name;
    return BJHTitleTextValueCell(
      title: "切换环境",
      textValue: envName,
      onTap: () {
        PackageEnvironmentUtil.checkShouldResetNetwork(
          goChangeHandle: () {
            EnvUtil.goChangeEnvironmentNetwork(context).then((value) {
              setState(() {});
            });
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
    String proxyName = selectedProxyModel.name;
    return BJHTitleTextValueCell(
      title: "添加代理",
      textValue: proxyName,
      onTap: () {
        PackageEnvironmentUtil.checkProxyAllowForPackage(
          goChangeHandle: () {
            EnvUtil.goChangeEnvironmentProxy(context).then((value) {
              setState(() {});
            });
          },
        );
      },
    );
  }

  Widget _devtool_apimock_cell(BuildContext context) {
    int mockCount = ApiManager.mockCount();
    String mockCountString = '已mock:$mockCount个';
    return BJHTitleTextValueCell(
      title: "Mock工具",
      textValue: mockCountString,
      onTap: () {
        DiffPackageBean packageBean = MainDiffUtil.diffPackageBean();
        PackageType packageType = packageBean.packageType;
        if (packageType == PackageType.develop1 ||
            packageType == PackageType.develop2) {
          EnvUtil.goChangeApiMock(context).then((value) {
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
