/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 16:19:36
 * @Description: 
 */
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:tsdemo_baseui/src/baseui_routes.dart';
import './image_cache_page.dart';

class TSImageHomePage extends CJTSBasePage {
  TSImageHomePage({Key? key}) : super(key: key);

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
          {
            'title': "Image(缓存)",
            // 'nextPageName': BaseUIKitRouters.imageConvertPage,
            'actionBlock': () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return TSImageCachePage();
                  },
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
