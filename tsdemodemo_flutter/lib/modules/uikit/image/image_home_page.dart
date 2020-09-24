import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_routes.dart';

class TSImageHomePage extends CJTSBasePage {
  TSImageHomePage({Key key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState extends CJTSBasePageState<TSImageHomePage> {
  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('图片首页'),
    );
  }

  @override
  Widget contentWidget() {
    var sectionModels = [
      {
        'theme': "ImageProvider",
        'values': [
          {
            'title': "Image(创建)",
            'nextPageName': BaseUIKitRouters.imageviewPage,
            // 'actionBlock': () {}
          },
          {
            'title': "Image(转换)",
            'nextPageName': BaseUIKitRouters.imageConvertPage,
            // 'actionBlock': () {}
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
