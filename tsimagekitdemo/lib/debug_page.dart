/*
 * @Author: dvlproad
 * @Date: 2023-09-18 16:20:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-19 11:14:05
 * @Description: 
 */
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';
// import 'package:flutter_foundation_base/flutter_foundation_base.dart';
// import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
// import 'package:flutter_effect_kit/flutter_effect_kit.dart';

import 'package:extended_image/extended_image.dart';
import 'package:path_provider/path_provider.dart';

import 'test_data_vientiane.dart';

class DebugPage extends StatefulWidget {
  const DebugPage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<DebugPage> {
  String bgUrl =
      "https://pics6.baidu.com/feed/32fa828ba61ea8d31d2b6af0778ff742241f584f.jpeg@f_auto?token=ec9fb18c52b405fa5e542b3ddc1314b9";
  String vientianeImageUrl =
      "https://images.xihuanwu.com/mcms/uploads/1647604960983901.jpg";
  String homePath = "unknow";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getDir();
  }

  getDir() async {
    Directory homeDir = await getApplicationCacheDirectory();
    setState(() {
      homePath = homeDir.path;
      Clipboard.setData(ClipboardData(text: "open $homePath"));
      debugPrint("open $homePath");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Debug'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _renderItem(
                'document $homePath',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  Clipboard.setData(ClipboardData(text: homePath));
                },
              ),
              _renderItem(
                '删除图片缓存',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  await clearDiskCachedImages();
                  clearMemoryImageCache();
                  // ToastUtil.showMessage('本地、内存 缓存清空');
                },
              ),
              _renderItem(
                '下载图片',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  getNetworkImageData(bgUrl);

                  for (var i = 0; i < 100; i++) {
                    String iImageUrl = TestDataVientiane.newImageUrl(
                      vientianeImageUrl,
                      width: (50 + i).toDouble(),
                    );

                    getNetworkImageData(iImageUrl);
                    sleep(const Duration(milliseconds: 10));
                  }
                },
              ),
              ExtendedImage.network(bgUrl),
              // _rennderItemPage(title: '日志上报页', page: ImLogPage()),
            ],
          ),
        ],
      ),
    );
  }

  // _rennderItemPage({required String title, required Widget page}) {
  //   return ImageTitleTextValueCell(
  //     title: title,
  //     textValue: '',
  //     onTap: () {
  //       Navigator.push(context, MaterialPageRoute(
  //         builder: (context) {
  //           return page;
  //         },
  //       ));
  //     },
  //   );
  // }

  _renderItem(
    String title, {
    required Function onTap,
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        children: [
          Container(
            height: 44,
            alignment: alignment,
            child: Text(title),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          )
        ],
      ),
    );
  }
}
