import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../network_page_data_manager.dart';
import '../network_page_data_bean.dart';
import '../proxy_page_data_manager.dart';
import '../proxy_page_data_bean.dart';

import '../environment_list.dart';

import 'package:provider/provider.dart';
import '../environment_change_notifiter.dart';
export '../environment_change_notifiter.dart';

import '../environment_util.dart';

class EnvironmentPageContent extends StatefulWidget {
  final Function() onPressTestApiCallback;
  final Function(
    TSEnvNetworkModel bNetworkModel, {
    bool shouldExit, // 切换环境的时候，是否要退出app(如果已登录,重启后是否要重新登录)
  }) updateNetworkCallback;
  final Function(TSEnvProxyModel bProxyModel) updateProxyCallback;

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

    if (NetworkPageDataManager().networkModels == null ||
        NetworkPageDataManager().networkModels.isEmpty) {
      print(
          'error:请在 main_init.dart 中 执行 EnvironmentUtil.completeEnvInternal_whenNull();');
    }
    _networkModels = NetworkPageDataManager().networkModels;
    _proxyModels = ProxyPageDataManager().proxyModels;
    _selectedNetworkModel = NetworkPageDataManager().selectedNetworkModel;
    _selectedProxyModel = ProxyPageDataManager().selectedProxyModel;
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
    EnvironmentAddUtil.showAddOrUpdateProxyPage(
      context,
      proxyName: '自定义代理',
      proxyIp: null,
      addCompleteBlock: ({bProxyName, bProxyIp}) {
        print('proxyIp =$bProxyIp');
        ProxyPageDataManager().addOrUpdateCustomEnvProxyIp(
          proxyName: bProxyName,
          proxyIp: bProxyIp,
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

        if (isLongPress == true) {
        } else {
          _tryUpdateToNetworkModel(bNetworkModel);
        }
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel, {isLongPress}) {
        print('点击了${bProxyModel.name}');
        if (isLongPress == true) {
          if (bProxyModel.proxyId == TSEnvProxyModel.noneProxykId) {
            // 无代理不支持修改
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

  /// 尝试修改代理
  void _tryUpdateProxyModel(TSEnvProxyModel bProxyModel) {
    EnvironmentAddUtil.showAddOrUpdateProxyPage(
      context,
      proxyName: bProxyModel.name,
      proxyIp: bProxyModel.proxyIp,
      addCompleteBlock: ({bProxyName, bProxyIp}) {
        print('proxyName=$bProxyName, proxyIp =$bProxyIp');
        bProxyModel.name = bProxyName;
        bProxyModel.proxyIp = bProxyIp;
        ProxyPageDataManager().addOrUpdateEnvProxyModel(
          newProxyModel: bProxyModel,
        );

        setState(() {});
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

    if (widget.updateNetworkCallback != null) {
      widget.updateNetworkCallback(
        bNetworkModel,
        shouldExit: shouldExit,
      );
    }

    setState(() {});
  }

  /// 尝试切换代理
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

    if (widget.updateProxyCallback != null) {
      widget.updateProxyCallback(bProxyModel);
    }

    setState(() {});
  }
}
