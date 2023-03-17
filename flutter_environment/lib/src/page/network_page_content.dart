import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../network_page_data_manager.dart';
import '../network_page_data_bean.dart';

import '../network_list.dart';

import 'package:provider/provider.dart';
import '../environment_change_notifiter.dart';
export '../environment_change_notifiter.dart';

import '../environment_util.dart';

class NetworkPageContent extends StatefulWidget {
  final String? currentProxyIp;
  final Function()? onPressTestApiCallback;
  final Function(
    TSEnvNetworkModel bNetworkModel, {
    required bool shouldExit, // 切换环境的时候，是否要退出app(如果已登录,重启后是否要重新登录)
  }) updateNetworkCallback;

  NetworkPageContent({
    Key? key,
    this.currentProxyIp,
    this.onPressTestApiCallback, // 为空时候，不显示视图
    required this.updateNetworkCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NetworkPageContentState();
  }
}

class _NetworkPageContentState extends State<NetworkPageContent> {
  String networkTitle = "网络环境";
  late List<TSEnvNetworkModel> _networkModels;
  late TSEnvNetworkModel _selectedNetworkModel;
  String? _currentProxyIp;

  @override
  void initState() {
    super.initState();

    if (NetworkPageDataManager().networkModels == null ||
        NetworkPageDataManager().networkModels.isEmpty) {
      print(
          'error:请在 main_init.dart 中 执行 EnvironmentUtil.completeEnvInternal_whenNull();');
    }
    _networkModels = NetworkPageDataManager().networkModels;
    _selectedNetworkModel = NetworkPageDataManager().selectedNetworkModel;

    _currentProxyIp = widget.currentProxyIp;
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

  PreferredSizeWidget _appBar() {
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
          Text(
            '当前代理环境:$_currentProxyIp',
            textAlign: TextAlign.start,
            style: TextStyle(color: Colors.red),
          ),
          Expanded(
            child: _pageWidget(),
          ),
          widget.onPressTestApiCallback == null
              ? Container()
              : BottomButtonsWidget(
                  cancelText: '测试请求',
                  onCancel: () {
                    print('测试请求');
                    widget.onPressTestApiCallback!();
                  },
                ),
          _bottomAddProxyWidget,
        ],
      ),
    );
  }

  Widget get _bottomAddProxyWidget {
    return BottomButtonsWidget(
      cancelText: '添加/修改环境(无)',
      onCancel: () {
        print('添加/修改环境');
      },
    );
  }

  Widget _pageWidget() {
    return NetworkList(
      networkTitle: networkTitle,
      networkModels: _networkModels,
      selectedNetworkModel: _selectedNetworkModel,
      clickEnvNetworkCellCallback: ({
        int? section,
        int? row,
        required bNetworkModel,
        bool? isLongPress,
      }) {
        print('点击了${bNetworkModel.name}');

        if (isLongPress == true) {
        } else {
          _tryUpdateToNetworkModel(bNetworkModel);
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
      shouldExit = EnvironmentUtil.shouldExitWhenChangeNetworkEnv!(
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
    bool shouldExit = true,
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
}
