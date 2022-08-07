/*
 * @Author: dvlproad
 * @Date: 2022-04-15 22:08:25
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-19 13:04:32
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EnvironmentTableViewHeader extends StatefulWidget {
  final String? title;

  EnvironmentTableViewHeader({Key? key, this.title}) : super(key: key);

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
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      // color: Colors.green,
      alignment: Alignment.centerLeft,
      constraints: BoxConstraints(
        minHeight: 44,
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
      padding: EdgeInsets.fromLTRB(10, 5, 0, 0),
      color: Colors.transparent,
      child: Text(
        widget.title ?? '',
        textAlign: TextAlign.left,
        style: TextStyle(
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
