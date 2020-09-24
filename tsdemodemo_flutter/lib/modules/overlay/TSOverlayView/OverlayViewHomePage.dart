import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/base/CJTSBasePage.dart';
import 'package:flutter_demo_kit/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/overlay_view_routes.dart';

class OverlayViewHomePage extends CJTSBasePage {
  final String title;

  OverlayViewHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CQModulesHomePageState();
  }
}

class _CQModulesHomePageState extends CJTSBasePageState<OverlayViewHomePage> {
  var sectionModels = [];

  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text(widget.title ?? 'Overlay View 首页'),
    );
  }

  @override
  Widget contentWidget() {
    String imageSource =
        'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3460118221,780234760&fm=26&gp=0.jpg';

    sectionModels = [
      {
        'title': "Toast(View)-暂无",
        'imageSource': imageSource,
        'nextPageName': "ToastHomePage1"
      },
      {
        'title': "ActionSheet(View)",
        'imageSource': imageSource,
        'nextPageName': "ActionSheetHomePage1"
      },
      {
        'title': "Alert(View)",
        'imageSource': imageSource,
        'nextPageName': OverlayViewRouters.alertViewHomePage,
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
