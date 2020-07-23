// 包含主文本main，且可选定制副文本、箭头 的视图
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ClickCellCallback = void Function(int section, int row);

enum TableViewCellArrowImageType{
  none,           // 无箭头
  arrowRight,     // 右箭头
  arrowTopBottom, // 上下箭头
}

class MainSubArrowTableViewCell extends StatefulWidget {
  final String text;                          // 主文本
  final String detailText;                    // 副文本（此值为空时候，视图会自动隐藏）
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback;  // cell 的点击

  MainSubArrowTableViewCell({
    Key key,
    this.text,
    this.detailText,
    this.arrowImageType=TableViewCellArrowImageType.none,

    this.section,
    this.row,
    this.clickCellCallback,
  }) : super(key: key);


  @override
  State<StatefulWidget> createState() {
    return _MainSubArrowTableViewCellState();
  }
}

class _MainSubArrowTableViewCellState extends State<MainSubArrowTableViewCell> {
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
    if(null != widget.clickCellCallback) {
      widget.clickCellCallback(widget.section, widget.row);
    }
  }


  Widget _cellContainer() {
    List<Widget> rowWidgets = [];

    // 添加主文本
    rowWidgets.add(_mainText());

    // 判断是否添加副文本
    if (null != widget.detailText && widget.detailText.length > 0) {
      rowWidgets.add(_subText());
    }

    // 判断是否添加箭头
    if (widget.arrowImageType != TableViewCellArrowImageType.none) {
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
    return Container(
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        widget.text,
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
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
      color: Colors.transparent,
      child: Text(
        widget.detailText,
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
