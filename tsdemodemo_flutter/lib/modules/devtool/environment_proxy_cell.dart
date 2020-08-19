// 包含主文本main，且可选定制副文本、箭头 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/devtool/environment_data_bean.dart';

typedef ClickEnvProxyCellCallback = void Function(int section, int row, TSEnvProxyModel bProxyModel);

enum CJTSTableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class EnvProxyTableViewCell extends StatelessWidget {
  final TSEnvProxyModel proxyModel;
  final CJTSTableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickEnvProxyCellCallback clickEnvProxyCellCallback; // cell 的点击

  EnvProxyTableViewCell({
    Key key,
    this.proxyModel,
    this.arrowImageType = CJTSTableViewCellArrowImageType.none,
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
      this.clickEnvProxyCellCallback(this.section, this.row, this.proxyModel);
    }
  }

  Widget _cellContainer() {
    List<Widget> rowWidgets = [];

    // 添加主文本
    rowWidgets.add(
      Expanded(
        child: _mainText(),
      ),
    );

    // 判断是否添加副文本
    String detailText = this.proxyModel.name ?? '';
    if (detailText.length > 0) {
      rowWidgets.add(_subText());
    }

    // 判断是否添加箭头
    if (this.arrowImageType != CJTSTableViewCellArrowImageType.none) {
      rowWidgets.add(_arrowImage());
    }

    return Container(
      height: 44,
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowWidgets,
      ),
    );
  }

  // 主文本
  Widget _mainText() {
    String name = this.proxyModel.name ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        name,
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
  Widget _subText() {
    String name = this.proxyModel.name ?? '';

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      color: Colors.transparent,
      child: Text(
        name,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.white,
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
      child: Image(
        image: AssetImage('lib/Resources/report/arrow_right.png'),
        width: 8,
        height: 12,
      ),
    );
  }
}
