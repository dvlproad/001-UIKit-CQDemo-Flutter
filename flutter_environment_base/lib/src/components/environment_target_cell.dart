/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-24 15:58:25
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import '../data_target/packageType_page_data_bean.dart';

typedef ClickEnvTargetCellCallback = void Function({
  int? section,
  int? row,
  required PackageTargetModel bTargetModel,
  bool? isLongPress,
});

class EnvTargetTableViewCell extends StatelessWidget {
  final PackageTargetModel envModel; // 环境

  final int section;
  final int row;
  final ClickEnvTargetCellCallback
      clickEnvTargetCellCallback; // 网络 networkCell 的点击

  EnvTargetTableViewCell({
    Key? key,
    required this.envModel,
    this.section = 0,
    this.row = 0,
    required this.clickEnvTargetCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: envModel.name,
      subTitles: [
        envModel.envId,
        envModel.des,
      ],
      check: envModel.check,
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
        this.clickEnvTargetCellCallback(
          section: section,
          row: row,
          bTargetModel: this.envModel,
          isLongPress: isLongPress,
        );
      },
    );
  }
}
