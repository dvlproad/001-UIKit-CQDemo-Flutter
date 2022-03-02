import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_base_cell.dart';
import '../network_page_data_bean.dart';

typedef ClickEnvNetworkCellCallback = void Function(
  int section,
  int row,
  TSEnvNetworkModel bNetworkModel,
);

class EnvNetworkTableViewCell extends StatelessWidget {
  @required
  final TSEnvNetworkModel envModel; // 环境

  final int section;
  final int row;
  final ClickEnvNetworkCellCallback
      clickEnvNetworkCellCallback; // 网络 networkCell 的点击

  EnvNetworkTableViewCell({
    Key key,
    this.envModel,
    this.section,
    this.row,
    this.clickEnvNetworkCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EnvBaseTableViewCell(
      mainTitle: envModel.name,
      subTitles: [envModel.apiHost, envModel.webHost, envModel.gameHost],
      check: envModel.check,
      section: section,
      row: row,
      clickEnvBaseCellCallback: (section, row, mainTitle, subTitles, check,
          {bool isLongPress}) {
        if (null != this.clickEnvNetworkCellCallback) {
          this.clickEnvNetworkCellCallback(
            this.section,
            this.row,
            this.envModel,
          );
        }
      },
    );
  }
}
