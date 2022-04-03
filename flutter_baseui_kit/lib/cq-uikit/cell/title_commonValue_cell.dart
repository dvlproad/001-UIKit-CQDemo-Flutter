// 包含标题文本title，值视图valueWidget、箭头类型 的视图
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

typedef ClickCellCallback = void Function(int section, int row,
    {bool bIsLongPress});

enum TableViewCellArrowImageType {
  none, // 无箭头
  arrowRight, // 右箭头
  arrowTopBottom, // 上下箭头
}

class BJHTitleCommonValueTableViewCell extends StatelessWidget {
  final double height; // cell 的高度
  final double leftRightPadding; // cell 内容的左右间距

  final String title; // 主文本
  final Widget valueWidget; // 值视图（此值为空时候，视图会自动隐藏）
  final TableViewCellArrowImageType arrowImageType; // 箭头类型(默认none)

  final int section;
  final int row;
  final ClickCellCallback clickCellCallback; // cell 的点击

  const BJHTitleCommonValueTableViewCell({
    Key key,
    this.height,
    this.leftRightPadding,
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
      onTap: () {
        _onTapCell(isLongPress: false);
      },
      onLongPress: () {
        _onTapCell(isLongPress: true);
      },
    );
  }

  void _onTapCell({bool isLongPress}) {
    if (null != this.clickCellCallback) {
      this.clickCellCallback(
        this.section,
        this.row,
        bIsLongPress: isLongPress,
      );
    }
  }

  Widget _cellContainer() {
    List<Widget> rightRowWidgets = [];

    // 添加valueWidget到rowWidgets中
    if (null != this.valueWidget) {
      rightRowWidgets.add(SizedBox(width: 10.w_cj));
      rightRowWidgets.add(this.valueWidget);
    }

    // 判断是否添加箭头，存在则添加到rowWidgets中
    if (this.arrowImageType != TableViewCellArrowImageType.none) {
      rightRowWidgets.add(SizedBox(width: 30.w_cj));
      rightRowWidgets.add(_arrowImage());
    }
    if (rightRowWidgets.length == 0) {
      rightRowWidgets.add(Container());
    }
    Widget rightRowWidget = Row(children: rightRowWidgets);

    double leftRightPadding = this.leftRightPadding ?? 40.w_cj;

    return Container(
      height: this.height ?? 88.h_cj,
      padding: EdgeInsets.only(left: leftRightPadding, right: leftRightPadding),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _mainText(),
          // Expanded(
          //   child: Container(
          //     color: Colors.orange,
          //     child: Row(
          //       children: [
          //         Expanded(
          //           child: Row(
          //             children: [
          //               Expanded(child: Text('砥砺奋进代理费林德洛夫冻死了发动机')),
          //               Text('1'),
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          rightRowWidget,
        ],
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
          fontSize: 30.w_cj,
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
        width: 17.w_cj,
        height: 32.h_cj,
      ),
    );
  }
}
