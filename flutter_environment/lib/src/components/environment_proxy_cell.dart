/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 15:25:04
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import '../proxy_page_data_bean.dart';

typedef ClickEnvProxyCellCallback = void Function(
  int section,
  int row,
  TSEnvProxyModel bProxyModel, {
  bool? isLongPress,
});

class EnvProxyTableViewCell extends StatelessWidget {
  final TSEnvProxyModel proxyModel; // 环境

  final int section;
  final int row;
  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  EnvProxyTableViewCell({
    Key? key,
    required this.proxyModel,
    this.section = 0,
    this.row = 0,
    required this.clickEnvProxyCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> subTitles = [];
    if (proxyModel.proxyIp != null) {
      subTitles.add(proxyModel.proxyIp!);
    }
    if (proxyModel.useDirection != null) {
      subTitles.add(proxyModel.useDirection!);
    }
    return EnvBaseTableViewCell(
      mainTitle: proxyModel.name,
      subTitles: subTitles,
      check: proxyModel.check,
      section: section,
      row: row,
      clickEnvBaseCellCallback: (
        String mainTitle, {
        required List<String> subTitles,
        int? section,
        int? row,
        bool? check,
        bool? isLongPress, // 是否是长按
      }) {
        if (null != this.clickEnvProxyCellCallback) {
          this.clickEnvProxyCellCallback(
            this.section,
            this.row,
            this.proxyModel,
            isLongPress: isLongPress,
          );
        }
      },
    );
  }
}
