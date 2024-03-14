import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/tableview/flutter_section_table_view.dart';
import 'package:provider/provider.dart';

import './components/evvironment_header.dart';
import './components/environment_proxy_cell.dart';

import './environment_change_notifiter.dart';
import './proxy_page_data_bean.dart';

class ProxyList extends StatefulWidget {
  final String? proxyTitle;
  final List<TSEnvProxyModel> proxyModels;
  final TSEnvProxyModel? selectedProxyModel;

  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  ProxyList({
    Key? key,
    this.proxyTitle,
    required this.proxyModels,
    this.selectedProxyModel,
    required this.clickEnvProxyCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ProxyListState();
  }
}

class _ProxyListState extends State<ProxyList> {
  late List<TSEnvProxyModel> _proxyModels;
  ProxyEnvironmentChangeNotifier _environmentChangeNotifier =
      ProxyEnvironmentChangeNotifier();
  late TSEnvProxyModel? _oldSelectedProxyModel;

  @override
  void initState() {
    super.initState();
  }

  void getData() {
    _proxyModels = widget.proxyModels;
    _oldSelectedProxyModel = widget.selectedProxyModel;

    List<TSEnvProxyModel> proxyModels = _proxyModels;
    for (int i = 0; i < proxyModels.length; i++) {
      TSEnvProxyModel proxyModel = proxyModels[i];
      if (proxyModel.proxyId == _oldSelectedProxyModel?.proxyId) {
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

    return ChangeNotifierProvider<ProxyEnvironmentChangeNotifier>.value(
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
          Consumer<ProxyEnvironmentChangeNotifier>(
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
    // ProxyEnvironmentChangeNotifier notifier =
    //     Provider.of<ProxyEnvironmentChangeNotifier>(context); // 在其他组件中，才使用这种取法
    ProxyEnvironmentChangeNotifier notifier =
        _environmentChangeNotifier; // 在本组件中，使用此取法
    print('proxy envName = ${notifier.proxyModel.name}');

    int sectionCount = 1;

    int numOfRowInSection(section) {
      if (section == 0) {
        List dataModels = _proxyModels;
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
          return EnvironmentTableViewHeader(title: widget.proxyTitle ?? '');
        } else {
          return Container();
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
              bool? isLongPress,
            }) {
              // print('点击切换 Proxy 环境');

              // setState(() {}); // 请在外部执行

              widget.clickEnvProxyCellCallback(section, row, bProxyModel,
                  isLongPress: isLongPress);
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
