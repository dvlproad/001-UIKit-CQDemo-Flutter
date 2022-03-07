import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './components/evvironment_header.dart';
import './components/environment_network_cell.dart';

import './environment_change_notifiter.dart';
import './network_page_data_bean.dart';

class NetworkList extends StatefulWidget {
  final String networkTitle;
  final List<TSEnvNetworkModel> networkModels;

  final TSEnvNetworkModel selectedNetworkModel;

  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击

  NetworkList({
    Key key,
    this.networkTitle,
    @required this.networkModels,
    @required this.selectedNetworkModel,
    @required this.clickEnvNetworkCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NetworkListState();
  }
}

class _NetworkListState extends State<NetworkList> {
  List<TSEnvNetworkModel> _networkModels;

  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();
  TSEnvNetworkModel _oldSelectedNetworkModel;

  @override
  void initState() {
    super.initState();

    // getData();
  }

  void getData() {
    _networkModels = widget.networkModels ?? [];

    _oldSelectedNetworkModel = widget.selectedNetworkModel;

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
    print('envName = ${notifier.networkModel?.name}');

    int sectionCount = 1;

    int numOfRowInSection(section) {
      if (section == 0) {
        List dataModels = _networkModels;
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

              // setState(() {}); // 请在外部执行
              // notifier.searchTextChange(bNetworkModel.envId);

              if (widget.clickEnvNetworkCellCallback != null) {
                widget.clickEnvNetworkCellCallback(section, row, bNetworkModel);
              }
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
