import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_cell_components.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_data_bean.dart';

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
    return cellWidget();
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if (null != this.clickEnvNetworkCellCallback) {
      this.clickEnvNetworkCellCallback(
        this.section,
        this.row,
        this.envModel,
      );
    }
  }

  Widget _cellContainer() {
    List<Widget> columnWidgets = [];
    // 添加主文本
    columnWidgets.add(
      EnvironmentCellComponentsFactory.mainText(this.envModel.name),
    );

    // 判断是否添加其他文本
    String hostName = this.envModel.hostName ?? '';
    if (hostName.isNotEmpty) {
      columnWidgets.add(EnvironmentCellComponentsFactory.subText(hostName));
    }

    String interceptHost = this.envModel.interceptHost ?? '';
    if (interceptHost.isNotEmpty) {
      columnWidgets
          .add(EnvironmentCellComponentsFactory.subText(interceptHost));
    }

    List<Widget> rowWidgets = [];
    rowWidgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnWidgets,
      ),
    );
    // 判断是否添加箭头
    if (this.envModel.check == true) {
      rowWidgets.add(EnvironmentCellComponentsFactory.arrowImage());
    }

    return Container(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowWidgets,
      ),
    );
  }
}
