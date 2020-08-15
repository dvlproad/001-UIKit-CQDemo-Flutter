import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/modules/overlay/overlay_routes.dart';

class TSOverlayHomePage extends CJTSBasePage {
  final String title;

  TSOverlayHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSOverlayHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Provider 的使用方式",
        'values': [
          {
            'title': "message",
            'nextPageName': OverlayRouters.messageAlertPage,
          },
        ]
      },
    ];

    return Column(
      children: <Widget>[
        Expanded(
          child: CJTSSectionTableView(
            context: context,
            sectionModels: sectionModels,
          ),
        ),
      ],
    );
  }
}
