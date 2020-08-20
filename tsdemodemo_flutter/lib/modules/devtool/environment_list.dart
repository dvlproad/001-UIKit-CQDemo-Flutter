import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSTableViewHeader.dart';
import 'package:tsdemodemo_flutter/commonui/cq-list/section_table_view_method2.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_network_cell.dart';

import 'package:tsdemodemo_flutter/modules/devtool/environment_change_notifiter.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_datas_util.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_data_bean.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_proxy_cell.dart';

class TSEnvironmentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TSEnvironmentListState();
  }
}

class _TSEnvironmentListState extends State<TSEnvironmentList> {
  TSEnvironmentModel _totalEnvModels;
  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();
  TSEnvNetworkModel _oldSelectedNetworkModel;
  TSEnvProxyModel _oldSelectedProxyModel;

  @override
  void initState() {
    super.initState();
    _totalEnvModels = TSEnvironmentDataUtil.getEnvironmentModel();

    List<TSEnvNetworkModel> envModels = _totalEnvModels.networkModels;
    for (int i = 0; i < envModels.length; i++) {
      TSEnvNetworkModel envModel = envModels[i];
      if (envModel.envId == 'develop') {
        envModel.check = true;
        _oldSelectedNetworkModel = envModel;
      } else {
        envModel.check = false;
      }
    }

    List<TSEnvProxyModel> proxyModels = _totalEnvModels.proxyModels;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == 'develop') {
        proxyModel.check = true;
        _oldSelectedProxyModel = proxyModel;
      } else {
        proxyModel.check = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: ChangeNotifierProvider<EnvironmentChangeNotifier>.value(
        value: _environmentChangeNotifier,
        child: _pageWidget(),
      ),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('Environment 模块'),
    );
  }

  Widget _pageWidget() {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      color: Colors.black,
      child: Column(
        children: <Widget>[
          SizedBox(height: 6),
          Consumer<EnvironmentChangeNotifier>(
            builder: (context, _searchChangeNotifier, child) {
              return Expanded(
                child: _searchResultWidget(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _searchResultWidget() {
    int sectionCount = 0;
    if (_totalEnvModels.networkModels.length > 0) {
      sectionCount++;
    }
    if (_totalEnvModels.proxyModels.length > 0) {
      sectionCount++;
    }

    int numOfRowInSection(section) {
      if (section == 0) {
        List dataModels = _totalEnvModels.networkModels;
        return dataModels.length;
      } else if (section == 1) {
        List dataModels = _totalEnvModels.proxyModels;
        return dataModels.length;
      }
      return 0;
    }

    return CreateSectionTableView2(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return numOfRowInSection(section);
      },
      headerInSection: (section) {
        if (section == 0) {
          return CJTSTableViewHeader(title: _totalEnvModels.networkTitle);
        } else {
          return CJTSTableViewHeader(title: _totalEnvModels.proxyTitle);
        }
      },
      cellAtIndexPath: (section, row) {
        if (section == 0) {
          List<dynamic> dataModels = _totalEnvModels.networkModels;
          TSEnvNetworkModel dataModel = dataModels[row] as TSEnvNetworkModel;
          return EnvNetworkTableViewCell(
            envModel: dataModel,
            section: section,
            row: row,
            clickEnvNetworkCellCallback:
                (int section, int row, TSEnvNetworkModel bEnvModel) {
              print('点击 Network');
              if (bEnvModel == _oldSelectedNetworkModel) {
                return;
              }
              bEnvModel.check = !bEnvModel.check;
              _oldSelectedNetworkModel.check = !_oldSelectedNetworkModel.check;

              _oldSelectedNetworkModel = bEnvModel;
              setState(() {});
            },
          );
        } else {
          List<TSEnvProxyModel> dataModels = _totalEnvModels.proxyModels;
          TSEnvProxyModel dataModel = dataModels[row];
          return EnvProxyTableViewCell(
            proxyModel: dataModel,
            section: section,
            row: row,
            clickEnvProxyCellCallback:
                (int section, int row, TSEnvProxyModel bProxyModel) {
              print('点击 Proxy');

              if (bProxyModel == _oldSelectedProxyModel) {
                return;
              }
              bProxyModel.check = !bProxyModel.check;
              _oldSelectedProxyModel.check = !_oldSelectedProxyModel.check;

              _oldSelectedProxyModel = bProxyModel;
              setState(() {});
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
