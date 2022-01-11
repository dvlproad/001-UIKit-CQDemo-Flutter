import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import './api_data_bean.dart';

typedef ClickApiLogCellCallback = void Function(
  int section,
  int row,
  ApiModel bApiModel,
);

class ApiLogTableViewCell extends StatelessWidget {
  @required
  final ApiModel apiModel; // 环境

  final int section;
  final int row;
  final ClickApiLogCellCallback clickApiLogCellCallback; // logCell 的点击

  ApiLogTableViewCell({
    Key key,
    this.apiModel,
    this.section,
    this.row,
    this.clickApiLogCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: apiModel.name,
      subTitles: [apiModel.url],
      check: apiModel.mock,
      section: section,
      row: row,
      clickEnvBaseCellCallback: (section, row, mainTitle, subTitles, check) {
        if (null != this.clickApiLogCellCallback) {
          this.clickApiLogCellCallback(
            this.section,
            this.row,
            this.apiModel,
          );
        }
      },
    );
  }
}
