import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_network/flutter_network.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import 'package:flutter_updateversion_kit/src/check_version_common_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import './main_init/package_environment_util.dart';

import './package_info_cell.dart';
import './dev_util.dart';
import './dev_notifier.dart';
import './main_init/main_diff_util.dart';

class DevPage extends StatefulWidget {
  static List<Widget> navbarActions; // 开发工具页面导航栏上的按钮

  const DevPage({Key key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool devSwtichValue = DevUtil.isDevFloatingWidgetShowing();

  BranchPackageInfo packageInfo;
  List<String> _cancelShowVersions;

  CommonModel _commonModel = CommonModel();

  @override
  void dispose() {
    super.dispose();
    DevUtil.isDevPageShowing = false;

    LoadingUtil.dismissInContext(context);
  }

  @override
  void initState() {
    super.initState();

    DevUtil.isDevPageShowing = true;
    _getVersion();
    _getCancelShowVersions();
  }

  // 获取版本号
  _getVersion() async {
    packageInfo = await BranchPackageInfo.fromPlatform();

    setState(() {});
  }

  // 获取被跳过的版本个数
  _getCancelShowVersions() {
    CheckVersionCommonUtil.getCancelShowVersion()
        .then((List<String> bCancelShowVersions) {
      setState(() {
        _cancelShowVersions = bCancelShowVersions;
      });
    });
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
        title: Text('开发工具'),
        actions: DevPage.navbarActions,
      ),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            _devtool_floating_cell(true),

            Container(height: 20),
            // // header 的 增删该
            // _devtool_changeheader_cell(),
            // _devtool_removeheaderKey_cell(),
            // 版本信息
            _devtool_appinfo_cell(),
            _devtool_checkVersion_cell(context),
            _devtool_cancelNewVersionsPage_cell(),
            Container(height: 20),
            _app_downloadpage_cell(),
            //_devtool_historyPackage_cell(),
            Container(height: 20),
            Consumer<EnvironmentChangeNotifier>(
              builder: (context, environmentChangeNotifier, child) {
                return _devtool_env_cell(context, showTestApiWidget: true);
              },
            ),
            _devtool_proxy_cell(context, showTestApiWidget: true),
            _devtool_apimock_cell(context, showTestApiWidget: true),
            Container(height: 20),
            _devtool_logSwtich_cell(),
            // _devtool_logTest_cell(),
          ],
        ),
      ),
    );
  }

  Widget _devtool_floating_cell(bool showTestApiWidget) {
    return BJHTitleSwitchValueCell(
      title: "显示开发工具的悬浮按钮",
      boolValue: devSwtichValue,
      onChanged: (bSwtichValue) {
        setState(() {
          devSwtichValue = bSwtichValue;

          if (bSwtichValue == true) {
            DevUtil.showDevFloatingWidget(
              showTestApiWidget: showTestApiWidget,
            );
          } else {
            DevUtil.hideDevFloatingWidget();
          }
        });
      },
    );
  }

  Widget _devtool_appinfo_cell() {
    return PackageInfoCell(packageInfo: packageInfo);
  }

  Widget _app_downloadpage_cell() {
    return Container(
      color: const Color(0xfff0f0f0),
      child: Column(
        children: [
          BJHTitleTextValueCell(
            height: 40,
            title: "app下载页",
            textValue: '',
            arrowImageType: TableViewCellArrowImageType.none,
          ),
          _devtool_app_downloadpage_cell(PackageType.develop1),
          _devtool_app_downloadpage_cell(PackageType.preproduct),
          _devtool_app_downloadpage_cell(PackageType.product),
        ],
      ),
    );
  }

  Widget _devtool_app_downloadpage_cell(PackageType packageType) {
    DiffPackageBean diffPackageBean =
        MainDiffUtil.diffPackageBeanByType(packageType);

    String downloadUrl = diffPackageBean.downloadUrl;
    return BJHTitleTextValueCell(
      height: 40,
      title: "${diffPackageBean.des}：",
      textValue: downloadUrl,
      textValueFontSize: 12,
      onTap: () async {
        if (await canLaunch(downloadUrl)) {
          await launch(downloadUrl);
        } else {
          throw 'cloud not launcher url';
        }
      },
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: downloadUrl));
        ToastUtil.showMessage('app下载页地址拷贝成功');
      },
    );
  }

  Widget _devtool_historyPackage_cell() {
    return BJHTitleTextValueCell(
      title: "app打包记录",
      textValue: '',
      onTap: () {
        LoadingUtil.show();
        PygerUtil.getPgyerHistoryVersions().then((value) {
          LoadingUtil.dismiss();
        }).catchError((onError) {
          LoadingUtil.dismiss();
        });
      },
    );
  }

  Widget _devtool_cancelNewVersionsPage_cell() {
    return BJHTitleTextValueCell(
      title: "不再提示更新的版本",
      textValue: '已跳过:${_cancelShowVersions?.length}个',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CancelVersionPage(),
          ),
        ).then((value) {
          // setState(() {});
          _getCancelShowVersions();
        });
      },
    );
  }

  Widget _devtool_checkVersion_cell(BuildContext context) {
    return BJHTitleTextValueCell(
      title: "检查更新",
      textValue: '',
      onTap: () {
        LoadingUtil.showInContext(context);
        // Future.delayed(Duration(milliseconds: 3000)).then((value) {
        //   LoadingUtil.dismissInContext(context);
        // });
        CheckVersionUtil.checkVersion(
          isManualCheck: true,
        ).then((value) {
          LoadingUtil.dismissInContext(context);
        }).catchError((onError) {
          LoadingUtil.dismissInContext(context);
        });
      },
    );
  }

  Widget _devtool_changeheader_cell() {
    return BJHTitleTextValueCell(
      title: "添加/修改header",
      textValue: '',
      onTap: () {
        NetworkManager.addOrUpdateToken('12345');
        ToastUtil.showMessage('添加/修改header成功');
      },
    );
  }

  Widget _devtool_removeheaderKey_cell() {
    return BJHTitleTextValueCell(
      title: "删除header",
      textValue: '',
      onTap: () {
        NetworkManager.removeToken();
        ToastUtil.showMessage('删除header成功');
      },
    );
  }

  Widget _devtool_env_cell(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    TSEnvNetworkModel selectedNetworkModel =
        NetworkPageDataManager().selectedNetworkModel;
    if (selectedNetworkModel == null) {
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
            DevUtil.goChangeEnvironmentNetwork(
              context,
              showTestApiWidget: showTestApiWidget,
            ).then((value) {
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

  Widget _devtool_proxy_cell(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    TSEnvProxyModel selectedProxyModel =
        ProxyPageDataManager().selectedProxyModel;
    if (selectedProxyModel == null) {
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
            DevUtil.goChangeEnvironmentProxy(
              context,
              showTestApiWidget: showTestApiWidget,
            ).then((value) {
              setState(() {});
            });
          },
        );
      },
    );
  }

  Widget _devtool_apimock_cell(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
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
          DevUtil.goChangeApiMock(
            context,
            showTestApiWidget: showTestApiWidget,
          ).then((value) {
            setState(() {});
          });
        } else {
          String message = "您当前包为${packageBean.des}，不支持Mock";
          ToastUtil.showMsg(message, context);
        }
      },
    );
  }

  Widget _devtool_logSwtich_cell() {
    return BJHTitleSwitchValueCell(
      title: "显示日志系统(长按悬浮按钮也可打开)",
      boolValue: DevLogUtil.isLogShowing,
      onChanged: (bSwtichValue) {
        setState(() {
          DevLogUtil.isLogShowing = bSwtichValue;

          if (bSwtichValue == true) {
            DevLogUtil.showLogView();
          } else {
            DevLogUtil.dismissLogView();
          }
        });
      },
    );
  }

  Widget _devtool_logTest_cell() {
    return BJHTitleTextValueCell(
      title: "测试日志上报到企业微信",
      textValue: '',
      onTap: () {
        // String title = '我只是个测试标题';
        // String customMessage = '我只是测试信息';
        // LogUtil.postError(null, title, customMessage, ['lichaoqian']);

        String apiFullUrl =
            "http://121.41.91.92:3000/mock/28/hapi/test_test_test/";
        String apiMessage = '我只是测试的api的上报信息';
        LogUtil.apiError(apiFullUrl, apiMessage);
      },
    );
  }
}
