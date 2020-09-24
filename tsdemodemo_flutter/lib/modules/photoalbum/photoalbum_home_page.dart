import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/tableview/CJTSSectionTableView.dart';
import 'package:flutter_demo_kit/base/CJTSBasePage.dart';
import 'package:tsdemodemo_flutter/modules/photoalbum/photoalbum_adddelete_page.dart';
import 'package:tsdemodemo_flutter/modules/photoalbum/photoalbum_selected_page.dart';

class TSPhotoAlbumHomePage extends CJTSBasePage {
  TSPhotoAlbumHomePage({Key key}) : super(key: key);

  @override
//  _CJTSTableHomeBasePageState createState() => _CJTSTableHomeBasePageState();
  CJTSBasePageState getState() {
    return _CJTSTableHomeBasePageState();
  }
}

class _CJTSTableHomeBasePageState
    extends CJTSBasePageState<TSPhotoAlbumHomePage> {
  @override
  PreferredSizeWidget appBar() {
    return AppBar(
      title: Text('图片浏览首页'),
    );
  }

  @override
  Widget contentWidget() {
    var sectionModels = [
      {
        'theme': "完整组件",
        'values': [
          {
            'title': "PhotoAlbum Select(相册选择)",
            // 'nextPageName': ImagesBrowserRouters.imagesBrowserPage,
            'actionBlock': () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TSPhotoAlbumSelectPage(),
                ),
              );
            }
          },
          {
            'title': "Images AddDelete(图片添加)",
            // 'nextPageName': ImagesBrowserRouters.imagesBrowserPage,
            'actionBlock': () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TSPhotoAlbumAddDeletePage(),
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
