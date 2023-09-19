/*
 * @Author: dvlproad
 * @Date: 2023-09-18 16:20:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-19 17:00:28
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
import 'package:shared_preferences/shared_preferences.dart';

import 'ts_toomany_image_data_vientiane.dart';
import 'ts_toomany_image_page.dart';

class TSTooManyImageHomePage extends StatefulWidget {
  const TSTooManyImageHomePage({Key? key}) : super(key: key);

  @override
  _DebugPageState createState() => _DebugPageState();
}

class _DebugPageState extends State<TSTooManyImageHomePage> {
  String bgUrl =
      "https://pics6.baidu.com/feed/32fa828ba61ea8d31d2b6af0778ff742241f584f.jpeg@f_auto?token=ec9fb18c52b405fa5e542b3ddc1314b9";
  String vientianeImageUrl =
      "https://images.xihuanwu.com/mcms/uploads/1647604960983901.jpg";
  String cachePath = "unknow";

  int vientianeImageWidthStart = 50;
  int vientianeImageWidthEnd = 50; // 万象图片宽度的结束值

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
    Directory tempDir = await getTemporaryDirectory();
    Directory cacheDir = await getApplicationCacheDirectory();
    setState(() {
      debugPrint("tempDir: open ${tempDir.path}");

      cachePath = cacheDir.path;
      Clipboard.setData(ClipboardData(text: "open $cachePath"));
      debugPrint("cacheDir: open $cachePath");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    vientianeImageWidthEnd =
        prefs.getInt("kVientianeImageWidthEndKey") ?? vientianeImageWidthStart;
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
                title: 'cachePath: $cachePath',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  Clipboard.setData(ClipboardData(text: cachePath));
                },
              ),
              _renderItem(
                title: '删除图片缓存',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  await clearDiskCachedImages();
                  clearMemoryImageCache();
                  // ToastUtil.showMessage('本地、内存 缓存清空');
                },
              ),
              _renderItem(
                title:
                    '下载图片 下载($vientianeImageWidthEnd - ${vientianeImageWidthEnd + 100})',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  getNetworkImageData(bgUrl);

                  int vientianeImageNewCount = 100;
                  for (var i = 0; i < vientianeImageNewCount; i++) {
                    double imageWidthStart =
                        (vientianeImageWidthEnd + i + 1).toDouble();
                    String iImageUrl = TSTooManyImageDataVientiane.newImageUrl(
                      vientianeImageUrl,
                      width: imageWidthStart,
                    );

                    getNetworkImageData(iImageUrl);
                    sleep(const Duration(milliseconds: 10));
                  }

                  setState(() {
                    vientianeImageWidthEnd += vientianeImageNewCount;
                  });

                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setInt(
                      "kVientianeImageWidthEndKey", vientianeImageWidthEnd);
                },
              ),
              _rennderItemPage(
                  title: '图片列表页', page: const TSTooManyImagePage()),
            ],
          ),
        ],
      ),
    );
  }

  _rennderItemPage({required String title, required Widget page}) {
    // return ImageTitleTextValueCell(
    return _renderItem(
      title: title,
      textValue: '',
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return page;
          },
        ));
      },
    );
  }

  _renderItem({
    required title,
    String? textValue,
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
