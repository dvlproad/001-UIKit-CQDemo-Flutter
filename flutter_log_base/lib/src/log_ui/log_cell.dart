/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:51:45
 * @Description: 
 */
import 'package:flutter/material.dart';
import './log_base_cell.dart';
import '../bean/log_data_bean.dart';

typedef ClickApiLogCellCallback = void Function({
  required BuildContext context,
  int? section,
  int? row,
  required LogModel bLogModel,
});

class ApiLogTableViewCell extends StatelessWidget {
  final int? maxLines;

  final LogModel apiLogModel; // 环境

  final int section;
  final int row;
  final ClickApiLogCellCallback clickApiLogCellCallback; // logCell 的点击

  const ApiLogTableViewCell({
    Key? key,
    this.maxLines,
    required this.apiLogModel,
    this.section = 0,
    this.row = 0,
    required this.clickApiLogCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color subTitleColor = apiLogModel.logColor;

    String mainTitle = '${row + 1}.${apiLogModel.title}';
    return LogBaseTableViewCell(
      maxLines: maxLines ?? 18,
      mainTitle: mainTitle,
      mainTitleStyle: TextStyle(
        color: Colors.grey[850],
        fontSize: 12.0,
      ),
      subTitles: [apiLogModel.shortMapString],
      subTitleColor: subTitleColor,
      check: false,
      section: section,
      row: row,
      clickEnvBaseCellCallback: ({
        int? section,
        int? row,
        required String mainTitle,
        List<String>? subTitles,
        bool? check,
      }) {
        clickApiLogCellCallback(
          context: context,
          section: this.section,
          row: this.row,
          bLogModel: apiLogModel,
        );
      },
    );
  }
}
