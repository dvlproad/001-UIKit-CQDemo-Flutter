/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-23 18:49:48
 * @Description: 
 */
import 'package:flutter/material.dart';

class EnvironmentTableViewHeader extends StatefulWidget {
  final String title;

  const EnvironmentTableViewHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _EnvironmentTableViewHeaderState();
  }
}

class _EnvironmentTableViewHeaderState
    extends State<EnvironmentTableViewHeader> {
  @override
  Widget build(BuildContext context) {
    return headerWidget();
  }

  Widget headerWidget() {
//    return GestureDetector(
//      child: _headerContainer(),
//      onTap: _onTapHeader,
//    );
    return _headerContainer();
  }

  Widget _headerContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 10, 10, 0),
      //color: Colors.green,
      alignment: Alignment.centerLeft,
      constraints: const BoxConstraints(
        minHeight: 30,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: _rowLeftWidget),
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
        widget.title,
        textAlign: TextAlign.left,
        style: const TextStyle(
          color: Colors.red,
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
    columnWidgets.add(mainTextWidget);

    Widget rowLeftWidget = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: columnWidgets,
    );

    return rowLeftWidget;
  }
}
