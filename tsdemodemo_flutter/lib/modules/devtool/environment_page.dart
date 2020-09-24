import 'package:cj_monitor_flutter/cj_monitor_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_environment/flutter_environment.dart';

class TSEnvironmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSEnvironmentPageState();
  }
}

class _TSEnvironmentPageState extends State<TSEnvironmentPage> {
  TSEnvironmentModel _totalEnvModels;
  TSEnvNetworkModel _selectedNetworkModel;
  TSEnvProxyModel _selectedProxyModel;

  @override
  void initState() {
    super.initState();
    _totalEnvModels = EnvironmentManager().environmentModel;
    _selectedNetworkModel = EnvironmentManager().selectedNetworkModel;
    _selectedProxyModel = EnvironmentManager().selectedProxyModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _pageWidget(),
    );
  }

  Future<void> showLogWindow() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      await CjMonitorFlutter.showLogSuspendWindow;
    } on PlatformException {}
    if (!mounted) return;
  }

  Widget _appBar() {
    return AppBar(
      title: Text('切换环境'),
    );
  }

  Widget _pageWidget() {
    return TSEnvironmentList(
      totalEnvModels: _totalEnvModels,
      selectedNetworkModel: _selectedNetworkModel,
      selectedProxyModel: _selectedProxyModel,
      clickEnvNetworkCellCallback: (section, row, bNetworkModel) {
        print('点击了${bNetworkModel.name}');
        EnvironmentManager()
            .updateEnvSelectedModel(selectedNetworkModel: bNetworkModel);
        // 调用 网络域名 的更改接口
        // Service().changeOptions(baseUrl: bNetworkModel.hostName);
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel) {
        print('点击了${bProxyModel.name}');
        EnvironmentManager()
            .updateEnvSelectedModel(selectedProxyModel: bProxyModel);
        this.showLogWindow();
      },
    );
  }
}
