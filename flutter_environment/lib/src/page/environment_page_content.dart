import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
// import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import './actionsheet_footer.dart';
import './environment_add_util.dart';

import '../environment_manager.dart';
import '../environment_data_bean.dart';

import '../environment_list.dart';

import 'package:provider/provider.dart';
import '../environment_change_notifiter.dart';

class EnvironmentPageContent extends StatefulWidget {
  final Function() onPressTestApiCallback;
  final Function(String apiHost, String webHost, String gameHost)
      updateNetworkCallback;
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

  String proxyTitle = "网络代理";
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

        EnvironmentAddUtil.showAddPage(
          context,
          addCompleteBlock: (bProxyIp) {
            print('proxyIp =$bProxyIp');
            EnvironmentManager().addEnvProxyModel(
              proxyIp: bProxyIp,
            );
            setState(() {});
          },
        );
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
      clickEnvNetworkCellCallback: (section, row, bNetworkModel) {
        print('点击了${bNetworkModel.name}');
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
          );
        }
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel) {
        print('点击了${bProxyModel.name}');
        _selectedProxyModel = bProxyModel;
        EnvironmentManager()
            .updateEnvSelectedModel(selectedProxyModel: bProxyModel);
        this.showLogWindow();
        setState(() {});

        if (widget.updateProxyCallback != null) {
          widget.updateProxyCallback(bProxyModel.proxyIp);
        }
      },
    );
  }
}
