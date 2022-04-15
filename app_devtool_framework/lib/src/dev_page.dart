import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_environment/flutter_environment.dart';
import 'package:app_network/app_network.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_log/flutter_log.dart';
import 'package:flutter_updateversion_kit/flutter_updateversion_kit.dart';
import 'package:flutter_updateversion_kit/src/check_version_common_util.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_environment/app_environment.dart';

import './package_info_cell.dart';
import './dev_util.dart';
import './dev_notifier.dart';
import './history_version/history_version_page.dart';
import './dev_branch/dev_branch_page.dart';

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

  String _historyRecordTime;
  List<HistoryVersionBean> _historyVersionBeans;

  String _brancesRecordTime;
  List<DevBranchBean> _devBranchBeans;

  @override
  void dispose() {
    DevUtil.isDevPageShowing = false;

    LoadingUtil.dismissInContext(context);

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    packageInfo = BranchPackageInfo.nullPackageInfo;

    DevUtil.isDevPageShowing = true;
    _getVersion();
    _getCancelShowVersions();
  }

  // 获取版本号
  _getVersion() async {
    packageInfo = await BranchPackageInfo.fromPlatform();

    _historyRecordTime = packageInfo.historyRecordTime;
    _historyVersionBeans = packageInfo.historyVersionMaps?.map((json) {
      return HistoryVersionBean.fromJson(json);
    }).toList();

    _brancesRecordTime = packageInfo.brancesRecordTime;
    List<DevBranchBean> featureBranchBeans =
        packageInfo.featureBranchMaps?.map((json) {
      return DevBranchBean.fromJson(json);
    }).toList();
    List<DevBranchBean> nocodeBranceBeans =
        packageInfo.nocodeBranceMaps?.map((json) {
      return DevBranchBean.fromJson(json);
    }).toList();

    _devBranchBeans = [];
    _devBranchBeans.addAll(nocodeBranceBeans);
    _devBranchBeans.addAll(featureBranchBeans);

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
            _devtool_floating_cell(),
            _permission_cell(),

            // 版本信息
            Container(height: 20),
            _devtool_appinfo_cell(),
            _devtool_checkVersion_cell(context),
            _devtool_cancelNewVersionsPage_cell(),
            Container(height: 20),
            _devBranch_cell(),
            _historyVersion_cell(),
            Container(height: 20),
            _app_downloadpage_cell(),
            //_devtool_historyPackage_cell(),
            // 网络环境相关
            Container(height: 20),
            EnvWidget(),
            // 网络库测试相关
            _devtool_changeheader_cell(), // 网络库:header 的 增删该
            _devtool_removeheaderKey_cell(), // 网络库:header 的 增删该
            _apicache_cell(context),
            _apiretry_cell(context),
            // 日志相关
            Container(height: 20),
            _devtool_logSwtich_cell(),
            _devtool_logTest_cell(),
          ],
        ),
      ),
    );
  }

  Widget _devtool_floating_cell() {
    return BJHTitleSwitchValueCell(
      title: "显示开发工具的悬浮按钮",
      boolValue: devSwtichValue,
      onChanged: (bSwtichValue) {
        setState(() {
          devSwtichValue = bSwtichValue;

          if (bSwtichValue == true) {
            DevUtil.showDevFloatingWidget();
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

  Widget _permission_cell() {
    return BJHTitleTextValueCell(
      title: "打开app设置",
      textValue: '',
      onTap: () {
        openAppSettings();
      },
    );
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

  Widget _devBranch_cell() {
    return BJHTitleTextValueCell(
      title: "当前【开发中】的需求记录",
      textValue: '记于${packageInfo.brancesRecordTime}',
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return DevBranchPage(
            brancesRecordTime: _brancesRecordTime,
            devBranchBeans: _devBranchBeans,
          );
        }));
      },
    );
  }

  Widget _historyVersion_cell() {
    return BJHTitleTextValueCell(
      title: "当前【已上线】的版本记录",
      textValue: '记于${packageInfo.historyRecordTime}',
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HistoryVersionPage(
            historyRecordTime: _historyRecordTime,
            historyVersionBeans: _historyVersionBeans,
          );
        }));
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

  /// 网络库测试相关
  Widget _devtool_changeheader_cell() {
    if (!_isDebug()) {
      return Container();
    }
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
    if (!_isDebug()) {
      return Container();
    }
    return BJHTitleTextValueCell(
      title: "删除header",
      textValue: '',
      onTap: () {
        NetworkManager.removeToken();
        ToastUtil.showMessage('删除header成功');
      },
    );
  }

  Widget _apicache_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return BJHTitleTextValueCell(
      title: "网络库：测试请求的缓存功能",
      textValue: '',
      onTap: () {
        AppNetworkKit.post(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
          },
          cacheLevel: NetworkCacheLevel.one,
        ).then((ResponseModel responseModel) {
          String message = responseModel.isCache ? "是缓存数据" : "是网络数据";
          debugPrint('测试网络请求的缓存功能:$message');
        });
      },
    );
  }

  Widget _apiretry_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return BJHTitleTextValueCell(
      title: "网络库：测试请求的重试功能",
      textValue: '',
      onTap: () {
        int requestCount = 0;
        AppNetworkKit.postWithCallback(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
            'retryCount': 3,
          },
          cacheLevel: NetworkCacheLevel.none,
          completeCallBack: (resultData) {
            requestCount++;
            debugPrint('测试网络请求的重试功能:当前重试次数$requestCount');
          },
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

  Widget _devtool_logTest_cell() {
    if (!_isDebug()) {
      return Container();
    }
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
        LogApiUtil.apiError(apiFullUrl, apiMessage);
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
