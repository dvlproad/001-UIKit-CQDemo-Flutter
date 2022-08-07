import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show Clipboard, ClipboardData;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart' show Dio, Options, Response;
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:app_network/app_network.dart';
import 'package:app_log/app_log.dart';
import 'package:app_environment/app_environment.dart';
import 'package:app_updateversion_kit/app_updateversion_kit.dart';

import './dev_environment_change_notifiter.dart';

import './widget/package_info_cell.dart';

import './widget/app_dir_size_widget.dart';
import './widget/shared_preferences_page.dart';

import './dev_util.dart';
import './dev_notifier.dart';
import './history_version/history_version_page.dart';
import './dev_branch/dev_branch_page.dart';
import './apns_util.dart';

class DevPage extends StatefulWidget {
  static List<Widget> navbarActions; // 开发工具页面导航栏上的按钮

  const DevPage({Key key}) : super(key: key);

  @override
  _DevPageState createState() => _DevPageState();
}

class _DevPageState extends State<DevPage> {
  bool devSwtichValue = DevUtil.isDevFloatingWidgetShowing();

  BranchPackageInfo packageInfo;

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

  DevChangeNotifier _devChangeNotifier = DevChangeNotifier();

  DevEnvironmentChangeNotifier _environmentChangeNotifier =
      DevEnvironmentChangeNotifier();

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
        ChangeNotifierProvider<DevEnvironmentChangeNotifier>.value(
          value: _environmentChangeNotifier,
        ),
      ],
      child: Consumer2<DevChangeNotifier, DevEnvironmentChangeNotifier>(
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

            // 版本信息+检查更新
            Container(height: 20),
            _devtool_appinfo_cell(),
            _devtool_checkVersion_cell(context),
            CanceledVersionWidget(),
            // 文件大小
            Container(height: 20),
            AppDirSizeWidget(),
            // deviceToken
            _rennderItemPage(title: '清理缓存', page: SharedPreferencesPage()),
            Container(height: 20),
            _deviceToken_cell(),

            // app 下载页
            Container(height: 20),
            AppDownloadWidget(),

            // 网络环境相关
            Container(height: 20),
            EnvWidget(),
            // 网络库测试相关
            _devtool_changeheader_cell(), // 网络库:header 的 增删该
            _devtool_removeheaderKey_cell(), // 网络库:header 的 增删该
            _apilog_get_cell(context),
            _apicache_businessFailure_cell(context),
            _apicache_businessSuccess_cell(context),
            _apiretry_cell(context),
            _api_buriedpoint_cell(context),
            _api_buriedpoint_cell2(context),
            // 需求分支+线上版本记录
            Container(height: 20),
            _devBranch_cell(),
            _historyVersion_cell(),
            // 日志相关
            Container(height: 20),
            _devtool_logSwtich_cell(),
            _devtool_logTest_cell(),
            Container(height: 40),
          ],
        ),
      ),
    );
  }

  _rennderItemPage({@required String title, @required Widget page}) {
    return ImageTitleTextValueCell(
      title: title,
      textValue: '',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ));
      },
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

  Widget _permission_cell() {
    return ImageTitleTextValueCell(
      title: "打开app设置",
      textValue: '',
      onTap: () {
        openAppSettings();
      },
    );
  }

  // app 信息
  Widget _devtool_appinfo_cell() {
    return PackageInfoCell(packageInfo: packageInfo);
  }

  // deviceToken
  Widget _deviceToken_cell() {
    String deviceToken = APNSUtil.deviceToken ?? '空(若非模拟器,则为注册失败)';
    return ImageTitleTextValueCell(
      leftMaxWidth: 100,
      title: "deviceToken",
      textValue: deviceToken,
      textValueFontSize: 12,
      textValueMaxLines: 2,
      onTap: () {
        Clipboard.setData(ClipboardData(text: deviceToken));
        ToastUtil.showMessage('app deviceToken 拷贝成功');
      },
    );
  }

  // 需求分支记录
  Widget _devBranch_cell() {
    return ImageTitleTextValueCell(
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

  // 线上版本记录
  Widget _historyVersion_cell() {
    return ImageTitleTextValueCell(
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

  Widget _devtool_checkVersion_cell(BuildContext context) {
    return ImageTitleTextValueCell(
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
    return ImageTitleTextValueCell(
      title: "添加/修改header",
      textValue: '12345',
      onTap: () {
        AppNetworkManager().addOrUpdateToken('12345');
        ToastUtil.showMessage('添加/修改header成功');
      },
    );
  }

  Widget _devtool_removeheaderKey_cell() {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "删除header",
      textValue: '',
      onTap: () {
        AppNetworkManager().removeToken();
        ToastUtil.showMessage('删除header成功');
      },
    );
  }

  Widget _apicache_businessFailure_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试请求的缓存功能(失败不缓存)",
      textValue: '',
      onTap: () {
        AppNetworkKit.postWithCallback(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
          },
          cacheLevel: AppNetworkCacheLevel.one,
          completeCallBack: (ResponseModel responseModel) {
            String message = responseModel.isCache == true ? "是缓存数据" : "是网络数据";
            debugPrint('测试网络请求的缓存功能:$message');
          },
        );

        // AppNetworkManager().postRich(
        //   'login/doLogin',
        //   params: {
        //     "clientId": "clientApp",
        //     "clientSecret": "123123",
        //   },
        //   cacheLevel: AppNetworkCacheLevel.one,
        // )
        //     .then((ResponseModel responseModel) {
        //   String message = responseModel.isCache == true ? "是缓存数据" : "是网络数据";
        //   debugPrint('测试网络请求的缓存功能:$message');
        // });
      },
    );
  }

  Widget _apicache_businessSuccess_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试请求的缓存功能(成功才缓存)",
      textValue: '',
      onTap: () {
        AppNetworkKit.postWithCallback(
          'user/account/getTelCaptcha',
          params: {
            "smsPhoneNumber": '18012345678',
            "captchaType": "LOGIN",
          },
          cacheLevel: AppNetworkCacheLevel.one,
          completeCallBack: (ResponseModel responseModel) {
            String message = responseModel.isCache == true ? "是缓存数据" : "是网络数据";
            debugPrint('测试网络请求的缓存功能:$message');
          },
        );
        // AppNetworkManager().cache_post(
        //   'user/account/getTelCaptcha',
        //   params: {
        //     "smsPhoneNumber": '18012345678',
        //     "captchaType": "LOGIN",
        //   },
        //   cacheLevel: AppNetworkCacheLevel.one,
        // )
        //     .then((ResponseModel responseModel) {
        //   String message = responseModel.isCache == true ? "是缓存数据" : "是网络数据";
        //   debugPrint('测试网络请求的缓存功能:$message');
        // });
      },
    );
  }

  Widget _apilog_get_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试GET请求日志参数",
      textValue: '',
      onTap: () {
        AppNetworkKit.get(
          'config/check-version',
          params: {
            'version': '1.0.0', // 以防后台不从header中取
            'buildNumber': '1', // 以防后台不从header中取
            'platform': 'iOS', // 以防后台不从header中取
          },
        );
      },
    );
  }

  Widget _apiretry_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试请求的重试功能",
      textValue: '',
      onTap: () {
        int requestCount = 0;
        AppNetworkKit.postWithCallback(
          'login/doLogin',
          params: {
            "clientId": "clientApp",
            "clientSecret": "123123",
          },
          retryCount: 3,
          cacheLevel: AppNetworkCacheLevel.none,
          completeCallBack: (resultData) {
            requestCount++;
            debugPrint('测试网络请求的重试功能:当前重试次数$requestCount');
          },
        );
        // int requestCount = 0;
        // AppNetworkManager().cache_post(
        //   'login/doLogin',
        //   params: {
        //     "clientId": "clientApp",
        //     "clientSecret": "123123",
        //   },
        //   retryCount: 3,
        //   cacheLevel: AppNetworkCacheLevel.none,
        // )
        //     .then((ResponseModel responseModel) {
        //   requestCount++;
        //   debugPrint('测试网络请求的重试功能:当前重试次数$requestCount');
        // });
      },
    );
  }

  String get buriedpoint_messsageParam {
    // String messsageParam_demo = "[{\"Key\":\"\",\"Body\":{\"lib\":\"MiniProgram_app\"}},{\"Body\":{\"lib\":\"MiniProgram_app\"}}]";
    List<Map> messageMaps = [
      {
        // "Key": "",
        "Body": {
          "lib": "MiniProgram_app",
          "lib_method": "code",
        },
      },
      {
        // "Key": "",
        "Body": {
          "lib": "MiniProgram_app",
          "lib_method": "code",
        }
      },
    ];
    String messageParam = FormatterUtil.convert(messageMaps, 0);
    return messageParam;
  }

  Widget _api_buriedpoint_cell(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试埋点请求接口--底层网络库",
      textValue: '',
      onTap: () async {
        String buriedpoint_url = 'http://test.api.xihuanwu.com/bi/sendMessage';
        Map<String, dynamic> buriedpoint_customParams = {
          "DataHubId": "datahub-y32g29n6",
          // "Message": "[{\"Key\":\"\",\"Body\":{\"lib\":\"MiniProgram_app\"}},{\"Body\":{\"lib\":\"MiniProgram_app\"}}]",
          "Message": buriedpoint_messsageParam,
        };

        Options options = Options(
          contentType: "application/x-www-form-urlencoded",
        );

        CancelToken cancelToken = CancelToken();
        Dio dio = Dio();
        try {
          Response response = await dio.post(
            buriedpoint_url,
            data: buriedpoint_customParams,
            options: options,
            cancelToken: cancelToken,
          );

          Map responseObject = response.data;
          print("埋点请求测试结果:${responseObject.toString()}");
        } catch (e) {
          String errorMessage = e.toString();

          String message = '请求${buriedpoint_url}的时候，发生网络错误:$errorMessage';
          // throw Exception(message);
          return null;
        }
      },
    );
  }

  Widget _api_buriedpoint_cell2(BuildContext context) {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "网络库：测试埋点请求接口--二次封装库",
      textValue: '',
      onTap: () async {
        AppNetworkKit.postMonitorMessage(buriedpoint_messsageParam)
            .then((ResponseModel responseModel) {
          print("埋点请求测试结果:${responseModel.toString()}");
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

  Widget _devtool_logTest_cell() {
    if (!_isDebug()) {
      return Container();
    }
    return ImageTitleTextValueCell(
      title: "测试日志上报到企业微信",
      textValue: '',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return LogTestPage();
          },
        ));
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
