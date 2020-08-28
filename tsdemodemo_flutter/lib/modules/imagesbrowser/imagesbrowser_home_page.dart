import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/cjts/tableview/CJTSSectionTableView.dart';
import 'package:tsdemodemo_flutter/cjts/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_page.dart';

class TSImagesBrowserHomePage extends CJTSBasePage {
  TSImagesBrowserHomePage({Key key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState
    extends CJTSBasePageState<TSImagesBrowserHomePage> {
  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('图片浏览首页'),
    );
  }

  @override
  Widget contentWidget() {
    var sectionModels = [
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
            // 'nextPageName': ImagesBrowserRouters.imagesBrowserPage,
            'actionBlock': () {
              List<String> egImages = <String>[
                'http://pic1.win4000.com/pic/f/04/4f085d0c9b.gif',
                'https://photo.tuchong.com/14649482/f/601672690.jpg',
                'https://photo.tuchong.com/17325605/f/641585173.jpg',
                'https://photo.tuchong.com/3541468/f/256561232.jpg',
                'http://pic1.win4000.com/pic/c/c1/25cbd37070.gif',
                'https://photo.tuchong.com/16709139/f/278778447.jpg',
                'https://photo.tuchong.com/15195571/f/233361383.jpg',
                'https://photo.tuchong.com/5040418/f/43305517.jpg',
                'https://photo.tuchong.com/3019649/f/302699092.jpg',
                'http://z.aisaiya.com/gif/202006/ea08c82cfcc6501f0edec03a3c7b241f.gif',
              ];
              int currentIndex = 1;

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TSImagesBrowserPage(
                    images: egImages,
                    currentIndex: currentIndex,
                  ),
                ),
              );
            }
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
