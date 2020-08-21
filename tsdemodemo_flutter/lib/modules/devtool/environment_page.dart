import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_data_bean.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_list.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_datas_util.dart';

class TSEnvironmentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSEnvironmentPageState();
  }
}

class _TSEnvironmentPageState extends State<TSEnvironmentPage> {
  TSEnvironmentModel _totalEnvModels;
  String _selectedNetworkId;
  String _selectedProxyId;

  @override
  void initState() {
    super.initState();
    _totalEnvModels = TSEnvironmentDataUtil.getEnvironmentModel();
    _selectedNetworkId = TSEnvironmentDataUtil.developNetworkId;
    _selectedProxyId = TSEnvironmentDataUtil.noneProxykId;
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

  Widget _appBar() {
    return AppBar(
      title: Text('Environment 模块'),
    );
  }

  Widget _pageWidget() {
    return TSEnvironmentList(
      totalEnvModels: _totalEnvModels,
      selectedNetworkId: _selectedNetworkId,
      selectedProxyId: _selectedProxyId,
      clickEnvNetworkCellCallback: (section, row, bNetworkModel) {
        print('点击了${bNetworkModel.name}');
      },
      clickEnvProxyCellCallback: (section, row, bProxyModel) {
        print('点击了${bProxyModel.name}');
      },
    );
  }
}
