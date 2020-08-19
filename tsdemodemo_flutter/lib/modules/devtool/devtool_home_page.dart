import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/modules/devtool/devtool_routes.dart';

class TSDevToolHomePage extends CJTSBasePage {
  final String title;

  TSDevToolHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSDevToolHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Dev Tool 首页'),
    );
  }

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "Dev Tool(调试工具)",
        'values': [
          {
            'title': "Environment(环境)",
            'nextPageName': DevToolRouters.environmentPage,
          },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
