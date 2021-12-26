import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './overlay_util_routes.dart';

class TSOverlayUtilHomePage extends CJTSBasePage {
  TSOverlayUtilHomePage({Key key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSOverlayUtilHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay Util 首页'),
    );
  }

  @override
  Widget contentWidget() {
    String imageSource =
        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3460118221,780234760&fm=26&gp=0.jpg';

    sectionModels = [
      {
        'theme': "单条信息的弹窗视图",
        'values': [
          {
            'title': "Toast(View)-暂无",
            'imageSource': imageSource,
            // 'nextPageName': "ToastHomePage1"
          },
          {
            'title': "Alert(View)",
            'imageSource': imageSource,
            'nextPageName': OverlayUtilRouters.alertUtilHomePage,
          },
          {
            'title': "ActionSheet(View)",
            'imageSource': imageSource,
            'nextPageName': OverlayUtilRouters.actionsheetUtilHomePage,
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
