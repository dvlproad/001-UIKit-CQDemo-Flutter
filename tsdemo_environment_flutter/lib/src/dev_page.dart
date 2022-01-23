import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_environment/flutter_environment.dart';
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
    var version = packageInfo.version;
    setState(() {
      versionName = "v $version";
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
            Container(height: 40),
            _devtool_appinfo_cell(),
            Consumer<EnvironmentChangeNotifier>(
              builder: (context, environmentChangeNotifier, child) {
                return _devtool_env_cell(context, showTestApiWidget: true);
              },
            ),
            _devtool_apimock_cell(context, showTestApiWidget: true),
            _devtool_logSwtich_cell(),
            _devtool_checkVersion_cell(context),
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
      onTap: () {},
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
        DevUtil.goChangeApiMock(
          context,
          showTestApiWidget: showTestApiWidget,
        );
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

  Widget _devtool_checkVersion_cell(BuildContext context) {
    return BJHTitleTextValueCell(
      title: "检查更新",
      textValue: '',
      onTap: () {
        // if (VersionManager.instance.firstSHow) {
        //   VersionManager.instance.setFirstShow(false);
        _getAppVersion(context);
        // }
      },
    );
  }

  void _getAppVersion(BuildContext context) {
    launcherPyger();

    // VersionBean bean = VersionBean.fromParams(
    //   version: '10100',
    //   isson: 's..s',
    //   downloadUrl: 'downloadUrl',
    // );
    // versionUpdateDialog(bean, context);

    // _commonModel.checkPgyerVersion();

    // _commonModel.checkVersion().then((VersionBean bean) {
    //   versionUpdateDialog(bean, context);
    // }).catchError((onError) {});
  }

  launcherPyger() async {
    var url = "https://www.pgyer.com/kKTt";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'cloud not launcher url';
    }
  }
}
