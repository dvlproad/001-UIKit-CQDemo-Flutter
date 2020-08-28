import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/commonui/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_routes.dart';

class TSImagesBrowserHomePage extends CJTSBasePage {
  final String title;

  TSImagesBrowserHomePage({Key key, this.title}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState
    extends CJTSBasePageState<TSImagesBrowserHomePage> {
  var sectionModels = [];

  @override
  Widget contentWidget() {
    sectionModels = [
      // {
      //   'theme': "组成组件",
      //   'values': [
      //     {
      //       'title': "ImagesCarousel(图片切换)",
      //       'nextPageName': ImagesBrowserRouters.imagesCarouselPage,
      //     },
      //     {
      //       'title': "ImagesZoomable(图片缩放)",
      //       'nextPageName': ImagesBrowserRouters.imagesZoomablePage,
      //     },
      //   ]
      // },
      {
        'theme': "完整组件",
        'values': [
          {
            'title': "ImagesBrowser(图片切换+缩放)",
            'nextPageName': ImagesBrowserRouters.imagesBrowserPage,
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
