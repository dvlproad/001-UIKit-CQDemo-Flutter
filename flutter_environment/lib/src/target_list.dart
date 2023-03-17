import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_baseui_kit/flutter_baseui_kit.dart'
    show CreateSectionTableView2, IndexPath;

import './components/evvironment_header.dart';
import './components/environment_target_cell.dart';

import './environment_change_notifiter.dart';
import './data_target/packageType_page_data_bean.dart';

class TargetList extends StatefulWidget {
  final String? networkTitle;
  final List<PackageTargetModel> targetModels;

  final PackageTargetModel selectedTargetModel;

  final ClickEnvTargetCellCallback
      clickEnvTargetCellCallback; // 网络 networkCell 的点击

  TargetList({
    Key? key,
    this.networkTitle,
    required this.targetModels,
    required this.selectedTargetModel,
    required this.clickEnvTargetCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TargetListState();
  }
}

class _TargetListState extends State<TargetList> {
  late List<PackageTargetModel> _targetModels;

  TargetEnvironmentChangeNotifier _environmentChangeNotifier =
      TargetEnvironmentChangeNotifier();
  late PackageTargetModel _oldSelectedTargetModel;

  @override
  void initState() {
    super.initState();

    // getData();
  }

  void getData() {
    _targetModels = widget.targetModels;
    _oldSelectedTargetModel = widget.selectedTargetModel;

    for (int i = 0; i < _targetModels.length; i++) {
      PackageTargetModel targetModel = _targetModels[i];
      if (targetModel.envId == _oldSelectedTargetModel.envId) {
        targetModel.check = true;
        _oldSelectedTargetModel = targetModel;
      } else {
        targetModel.check = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return ChangeNotifierProvider<TargetEnvironmentChangeNotifier>.value(
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
          Consumer<TargetEnvironmentChangeNotifier>(
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
    // TargetEnvironmentChangeNotifier notifier =
    //     Provider.of<TargetEnvironmentChangeNotifier>(context); // 在其他组件中，才使用这种取法
    TargetEnvironmentChangeNotifier notifier =
        _environmentChangeNotifier; // 在本组件中，使用此取法
    print('target envName = ${notifier.targetModel.name}');

    int sectionCount = 1;

    int numOfRowInSection(section) {
      if (section == 0) {
        List<PackageTargetModel> dataModels = _targetModels;
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
          return Container();
        }
      },
      cellAtIndexPath: (section, row) {
        if (section == 0) {
          // Target 环境
          List<dynamic> dataModels = _targetModels;
          PackageTargetModel dataModel = dataModels[row] as PackageTargetModel;
          return EnvTargetTableViewCell(
            envModel: dataModel,
            section: section,
            row: row,
            clickEnvTargetCellCallback: ({
              int? section,
              int? row,
              required PackageTargetModel bTargetModel,
              bool? isLongPress,
            }) {
              // print('点击切换 Target 环境');
              if (bTargetModel == _oldSelectedTargetModel) {
                return;
              }

              // setState(() {}); // 请在外部执行
              // notifier.searchTextChange(bTargetModel.envId);

              if (widget.clickEnvTargetCellCallback != null) {
                widget.clickEnvTargetCellCallback(
                  section: section,
                  row: row,
                  bTargetModel: bTargetModel,
                  isLongPress: isLongPress,
                );
              }
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
