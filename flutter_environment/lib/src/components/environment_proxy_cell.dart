import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import '../environment_data_bean.dart';

typedef ClickEnvProxyCellCallback = void Function(
  int section,
  int row,
  TSEnvProxyModel bProxyModel,
);

class EnvProxyTableViewCell extends StatelessWidget {
  @required
  final TSEnvProxyModel proxyModel; // 环境

  final int section;
  final int row;
  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // 协议 proxyCell 的点击

  EnvProxyTableViewCell({
    Key key,
    this.proxyModel,
    this.section,
    this.row,
    this.clickEnvProxyCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: proxyModel.name,
      subTitles: [proxyModel.proxyIp, proxyModel.useDirection],
      check: proxyModel.check,
      section: section,
      row: row,
      clickEnvBaseCellCallback: (section, row, mainTitle, subTitles, check) {
        if (null != this.clickEnvProxyCellCallback) {
          this.clickEnvProxyCellCallback(
            this.section,
            this.row,
            this.proxyModel,
          );
        }
      },
    );
  }
}
