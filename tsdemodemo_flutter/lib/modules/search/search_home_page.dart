import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/modules/search/search_routes.dart';

class TSSearchHomePage extends CJTSBasePage {
  final String title;

  TSSearchHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSSearchHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Search首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Search",
        'values': [
          {
            'title': "searchPage",
            'nextPageName': SearchRouters.searchPage,
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
