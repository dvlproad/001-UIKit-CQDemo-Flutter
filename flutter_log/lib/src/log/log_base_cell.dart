import 'package:flutter/material.dart';
import './expandable_text.dart';

typedef ClickEnvBaseCellCallback = void Function({
  int? section,
  int? row,
  required String mainTitle,
  List<String>? subTitles,
  bool? check,
});

class LogBaseTableViewCell extends StatelessWidget {
  final int maxLines;

  final String mainTitle;
  final TextStyle? mainTitleStyle;
  final List<String>? subTitles;
  final Color? subTitleColor;
  final bool check;

  final int? section;
  final int? row;
  final ClickEnvBaseCellCallback clickEnvBaseCellCallback; // 网络 networkCell 的点击
  final void Function()? onLongPress;

  const LogBaseTableViewCell({
    Key? key,
    this.maxLines = 20,
    required this.mainTitle,
    this.mainTitleStyle,
    required this.subTitles,
    this.subTitleColor,
    this.check = false,
    this.section,
    this.row,
    required this.clickEnvBaseCellCallback,
    this.onLongPress,
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
      onLongPress: onLongPress,
    );
  }

  void _onTapCell() {
    clickEnvBaseCellCallback(
      section: section,
      row: row,
      mainTitle: mainTitle,
      subTitles: subTitles,
      check: check,
    );
  }

  Widget _cellContainer() {
    return Container(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _rowLeftWidget),
          _rowRightWidget, // 右箭头
        ],
      ),
    );
  }

  // row 右边箭头以外的左视图
  Widget get _rowLeftWidget {
    List<Widget> columnWidgets = [];
    // 添加主文本
    Widget mainTextWidget = Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
      color: Colors.transparent,
      child: Text(
        mainTitle,
        textAlign: TextAlign.left,
        // overflow: TextOverflow.ellipsis, // ellipsis 会有省略号
        style: mainTitleStyle ??
            const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
      ),
    );
    columnWidgets.add(mainTextWidget);

    // 判断是否添加其他文本
    for (String subTitle in subTitles ?? []) {
      if (subTitle.isNotEmpty) {
        Widget subTextWidget = Container(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          color: Colors.transparent,
          // child: Text(
          //   subTitle ?? '',
          //   textAlign: TextAlign.left,
          //   // overflow: TextOverflow.ellipsis, // ellipsis 会有省略号
          //   style: TextStyle(
          //     color: Colors.black,
          //     fontSize: 16.0,
          //   ),
          // ),
          child: ExpandableText(
            //当文案过长时，可以设置展开和收起
            text: subTitle,
            textStyle: TextStyle(color: subTitleColor ?? Colors.black),
            maxLines: maxLines,
            onExpanded: (bool isExpanded) {
              if (isExpanded) {
                //debugPrint('已经展开');
              } else {
                //debugPrint('已经收起');
              }
            },
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
    if (check == false) {
      return Container();
    }

    Widget arrowImageWidget = Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
      color: Colors.transparent,
      child: const Icon(Icons.check_box, color: Colors.black, size: 14),
    );
    return arrowImageWidget;
  }
}
