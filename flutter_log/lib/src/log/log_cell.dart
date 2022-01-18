import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './log_base_cell.dart';
import './log_data_bean.dart';

typedef ClickApiLogCellCallback = void Function(
  int section,
  int row,
  LogModel bApiModel,
);

class ApiLogTableViewCell extends StatelessWidget {
  @required
  final LogModel apiModel; // 环境

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
    return LogBaseTableViewCell(
      maxLines: 18,
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
