/*
 * @Author: dvlproad
 * @Date: 2023-09-18 16:20:23
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-09-19 17:00:41
 * @Description: 
 */
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

class TSTooManyImagePage extends StatefulWidget {
  const TSTooManyImagePage({Key? key}) : super(key: key);

  @override
  _TSImagesPageState createState() => _TSImagesPageState();
}

class _TSImagesPageState extends State<TSTooManyImagePage> {
  String bgUrl =
      "https://pics6.baidu.com/feed/32fa828ba61ea8d31d2b6af0778ff742241f584f.jpeg@f_auto?token=ec9fb18c52b405fa5e542b3ddc1314b9";
  String vientianeImageUrl =
      "https://images.xihuanwu.com/mcms/uploads/1647604960983901.jpg";
  String homePath = "unknow";

  int vientianeImageWidthStart = 50;
  int vientianeImageWidthEnd = 100; // 万象图片宽度的结束值

  int showImageCount = 1;

  int? allCount;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    getDir();

    showImageCount = 1;
  }

  getDir() async {
    Directory homeDir = await getApplicationCacheDirectory();
    setState(() {
      homePath = homeDir.path;
      Clipboard.setData(ClipboardData(text: "open $homePath"));
      debugPrint("open $homePath");
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    vientianeImageWidthEnd = prefs.getInt("kVientianeImageWidthEndKey") ?? 50;

    allCount = vientianeImageWidthEnd - vientianeImageWidthStart;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Images'),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _renderItem(
                title: '显示两张',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  setState(() {
                    showImageCount = 2;
                  });
                },
              ),
              _renderItem(
                title: '多显示100张(显示到${showImageCount + 100}张)',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  setState(() {
                    showImageCount = showImageCount + 100;
                  });
                },
              ),
              _renderItem(
                title: '全部显示(共${allCount ?? 0}张)',
                alignment: Alignment.centerLeft,
                onTap: () async {
                  setState(() {
                    showImageCount = allCount ?? 0;
                  });
                },
              ),
              // 注意，为了在嵌套的 ListView 中正常工作，我们将 shrinkWrap 属性设置为 true，这样内部 ListView 将根据其内容的高度自动调整大小。
              // 我们还将 physics 属性设置为 ClampingScrollPhysics()，以避免与外部 ListView 的滚动行为冲突。
              ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: showImageCount,
                itemBuilder: (context, index) {
                  int imageWidthStartValue =
                      vientianeImageWidthStart + index + 1;
                  double imageWidthStart = imageWidthStartValue.toDouble();
                  String indexImageUrl =
                      TSTooManyImageDataVientiane.newImageUrl(
                    vientianeImageUrl,
                    width: imageWidthStart,
                  );

                  return Container(
                    color: Colors.amber,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ExtendedImage.network(
                          indexImageUrl,
                          width: imageWidthStart,
                          height: 100,
                        ),
                        Text("$imageWidthStartValue:$indexImageUrl"),
                      ],
                    ),
                  );
                },
              ),
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
