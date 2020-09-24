import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/base/CJTSBasePage.dart';
import 'package:flutter_demo_kit/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_routes.dart';

class TSTextViewHomePage extends CJTSBasePage {
  TSTextViewHomePage({Key key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSTextViewHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('TextView首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "TextView UI",
        'values': [
          {
            'title': "text textview(emoji 长度计算)",
            'nextPageName': BaseUIKitRouters.textViewPage,
          },
          {
            'title': "text textview(maxLength 长度计算)",
            'nextPageName': BaseUIKitRouters.textViewMaxLengthPage,
          },
          {
            'title': "text textview(emoji maxLength 长度计算)",
            'nextPageName': BaseUIKitRouters.textViewEmojiMaxLengthPage,
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
