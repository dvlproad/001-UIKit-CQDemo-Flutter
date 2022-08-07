/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 15:24:11
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import '../network_page_data_bean.dart';

typedef ClickEnvNetworkCellCallback = void Function({
  int? section,
  int? row,
  required TSEnvNetworkModel bNetworkModel,
  bool? isLongPress,
});

class EnvNetworkTableViewCell extends StatelessWidget {
  final TSEnvNetworkModel envModel; // 环境

  final int section;
  final int row;
  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击

  EnvNetworkTableViewCell({
    Key? key,
    required this.envModel,
    this.section = 0,
    this.row = 0,
    required this.clickEnvNetworkCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: envModel.name,
      subTitles: [envModel.apiHost, envModel.webHost, envModel.gameHost],
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
        if (null != this.clickEnvNetworkCellCallback) {
          this.clickEnvNetworkCellCallback(
            section: section,
            row: row,
            bNetworkModel: this.envModel,
            isLongPress: isLongPress,
          );
        }
      },
    );
  }
}
