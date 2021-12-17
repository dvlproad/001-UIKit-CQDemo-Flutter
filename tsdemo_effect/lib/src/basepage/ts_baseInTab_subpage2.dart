import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import './ts_baseInTab_subpageContentWidget.dart';

class TSBaseInTabSubPage2 extends BJHBasePage {
  TSBaseInTabSubPage2({Key key}) : super(key: key);

  @override
  _TSBaseInTabSubPage2State createState() => _TSBaseInTabSubPage2State();
}

class _TSBaseInTabSubPage2State extends BJHBasePageState<TSBaseInTabSubPage2>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget buildSuccessWidget(BuildContext context) {
    return TSBasePageContentWidget();
  }
}
