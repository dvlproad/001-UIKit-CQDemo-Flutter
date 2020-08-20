import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_routes.dart';

class TSBaseUIHomePage extends CJTSBasePage {
  final String title;

  TSBaseUIHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSBaseUIHomePage> {
  var sectionModels = [];

  @override
  Widget contentWidget() {
    // }

    // @override
    // void initState() {
    //   super.initState();

    sectionModels = [
      {
        'theme': "组件",
        'values': [
          {
            'title': "Button(按钮)",
            'nextPageName': BaseUIKitRouters.buttonHomePage,
          },
          {
            'title': "Image(图片)",
            'nextPageName': "TSImageHomePage",
          },
          {
            'title': "TextFiled(文本框)",
            'nextPageName': BaseUIKitRouters.textFieldHomePage,
          },
          // { 'title': "ToolBar(工具器)", 'nextPageName': "ToolBarHomePage" },
        ]
      },
    ];

    return CJTSSectionTableView(
      context: context,
      sectionModels: sectionModels,
    );
  }
}
