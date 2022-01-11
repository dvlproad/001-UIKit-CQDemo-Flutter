// 包含标题文本title，值视图valueWidget、箭头类型 的视图
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

typedef ClickCellCallback = void Function(int section, int row);

enum TableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class BJHTitleCommonValueTableViewCell extends StatelessWidget {
  final String title; // 主文本
  final Widget valueWidget; // 值视图（此值为空时候，视图会自动隐藏）
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback; // cell 的点击

  const BJHTitleCommonValueTableViewCell({
    Key key,
    this.title,
    this.valueWidget,
    this.arrowImageType = TableViewCellArrowImageType.none,
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
      this.clickCellCallback(this.section, this.row);
    }
  }

  Widget _cellContainer() {
    List<Widget> rowWidgets = [];

    // 添加主文本到rowWidgets中(肯定存在主文本)
    rowWidgets.add(
      Expanded(
        child: _mainText(),
      ),
    );

    // 添加valueWidget到rowWidgets中
    if (null != this.valueWidget) {
      rowWidgets.add(this.valueWidget);
    }

    // 判断是否添加箭头，存在则添加到rowWidgets中
    if (this.arrowImageType != TableViewCellArrowImageType.none) {
      rowWidgets.add(SizedBox(width: AdaptCJHelper.setWidth(30)));
      rowWidgets.add(_arrowImage());
    }

    return Container(
      height: AdaptCJHelper.setWidth(100),
      padding: EdgeInsets.only(
          left: AdaptCJHelper.setWidth(40), right: AdaptCJHelper.setWidth(40)),
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
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.title ?? '',
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color(0xff222222),
          fontSize: AdaptCJHelper.setWidth(30),
          fontWeight: FontWeight.bold,
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
        image:
            AssetImage('assets/arrow_right.png', package: 'flutter_baseui_kit'),
        width: AdaptCJHelper.setWidth(17),
        height: AdaptCJHelper.setWidth(32),
      ),
    );
  }
}
