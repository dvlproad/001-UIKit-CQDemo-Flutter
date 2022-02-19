import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/environment_base_cell.dart';
import './manager/api_data_bean.dart';

typedef ClickApiMockCellCallback = void Function(
  int section,
  int row,
  ApiModel bApiModel,
);

class ApiMockTableViewCell extends StatelessWidget {
  @required
  final ApiModel apiModel; // 环境

  final int section;
  final int row;
  final ClickApiMockCellCallback clickApiMockCellCallback; // 协议 proxyCell 的点击

  ApiMockTableViewCell({
    Key key,
    this.apiModel,
    this.section,
    this.row,
    this.clickApiMockCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: apiModel.name,
      subTitles: [apiModel.url],
      check: apiModel.mock,
      section: section,
      row: row,
      clickEnvBaseCellCallback: (
        section,
        row,
        mainTitle,
        subTitles,
        check, {
        bool isLongPress,
      }) {
        if (null != this.clickApiMockCellCallback) {
          this.clickApiMockCellCallback(
            this.section,
            this.row,
            this.apiModel,
          );
        }
      },
    );
  }
}
