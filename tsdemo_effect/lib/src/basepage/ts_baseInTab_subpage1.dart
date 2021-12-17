import 'package:flutter/material.dart';
import './ts_baseInTab_subpageContentWidget.dart';

class TSBaseInTabSubPage1 extends StatefulWidget {
  TSBaseInTabSubPage1({Key key}) : super(key: key);

  @override
  _TSBaseInTabSubPage1State createState() => _TSBaseInTabSubPage1State();
}

// 1 实现 SingleTickerProviderStateMixin
class _TSBaseInTabSubPage1State extends State<TSBaseInTabSubPage1>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Color backgroundColor() {
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return TSBasePageContentWidget();
  }
}
