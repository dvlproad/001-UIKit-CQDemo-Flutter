import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/commonui/devtool/environment_data_bean.dart';

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
      _mainText(this.proxyModel.name),
    );

    // 判断是否添加其他文本
    String proxyIp = this.proxyModel.proxyIp ?? '';
    if (proxyIp.isNotEmpty) {
      columnWidgets.add(_subText(proxyIp));
    }

    String useDirection = this.proxyModel.useDirection ?? '';
    if (useDirection.isNotEmpty) {
      columnWidgets.add(_subText(useDirection));
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
      rowWidgets.add(_arrowImage());
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

  // 主文本
  Widget _mainText(text) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        text ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
    );
  }

  // 副文本
  Widget _subText(text) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        text ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white70,
          fontSize: 16.0,
        ),
      ),
    );
  }

  // 箭头
  Widget _arrowImage() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Image(
        image: AssetImage('lib/Resources/report/arrow_right.png'),
        width: 8,
        height: 12,
      ),
    );
  }
}
