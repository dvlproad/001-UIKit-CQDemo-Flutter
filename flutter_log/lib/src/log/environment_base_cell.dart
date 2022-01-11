import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ClickEnvBaseCellCallback = void Function(
  int section,
  int row,
  String mainTitle,
  List<String> subTitles,
  bool check,
);

class EnvBaseTableViewCell extends StatelessWidget {
  final String mainTitle;
  final List<String> subTitles;
  final bool check;

  final int section;
  final int row;
  final ClickEnvBaseCellCallback clickEnvBaseCellCallback; // 网络 networkCell 的点击

  EnvBaseTableViewCell({
    Key key,
    @required this.mainTitle,
    @required this.subTitles,
    this.check,
    this.section,
    this.row,
    @required this.clickEnvBaseCellCallback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   color: Colors.blue,
    //   child: Row(
    //     children: [
    //       Container(
    //         height: 40,
    //         color: Colors.yellow,
    //         child: Text('2收到了反对浪费理发店理发店里是否建立的数据发了多少家附近的洛杉矶反对浪费就觉得'),
    //       )
    //     ],
    //   ),
    // );
    return Container(
      color: Colors.transparent,
      child: cellWidget(),
    );
  }

  Widget cellWidget() {
    return GestureDetector(
      child: _cellContainer(),
      onTap: _onTapCell,
    );
  }

  void _onTapCell() {
    if (null != this.clickEnvBaseCellCallback) {
      this.clickEnvBaseCellCallback(
        this.section,
        this.row,
        this.mainTitle,
        this.subTitles,
        this.check,
      );
    }
  }

  Widget _cellContainer() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _rowLeftWidget),
          _rowRightWidget != null ? _rowRightWidget : Container()
        ],
      ),
    );
  }

  // row 右边箭头以外的左视图
  Widget get _rowLeftWidget {
    List<Widget> columnWidgets = [];
    // 添加主文本
    Widget mainTextWidget = Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
      color: Colors.transparent,
      child: Text(
        this.mainTitle ?? '',
        textAlign: TextAlign.left,
        // overflow: TextOverflow.ellipsis, // ellipsis 会有省略号
        style: TextStyle(
          color: Colors.black,
          fontSize: 16.0,
        ),
      ),
    );
    columnWidgets.add(mainTextWidget);

    // 判断是否添加其他文本
    for (String subTitle in this.subTitles) {
      if (subTitle != null && subTitle.isNotEmpty) {
        Widget subTextWidget = Container(
          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
          color: Colors.transparent,
          child: Text(
            subTitle ?? '',
            textAlign: TextAlign.left,
            // overflow: TextOverflow.ellipsis, // ellipsis 会有省略号
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        );
        columnWidgets.add(subTextWidget);
      }
    }

    Widget rowLeftWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnWidgets,
    );

    return rowLeftWidget;
  }

  // row 右边箭头
  Widget get _rowRightWidget {
    // 判断是否添加箭头
    if (this.check == false) {
      return null;
    }

    Widget arrowImageWidget = Container(
      padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
      color: Colors.transparent,
      child: Icon(Icons.check_box, color: Colors.black, size: 14),
    );
    return arrowImageWidget;
  }
}
