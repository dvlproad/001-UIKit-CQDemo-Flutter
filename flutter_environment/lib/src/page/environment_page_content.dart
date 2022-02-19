import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../environment_manager.dart';
import '../environment_data_bean.dart';

import '../environment_list.dart';

import 'package:provider/provider.dart';
import '../environment_change_notifiter.dart';
export '../environment_change_notifiter.dart';

import '../environment_util.dart';

class EnvironmentPageContent extends StatefulWidget {
  final Function() onPressTestApiCallback;
  final Function(
    String apiHost,
    String webHost,
    String gameHost, {
    bool shouldExit, // 切换环境的时候，是否要退出app(如果已登录,重启后是否要重新登录)
  }) updateNetworkCallback;
  final Function(String proxyIp) updateProxyCallback;

  EnvironmentPageContent({
    Key key,
    this.onPressTestApiCallback, // 为空时候，不显示视图
    @required this.updateNetworkCallback,
    @required this.updateProxyCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnvironmentPageContentState();
  }
}

class _EnvironmentPageContentState extends State<EnvironmentPageContent> {
  String networkTitle = "网络环境";
  List<TSEnvNetworkModel> _networkModels;

  String proxyTitle = "网络代理(点击可切换,长按可修改)";
  List<TSEnvProxyModel> _proxyModels;

  TSEnvNetworkModel _selectedNetworkModel;
  TSEnvProxyModel _selectedProxyModel;

  @override
  void initState() {
    super.initState();

    if (EnvironmentManager().networkModels == null ||
        EnvironmentManager().networkModels.isEmpty) {
      print(
          'error:请在 main_init.dart 中 执行 EnvironmentUtil.completeEnvInternal_whenNull();');
    }
    _networkModels = EnvironmentManager().networkModels;
    _proxyModels = EnvironmentManager().proxyModels;
    _selectedNetworkModel = EnvironmentManager().selectedNetworkModel;
    _selectedProxyModel = EnvironmentManager().selectedProxyModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _bodyWidget,
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('切换环境'),
    );
  }

  Future<void> showLogWindow() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      // await CjMonitorFlutter.showLogSuspendWindow;
    } on PlatformException {}
    if (!mounted) return;
  }

  Widget get _bodyWidget {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 触摸收起键盘
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Column(
        children: [
          Expanded(
            child: _pageWidget(),
          ),
          widget.onPressTestApiCallback == null
              ? Container()
              : BottomButtonsWidget(
                  cancelText: '测试请求',
                  onCancel: () {
                    print('测试请求');
                    widget.onPressTestApiCallback();
                  },
                ),
          _bottomAddProxyWidget,
        ],
      ),
    );
  }

  Widget get _bottomAddProxyWidget {
    return BottomButtonsWidget(
      cancelText: '添加/修改代理',
      onCancel: () {
        print('添加/修改代理');
        _addOrUpdateCustomEnvProxyIp();
      },
    );
  }

  void _addOrUpdateCustomEnvProxyIp() {
    EnvironmentAddUtil.showAddPage(
      context,
      proxyIp: null,
      addCompleteBlock: (bProxyIp) {
        print('proxyIp =$bProxyIp');
        EnvironmentManager().addOrUpdateCustomEnvProxyIp(
          proxyIp: bProxyIp,
        );

        setState(() {});
      },
    );
  }

  void _tryUpdateProxyModel(TSEnvProxyModel bProxyModel) {
    EnvironmentAddUtil.showAddPage(
      context,
      proxyIp: bProxyModel.proxyIp,
      addCompleteBlock: (bProxyIp) {
        print('proxyIp =$bProxyIp');

        bProxyModel.proxyIp = bProxyIp;
        EnvironmentManager().addOrUpdateEnvProxyModel(
          newProxyModel: bProxyModel,
        );

        setState(() {});
      },
    );
  }

  Widget _pageWidget() {
    return TSEnvironmentList(
      networkTitle: networkTitle,
      networkModels: _networkModels,
      proxyTitle: proxyTitle,
      proxyModels: _proxyModels,
      selectedNetworkModel: _selectedNetworkModel,
      selectedProxyModel: _selectedProxyModel,
      clickEnvNetworkCellCallback: (section, row, bNetworkModel,
          {isLongPress}) {
        print('点击了${bNetworkModel.name}');
        _tryUpdateToNetworkModel(bNetworkModel);
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel, {isLongPress}) {
        print('点击了${bProxyModel.name}');
        if (isLongPress == true) {
          if (bProxyModel.proxyId == TSEnvProxyModel.noneProxykId) {
            return;
          }
          _tryUpdateProxyModel(bProxyModel);
        } else {
          if (bProxyModel == _selectedProxyModel) {
            return;
          }
          _tryUpdateToProxyModel(bProxyModel);
        }
      },
    );
  }

  /// 尝试切换环境
  void _tryUpdateToNetworkModel(TSEnvNetworkModel bNetworkModel) {
    String oldNetwork = _selectedNetworkModel.name;
    String newNetwork = bNetworkModel.name;

    bool shouldExit = true;
    if (EnvironmentUtil.shouldExitWhenChangeNetworkEnv != null) {
      shouldExit = EnvironmentUtil.shouldExitWhenChangeNetworkEnv(
          _selectedNetworkModel, bNetworkModel);
    }
    String message;
    if (shouldExit) {
      message = '温馨提示:如确认切换,则将自动关闭app.(且如果已登录则重启后需要重新登录)';
    } else {
      message = '温馨提示:切换到该环境，您已设置为不退出app也不重新登录';
    }

    AlertUtil.showCancelOKAlert(
      context: context,
      title: '切换到"$newNetwork"',
      message: message,
      okHandle: () {
        _confirmUpdateToNetworkModel(bNetworkModel, shouldExit: shouldExit);
      },
    );
  }

  /// 确认切换环境
  void _confirmUpdateToNetworkModel(
    TSEnvNetworkModel bNetworkModel, {
    bool shouldExit,
  }) {
    _selectedNetworkModel = bNetworkModel;
    EnvironmentManager()
        .updateEnvSelectedModel(selectedNetworkModel: bNetworkModel);
    // 调用 网络域名 的更改接口
    // Service().changeOptions(baseUrl: bNetworkModel.hostName);
    setState(() {});

    if (widget.updateNetworkCallback != null) {
      widget.updateNetworkCallback(
        bNetworkModel.apiHost,
        bNetworkModel.webHost,
        bNetworkModel.gameHost,
        shouldExit: shouldExit,
      );
    }

    if (shouldExit == true) {
      Future.delayed(const Duration(milliseconds: 500), () {
        // [Flutter如何有效地退出程序](https://zhuanlan.zhihu.com/p/191052343)
        exit(0); // 需要 import 'dart:io';
        // SystemNavigator
        //     .pop(); // 该方法在iOS中并不适用。需要  import 'package:flutter/services.dart';
      });
    }
  }

  /// 确认切换代理
  void _tryUpdateToProxyModel(TSEnvProxyModel bProxyModel) {
    String oldProxy = _selectedProxyModel.name;
    String newProxy = bProxyModel.name;

    String message = '';
    if (bProxyModel.proxyId == TSEnvProxyModel.noneProxykId) {
      message = '温馨提示:你将切换为不使用代理';
    } else {
      message = '温馨提示:你将切换为使用代理，请确认该代理正常，否则所有接口都将失败';
    }
    AlertUtil.showCancelOKAlert(
      context: context,
      title: '使用"$newProxy"',
      message: message,
      okHandle: () {
        _confirmUpdateToProxyModel(bProxyModel);
      },
    );
  }

  /// 确认切换代理
  void _confirmUpdateToProxyModel(TSEnvProxyModel bProxyModel) {
    _selectedProxyModel = bProxyModel;
    EnvironmentManager()
        .updateEnvSelectedModel(selectedProxyModel: bProxyModel);
    this.showLogWindow();
    setState(() {});

    if (widget.updateProxyCallback != null) {
      widget.updateProxyCallback(bProxyModel.proxyIp);
    }
  }
}
