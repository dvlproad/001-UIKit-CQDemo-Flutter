import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_reuse_view/flutter_reuse_view.dart';

import './components/evvironment_header.dart';
import './components/environment_network_cell.dart';

import './environment_change_notifiter.dart';
import './network_page_data_bean.dart';

class NetworkList extends StatefulWidget {
  final String? networkTitle;
  final List<TSEnvNetworkModel> networkModels;

  final TSEnvNetworkModel selectedNetworkModel;

  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击

  NetworkList({
    Key? key,
    this.networkTitle,
    required this.networkModels,
    required this.selectedNetworkModel,
    required this.clickEnvNetworkCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NetworkListState();
  }
}

class _NetworkListState extends State<NetworkList> {
  late List<TSEnvNetworkModel> _networkModels;

  NetworkEnvironmentChangeNotifier _environmentChangeNotifier =
      NetworkEnvironmentChangeNotifier();
  late TSEnvNetworkModel _oldSelectedNetworkModel;

  @override
  void initState() {
    super.initState();

    // getData();
  }

  void getData() {
    _networkModels = widget.networkModels;
    _oldSelectedNetworkModel = widget.selectedNetworkModel;

    for (int i = 0; i < _networkModels.length; i++) {
      TSEnvNetworkModel networkModel = _networkModels[i];
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
    return ChangeNotifierProvider<NetworkEnvironmentChangeNotifier>.value(
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
          Consumer<NetworkEnvironmentChangeNotifier>(
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
    // NetworkEnvironmentChangeNotifier notifier =
    //     Provider.of<NetworkEnvironmentChangeNotifier>(context); // 在其他组件中，才使用这种取法
    NetworkEnvironmentChangeNotifier notifier =
        _environmentChangeNotifier; // 在本组件中，使用此取法
    print('network envName = ${notifier.networkModel.name}');

    int sectionCount = 1;

    int numOfRowInSection(section) {
      if (section == 0) {
        List<TSEnvNetworkModel> dataModels = _networkModels;
        return dataModels.length;
      }
      return 0;
    }

    return SectionTableView(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return numOfRowInSection(section);
      },
      headerInSection: (section) {
        if (section == 0) {
          return EnvironmentTableViewHeader(title: widget.networkTitle ?? '');
        } else {
          return Container();
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
            clickEnvNetworkCellCallback: ({
              int? section,
              int? row,
              required TSEnvNetworkModel bNetworkModel,
              bool? isLongPress,
            }) {
              // print('点击切换 Network 环境');
              if (bNetworkModel == _oldSelectedNetworkModel) {
                return;
              }

              // setState(() {}); // 请在外部执行
              // notifier.searchTextChange(bNetworkModel.envId);

              widget.clickEnvNetworkCellCallback(
                section: section,
                row: row,
                bNetworkModel: bNetworkModel,
                isLongPress: isLongPress,
              );
            },
          );
        } else {
          return Container();
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
