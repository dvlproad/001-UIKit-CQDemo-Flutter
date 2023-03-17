/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 12:00:06
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CJTSTableViewHeader extends StatefulWidget {
  final String title;

  CJTSTableViewHeader({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CJTSTableViewHeaderState();
  }
}

class _CJTSTableViewHeaderState extends State<CJTSTableViewHeader> {
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
      height: 30,
//      padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
      margin: EdgeInsets.fromLTRB(30, 20, 0, 0),
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      child: Text(
        widget.title,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Color(0xFF898989),
          fontSize: 14.0,
        ),
      ),
    );
  }
}
