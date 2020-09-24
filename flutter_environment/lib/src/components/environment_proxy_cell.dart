import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import './environment_cell_components.dart';
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
    return cellWidget();
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if (null != this.clickEnvProxyCellCallback) {
      this.clickEnvProxyCellCallback(
        this.section,
        this.row,
        this.proxyModel,
      );
    }
  }

  Widget _cellContainer() {
    List<Widget> columnWidgets = [];
    // 添加主文本
    columnWidgets.add(
      EnvironmentCellComponentsFactory.mainText(this.proxyModel.name),
    );

    // 判断是否添加其他文本
    String proxyIp = this.proxyModel.proxyIp ?? '';
    if (proxyIp.isNotEmpty) {
      columnWidgets.add(EnvironmentCellComponentsFactory.subText(proxyIp));
    }

    String useDirection = this.proxyModel.useDirection ?? '';
    if (useDirection.isNotEmpty) {
      columnWidgets.add(EnvironmentCellComponentsFactory.subText(useDirection));
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
    if (this.proxyModel.check == true) {
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
