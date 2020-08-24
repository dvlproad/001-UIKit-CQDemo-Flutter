import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
      _mainText(this.envModel.name),
    );

    // 判断是否添加其他文本
    String hostName = this.envModel.hostName ?? '';
    if (hostName.isNotEmpty) {
      columnWidgets.add(_subText(hostName));
    }

    String interceptHost = this.envModel.interceptHost ?? '';
    if (interceptHost.isNotEmpty) {
      columnWidgets.add(_subText(interceptHost));
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
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      color: Colors.transparent,
      child: Icon(Icons.check_box, color: Colors.white, size: 14),
    );
  }
}
