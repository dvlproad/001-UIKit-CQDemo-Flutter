import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/util/util_routes.dart';

class TSUtilHomePage extends CJTSBasePage {
  final String title;

  TSUtilHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<TSUtilHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Util首页'),
    );
  }

  @override
  Widget contentWidget() {
    sectionModels = [
      {
        'theme': "Util",
        'values': [
          {
            'title': "DeviceInfo(设备信息)",
            'nextPageName': UtilRouters.deviceInfoPage,
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
