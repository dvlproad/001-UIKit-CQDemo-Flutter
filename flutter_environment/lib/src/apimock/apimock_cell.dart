import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/environment_cell_components.dart';
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
    return cellWidget();
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if (null != this.clickApiMockCellCallback) {
      this.clickApiMockCellCallback(
        this.section,
        this.row,
        this.apiModel,
      );
    }
  }

  Widget _cellContainer() {
    List<Widget> columnWidgets = [];
    // 添加主文本
    columnWidgets.add(
      EnvironmentCellComponentsFactory.mainText(this.apiModel.name),
    );

    // 判断是否添加其他文本
    String proxyIp = this.apiModel.url ?? '';
    if (proxyIp.isNotEmpty) {
      columnWidgets.add(EnvironmentCellComponentsFactory.subText(proxyIp));
    }

    // String useDirection = this.apiModel.useDirection ?? '';
    // if (useDirection.isNotEmpty) {
    //   columnWidgets.add(EnvironmentCellComponentsFactory.subText(useDirection));
    // }

    List<Widget> rowWidgets = [];
    rowWidgets.add(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: columnWidgets,
      ),
    );
    // 判断是否添加箭头
    if (this.apiModel.mock == true) {
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
