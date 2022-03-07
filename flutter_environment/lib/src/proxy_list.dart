import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './components/evvironment_header.dart';
import './components/environment_proxy_cell.dart';

import './environment_change_notifiter.dart';
import './proxy_page_data_bean.dart';

class ProxyList extends StatefulWidget {
  final String proxyTitle;
  final List<TSEnvProxyModel> proxyModels;
  final TSEnvProxyModel selectedProxyModel;

  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  ProxyList({
    Key key,
    this.proxyTitle,
    @required this.proxyModels,
    @required this.selectedProxyModel,
    @required this.clickEnvProxyCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProxyListState();
  }
}

class _ProxyListState extends State<ProxyList> {
  List<TSEnvProxyModel> _proxyModels;
  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();
  TSEnvProxyModel _oldSelectedProxyModel;

  @override
  void initState() {
    super.initState();

    // getData();
  }

  void getData() {
    _proxyModels = widget.proxyModels ?? [];
    _oldSelectedProxyModel = widget.selectedProxyModel;

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
    print('envName = ${notifier.networkModel?.name}');

    int sectionCount = 1;

    int numOfRowInSection(section) {
      if (section == 0) {
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
          return EnvironmentTableViewHeader(title: widget.proxyTitle ?? '');
        }
      },
      cellAtIndexPath: (section, row) {
        if (section == 0) {
          // Proxy 环境
          List<TSEnvProxyModel> dataModels = _proxyModels;
          TSEnvProxyModel dataModel = dataModels[row];
          return EnvProxyTableViewCell(
            proxyModel: dataModel,
            section: section,
            row: row,
            clickEnvProxyCellCallback: (
              int section,
              int row,
              TSEnvProxyModel bProxyModel, {
              bool isLongPress,
            }) {
              // print('点击切换 Proxy 环境');

              // setState(() {}); // 请在外部执行

              if (widget.clickEnvProxyCellCallback != null) {
                widget.clickEnvProxyCellCallback(section, row, bProxyModel,
                    isLongPress: isLongPress);
              }
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
