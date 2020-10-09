import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './empty_search_page.dart';

class TSEmptyHomePage extends CJTSBasePage {
  TSEmptyHomePage({Key key}) : super(key: key);

  @override
//  _TSEmptyHomePageState createState() => _TSEmptyHomePageState();
  CJTSBasePageState getState() {
    return _TSEmptyHomePageState();
  }
}

class _TSEmptyHomePageState extends CJTSBasePageState<TSEmptyHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('Empty 首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Empty",
        'values': [
          {
            'title': "Empty(搜索页)",
            // 'nextPageName': BaseUIKitRouters.buttonHomePage,
            'actionBlock': () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TSEmptySearchPage()));
            },
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
