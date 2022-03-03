import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import './photoalbum_adddelete_page.dart';
import './photoalbum_selected_page.dart';

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
      title: const Text('ImageAddDelete首页'),
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
                  builder: (context) => const TSPhotoAlbumSelectPage(),
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
                  builder: (context) => const TSPhotoAlbumAddDeletePage(),
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
