import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './components/evvironment_header.dart';
import './components/environment_network_cell.dart';
import './components/environment_proxy_cell.dart';

import './environment_change_notifiter.dart';
import './environment_data_bean.dart';

class TSEnvironmentList extends StatefulWidget {
  final String networkTitle;
  final List<TSEnvNetworkModel> networkModels;
  final String proxyTitle;
  final List<TSEnvProxyModel> proxyModels;
  final TSEnvNetworkModel selectedNetworkModel;
  final TSEnvProxyModel selectedProxyModel;

  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击
  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  TSEnvironmentList({
    Key key,
    this.networkTitle,
    @required this.networkModels,
    this.proxyTitle,
    @required this.proxyModels,
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
  List<TSEnvNetworkModel> _networkModels;
  List<TSEnvProxyModel> _proxyModels;
  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();
  TSEnvNetworkModel _oldSelectedNetworkModel;
  TSEnvProxyModel _oldSelectedProxyModel;

  @override
  void initState() {
    super.initState();

    // getData();
  }

  void getData() {
    _networkModels = widget.networkModels ?? [];
    _proxyModels = widget.proxyModels ?? [];
    _oldSelectedNetworkModel = widget.selectedNetworkModel;
    _oldSelectedProxyModel = widget.selectedProxyModel;

    List<TSEnvNetworkModel> networkModels = _networkModels;
    for (int i = 0; i < networkModels.length; i++) {
      TSEnvNetworkModel networkModel = networkModels[i];
      if (networkModel.envId == _oldSelectedNetworkModel.envId) {
        networkModel.check = true;
        _oldSelectedNetworkModel = networkModel;
      } else {
        networkModel.check = false;
      }
    }

    List<TSEnvProxyModel> proxyModels = _proxyModels;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == _oldSelectedProxyModel.proxyId) {
        proxyModel.check = true;
        _oldSelectedProxyModel = proxyModel;
      } else {
        proxyModel.check = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return ChangeNotifierProvider<EnvironmentChangeNotifier>.value(
      value: _environmentChangeNotifier,
      child: _pageWidget(),
    );
  }

  Widget _pageWidget() {
    return Container(
      constraints: BoxConstraints(
        minWidth: double.infinity,
        minHeight: double.infinity,
      ),
      color: Colors.white,
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
    // EnvironmentChangeNotifier notifier =
    //     Provider.of<EnvironmentChangeNotifier>(context); // 在其他组件中，才使用这种取法
    EnvironmentChangeNotifier notifier =
        _environmentChangeNotifier; // 在本组件中，使用此取法
    print('searchText = ${notifier.searchText}');

    int sectionCount = 2;

    int numOfRowInSection(section) {
      if (section == 0) {
        List dataModels = _networkModels;
        return dataModels.length;
      } else if (section == 1) {
        List dataModels = _proxyModels;
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
          return EnvironmentTableViewHeader(title: widget.networkTitle ?? '');
        } else {
          return EnvironmentTableViewHeader(title: widget.proxyTitle ?? '');
        }
      },
      cellAtIndexPath: (section, row) {
        if (section == 0) {
          // Network 环境
          List<dynamic> dataModels = _networkModels;
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

              // setState(() {}); // 请在外部执行
              // notifier.searchTextChange(bNetworkModel.envId);

              if (widget.clickEnvNetworkCellCallback != null) {
                widget.clickEnvNetworkCellCallback(section, row, bNetworkModel);
              }
            },
          );
        } else {
          // Proxy 环境
          List<TSEnvProxyModel> dataModels = _proxyModels;
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
              // setState(() {}); // 请在外部执行

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
