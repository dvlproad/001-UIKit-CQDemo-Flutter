/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 15:20:00
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/environment_base_cell.dart';
import './manager/api_data_bean.dart';

typedef ClickApiMockCellCallback = void Function({
  int? section,
  int? row,
  required ApiModel bApiModel,
  bool? isLongPress,
});

class ApiMockTableViewCell extends StatelessWidget {
  final ApiModel apiModel; // 环境

  final int section;
  final int row;
  final ClickApiMockCellCallback clickApiMockCellCallback; // 协议 proxyCell 的点击

  ApiMockTableViewCell({
    Key? key,
    required this.apiModel,
    this.section = 0,
    this.row = 0,
    required this.clickApiMockCellCallback,
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
        String mainTitle, {
        required List<String> subTitles,
        int? section,
        int? row,
        bool? check,
        bool? isLongPress,
      }) {
        if (null != this.clickApiMockCellCallback) {
          this.clickApiMockCellCallback(
            section: this.section,
            row: this.row,
            bApiModel: this.apiModel,
            isLongPress: isLongPress,
          );
        }
      },
    );
  }
}
