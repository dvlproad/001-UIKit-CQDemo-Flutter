import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:tsdemodemo_flutter/commonui/devtool/section_table_view_method2.dart';

import 'package:tsdemodemo_flutter/commonui/devtool/evvironment_header.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_network_cell.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_proxy_cell.dart';

import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_change_notifiter.dart';

import 'package:tsdemodemo_flutter/commonui/devtool/environment_data_bean.dart';

class TSEnvironmentList extends StatefulWidget {
  final TSEnvironmentModel totalEnvModels;
  final TSEnvNetworkModel selectedNetworkModel;
  final TSEnvProxyModel selectedProxyModel;

  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击
  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  TSEnvironmentList({
    Key key,
    @required this.totalEnvModels,
    @required this.selectedNetworkModel,
    @required this.selectedProxyModel,
    @required this.clickEnvNetworkCellCallback,
    @required this.clickEnvProxyCellCallback,
  }) : super(key: key);

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
    _totalEnvModels = widget.totalEnvModels;

    List<TSEnvNetworkModel> networkModels = _totalEnvModels.networkModels;
    for (int i = 0; i < networkModels.length; i++) {
      TSEnvNetworkModel networkModel = networkModels[i];
      if (networkModel.envId == widget.selectedNetworkModel.envId) {
        networkModel.check = true;
        _oldSelectedNetworkModel = networkModel;
      } else {
        networkModel.check = false;
      }
    }
    assert(_oldSelectedNetworkModel != null);

    List<TSEnvProxyModel> proxyModels = _totalEnvModels.proxyModels;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == widget.selectedProxyModel.proxyId) {
        proxyModel.check = true;
        _oldSelectedProxyModel = proxyModel;
      } else {
        proxyModel.check = false;
      }
    }
    assert(_oldSelectedProxyModel != null);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ChangeNotifierProvider<EnvironmentChangeNotifier>.value(
        value: _environmentChangeNotifier,
        child: _pageWidget(),
      ),
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
            builder: (context, environmentChangeNotifier, child) {
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
          return EnvironmentTableViewHeader(
              title: _totalEnvModels.networkTitle);
        } else {
          return EnvironmentTableViewHeader(title: _totalEnvModels.proxyTitle);
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
                (int section, int row, TSEnvNetworkModel bNetworkModel) {
              // print('点击切换 Network 环境');
              if (bNetworkModel == _oldSelectedNetworkModel) {
                return;
              }
              bNetworkModel.check = !bNetworkModel.check;
              _oldSelectedNetworkModel.check = !_oldSelectedNetworkModel.check;

              _oldSelectedNetworkModel = bNetworkModel;
              setState(() {});

              if (widget.clickEnvNetworkCellCallback != null) {
                widget.clickEnvNetworkCellCallback(section, row, bNetworkModel);
              }
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
              // print('点击切换 Proxy 环境');

              if (bProxyModel == _oldSelectedProxyModel) {
                return;
              }
              bProxyModel.check = !bProxyModel.check;
              _oldSelectedProxyModel.check = !_oldSelectedProxyModel.check;

              _oldSelectedProxyModel = bProxyModel;
              setState(() {});

              if (widget.clickEnvProxyCellCallback != null) {
                widget.clickEnvProxyCellCallback(section, row, bProxyModel);
              }
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
