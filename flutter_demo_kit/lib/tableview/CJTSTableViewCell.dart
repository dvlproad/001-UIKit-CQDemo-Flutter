// 包含主文本main，且可选定制副文本、箭头 的视图
import 'package:flutter/material.dart';

typedef ClickCellCallback = void Function(int? section, int? row);

enum CJTSTableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class CJTSTableViewCell extends StatelessWidget {
  final String text; // 主文本
  final String? detailText; // 副文本（此值为空时候，视图会自动隐藏）
  final CJTSTableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int? section;
  final int? row;
  final ClickCellCallback? clickCellCallback; // cell 的点击

  CJTSTableViewCell({
    Key? key,
    required this.text,
    this.detailText,
    this.arrowImageType = CJTSTableViewCellArrowImageType.none,
    this.section,
    this.row,
    this.clickCellCallback,
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
    if (null != this.clickCellCallback) {
      this.clickCellCallback!(this.section, this.row);
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
    if (null != this.detailText && this.detailText!.length > 0) {
      rowWidgets.add(_subText());
    }

    // 判断是否添加箭头
    if (this.arrowImageType != CJTSTableViewCellArrowImageType.none) {
      rowWidgets.add(_arrowImage());
    }

    return Container(
      height: 44,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: rowWidgets,
      ),
    );
  }

  // 主文本
  Widget _mainText() {
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.text,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
  }

  // 副文本
  Widget _subText() {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      color: Colors.transparent,
      child: Text(
        this.detailText ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Colors.black.withOpacity(0.5),
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
