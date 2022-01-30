import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:package_info/package_info.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import './dev_util.dart';
import './dev_notifier.dart';

class DevPage extends StatefulWidget {
  const DevPage({Key key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool devSwtichValue = DevUtil.isDevFloatingWidgetShowing();

  String versionName = "";

  CommonModel _commonModel = CommonModel();

  @override
  void dispose() {
    super.dispose();
    DevUtil.isDevPageShowing = false;
  }

  @override
  void initState() {
    super.initState();

    DevUtil.isDevPageShowing = true;
    _getVersion();
  }

  // 获取版本号
  _getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    setState(() {
      versionName = "v $version($buildNumber)";
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
      ),
      body: Container(
        color: const Color(0xfff0f0f0),
        child: ListView(
          children: [
            _devtool_floating_cell(true),
            Container(height: 20),
            // 版本信息
            _devtool_appinfo_cell(),
            _devtool_appdownloadpage_cell(),
            _devtool_cancelNewVersionsPage_cell(),
            _devtool_checkVersion_cell(context),
            //_devtool_historyPackage_cell(),
            Container(height: 20),
            _devtool_userinfo_cell(),
            _devtool_forceLogout_cell(), // 强制退出
            Container(height: 20),
            Consumer<EnvironmentChangeNotifier>(
              builder: (context, environmentChangeNotifier, child) {
                return _devtool_env_cell(context, showTestApiWidget: true);
              },
            ),
            _devtool_apimock_cell(context, showTestApiWidget: true),
            _devtool_logSwtich_cell(),
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
    return BJHTitleTextValueCell(
      title: "app信息",
      textValue: versionName,
      onTap: () {
        Clipboard.setData(ClipboardData(text: versionName));
        ToastUtil.showMessage('app信息拷贝成功');
      },
    );
  }

  Widget _devtool_appdownloadpage_cell() {
    String downloadUrl = "https://www.pgyer.com/kKTt";
    return BJHTitleTextValueCell(
      title: "app下载页",
      textValue: downloadUrl,
      onTap: () async {
        if (await canLaunch(downloadUrl)) {
          await launch(downloadUrl);
        } else {
          throw 'cloud not launcher url';
        }
      },
    );
  }

  Widget _devtool_historyPackage_cell() {
    return BJHTitleTextValueCell(
      title: "app打包记录",
      textValue: '',
      onTap: () {
        //LoadingUtil.show();
        PygerUtil.getPgyerHistoryVersions().then((value) {
          //LoadingUtil.dismiss();
        }).catchError((onError) {
          //LoadingUtil.dismiss();
        });
      },
    );
  }

  Widget _devtool_cancelNewVersionsPage_cell() {
    return BJHTitleTextValueCell(
      title: "不再提示更新的新版本",
      textValue: '',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CancelVersionPage(),
          ),
        );
      },
    );
  }

  Widget _devtool_checkVersion_cell(BuildContext context) {
    return BJHTitleTextValueCell(
      title: "检查更新",
      textValue: '',
      onTap: () {
        //LoadingUtil.show();
        CheckVersionUtil.checkVersion(
          isManualCheck: true,
          isPyger: true,
        ).then((value) {
          //LoadingUtil.dismiss();
        }).catchError((onError) {
          //LoadingUtil.dismiss();
        });
      },
    );
  }

  Widget _devtool_userinfo_cell() {
    String userId = 'UserInfoManager().userModel.userId';
    String textValue = 'uid:$userId';
    return BJHTitleTextValueCell(
      title: "user信息",
      textValue: textValue,
      onTap: () {
        Clipboard.setData(ClipboardData(text: textValue));
        ToastUtil.showMessage('user信息拷贝成功');
      },
    );
  }

  Widget _devtool_env_cell(
    BuildContext context, {
    bool showTestApiWidget,
  }) {
    String envName = EnvironmentManager.instance.selectedNetworkModel.name;
    return BJHTitleTextValueCell(
      title: "切换环境",
      textValue: envName,
      onTap: () {
        DevUtil.goChangeEnvironment(
          context,
          showTestApiWidget: showTestApiWidget,
        ).then((value) {
          setState(() {});
        });
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
        DevUtil.goChangeApiMock(
          context,
          showTestApiWidget: showTestApiWidget,
        ).then((value) {
          setState(() {});
        });
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

  Widget _devtool_forceLogout_cell() {
    // if (UserInfoManager.instance.isLogin == false) {
    //   return Container(height: 1);
    // }
    return BJHTitleTextValueCell(
      title: "强制退出",
      textValue: '',
      onTap: () {
        AlertUtil.showCancelOKAlert(
          context: context,
          title: '确认强制退出吗？',
          message: '强制退出本仅用于某个环境无法退出导致无法使用其他环境时候使用，其他情况仅尽量不要使用',
          okHandle: () {
            // UserInfoManager.instance.userLoginOut().then((value) {
            Navigator.of(context).pop();
            // });
          },
        );
      },
    );
  }
}
