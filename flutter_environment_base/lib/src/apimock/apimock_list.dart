/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-03-14 18:19:35
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/tableview/flutter_section_table_view.dart';
import 'package:provider/provider.dart';

import '../components/evvironment_header.dart';
import './apimock_cell.dart';

import './manager/apimock_change_notifiter.dart';
import './manager/api_data_bean.dart';

class TSApiList extends StatefulWidget {
  final String? mockApiHost;
  final String? normalApiHost;
  final List apiMockModels;
  final ClickApiMockCellCallback clickApiMockCellCallback; // apimockCell 的点击

  TSApiList({
    Key? key,
    this.mockApiHost, // mock 后该 api 请求的 host
    this.normalApiHost, // 正常 api 请求的 host
    required this.apiMockModels,
    required this.clickApiMockCellCallback,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TSApiListState();
  }
}

class _TSApiListState extends State<TSApiList> {
  List<ApiModel> _apiMockModels_normal = [];
  List<ApiModel> _apiMockModels_selected = [];
  ApiMockChangeNotifier _apimockChangeNotifier = ApiMockChangeNotifier();

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
      child: ChangeNotifierProvider<ApiMockChangeNotifier>.value(
        value: _apimockChangeNotifier,
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
          Consumer<ApiMockChangeNotifier>(
            builder: (context, apimockChangeNotifier, child) {
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

    return SectionTableView(
      sectionCount: sectionCount,
      numOfRowInSection: (section) {
        return numOfRowInSection(section);
      },
      headerInSection: (section) {
        if (section == 0) {
          String suffixString = '';
          if (widget.mockApiHost != null) {
            suffixString = ':\n${widget.mockApiHost}';
          }
          return EnvironmentTableViewHeader(title: '执行mock环境的api$suffixString');
        } else {
          String suffixString = '';
          if (widget.normalApiHost != null) {
            suffixString = ':\n${widget.normalApiHost}';
          }
          return EnvironmentTableViewHeader(
              title: '执行自身或当前环境的api$suffixString');
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
            clickApiMockCellCallback: ({
              int? section,
              int? row,
              required ApiModel bApiModel,
              bool? isLongPress,
            }) {
              // print('点击切换 Proxy 环境');
              // setState(() {}); // 请在外部执行

              widget.clickApiMockCellCallback(
                section: section,
                row: row,
                bApiModel: bApiModel,
                isLongPress: isLongPress,
              );
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
            clickApiMockCellCallback: ({
              int? section,
              int? row,
              required ApiModel bApiModel,
              bool? isLongPress,
            }) {
              // print('点击切换 Proxy 环境');
              // setState(() {}); // 请在外部执行

              widget.clickApiMockCellCallback(
                section: section,
                row: row,
                bApiModel: bApiModel,
                isLongPress: isLongPress,
              );
            },
          );
        }
      },
      divider: Container(color: Colors.green, height: 1.0),
    );
  }
}
