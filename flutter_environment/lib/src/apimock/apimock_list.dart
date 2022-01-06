import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../section_table_view_method2.dart';
import '../components/evvironment_header.dart';
import '../components/environment_network_cell.dart';
import './apimock_cell.dart';

import '../environment_change_notifiter.dart';
import './manager/api_data_bean.dart';

class TSApiList extends StatefulWidget {
  final List apiMockModels;
  final ClickApiMockCellCallback clickApiMockCellCallback; // apimockCell 的点击

  TSApiList({
    Key key,
    @required this.apiMockModels,
    @required this.clickApiMockCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TSApiListState();
  }
}

class _TSApiListState extends State<TSApiList> {
  List<ApiModel> _apiMockModels_normal = [];
  List<ApiModel> _apiMockModels_selected = [];
  EnvironmentChangeNotifier _environmentChangeNotifier =
      EnvironmentChangeNotifier();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _apiMockModels_normal = [];
    _apiMockModels_selected = [];
    for (ApiModel apiModel in widget.apiMockModels) {
      if (apiModel.mock) {
        _apiMockModels_selected.add(apiModel);
      } else {
        _apiMockModels_normal.add(apiModel);
      }
    }

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
      color: Colors.transparent,
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
    int sectionCount = 2;

    int numOfRowInSection(section) {
      if (section == 0) {
        List dataModels = _apiMockModels_selected;
        return dataModels.length;
      } else if (section == 1) {
        List dataModels = _apiMockModels_normal;
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
          return EnvironmentTableViewHeader(title: '之前已mock');
        } else {
          return EnvironmentTableViewHeader(title: '其他');
        }
      },
      cellAtIndexPath: (section, row) {
        if (section == 0) {
          // Network 环境
          List<ApiModel> dataModels = _apiMockModels_selected;
          ApiModel dataModel = dataModels[row];
          return ApiMockTableViewCell(
            apiModel: dataModel,
            section: section,
            row: row,
            clickApiMockCellCallback:
                (int section, int row, ApiModel bApiModel) {
              // print('点击切换 Proxy 环境');

              bApiModel.mock = !bApiModel.mock;
              setState(() {});

              if (widget.clickApiMockCellCallback != null) {
                widget.clickApiMockCellCallback(section, row, bApiModel);
              }
            },
          );
        } else {
          // Proxy 环境
          List<ApiModel> dataModels = _apiMockModels_normal;
          ApiModel dataModel = dataModels[row];
          return ApiMockTableViewCell(
            apiModel: dataModel,
            section: section,
            row: row,
            clickApiMockCellCallback:
                (int section, int row, ApiModel bApiModel) {
              // print('点击切换 Proxy 环境');

              bApiModel.mock = !bApiModel.mock;
              setState(() {});

              if (widget.clickApiMockCellCallback != null) {
                widget.clickApiMockCellCallback(section, row, bApiModel);
              }
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
