/*
 * CQModulesHomePage.dart
 *
 * @Description: 模块的测试首页
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/27 17:08
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textbutton.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

class CQModulesHomePage extends CJTSBasePage {
  final String title;

  CQModulesHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<CQModulesHomePage> {
  var sectionModels = [];

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "模块",
        'values': [
          {
            'title': "Report(举报模块)",
            'actionBlock': () {
              var params = {
                'reportTypeId': '1341353r33',
                'reportTypeValue': 1,
                'reportTypeDescription': '举报合集',
              };
              Navigator.pushNamed(context, Routers.reportListPage,
                  arguments: params);
              // Navigator.of(context).pushNamed(Routers.reportListPage, arguments: params);
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => ReportListPage(
//                   reportTypeId: '1341353r33',
//                   reportTypeValue: 1,
//                   reportTypeDescription: '举报合集',
//                 ),
//               //settings: RouteSettings(arguments: userName),
//               ),
//             );
            }
          },
          {
            'title': "Ranking(排行榜模块)",
            'actionBlock': () {
              var params = {
                'blockId': 'dfjdl895',
              };
              Navigator.pushNamed(context, Routers.rankingListPage,
                  arguments: params);
            }
          },
          {
            'title': "Search(搜索模块)",
            'actionBlock': () {
              var params = {
                'blockId': 'dfjdl895',
              };
              Navigator.pushNamed(context, Routers.searchPage,
                  arguments: params);
            }
          },
          {
            'title': "Guide(引导模块)",
            'actionBlock': () {
              var params = {};
              Navigator.pushNamed(context, Routers.guidePage,
                  arguments: params);
            }
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
        )),
        WhiteThemeBGButton(text: "提交", onPressed: () {}),
      ],
    );
  }
}
