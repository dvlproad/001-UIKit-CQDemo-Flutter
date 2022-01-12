import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_image_kit/flutter_image_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TSImageCachePage extends StatefulWidget {
  TSImageCachePage({Key key}) : super(key: key);

  @override
  _TSImageCachePageState createState() => new _TSImageCachePageState();
}

class _TSImageCachePageState extends State<TSImageCachePage> {
  String assetName = 'assets/zhangjiajie.jpg';

  String netImagePrefix =
      'https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com/image/tag_bg';

  List networkImageModels;
  int showImageIndex;

  List<ImageProvider> imageProviders_network;

  @override
  void initState() {
    super.initState();

    networkImageModels = [
      {
        "title": '节日',
        "networkUrl": '$netImagePrefix/jieri_bg2%403xz.png',
      },
      {
        "title": '美妆',
        "networkUrl": '$netImagePrefix/meizhuang_bg%403xz.png',
      },
      {
        "title": '潮玩',
        "networkUrl": '$netImagePrefix/chaowan_bg%403xz.png',
      },
      {
        "title": '数码',
        "networkUrl": '$netImagePrefix/shuma_bg%403xz.png',
      },
    ];
    showImageIndex = 0;

    imageProviders_network = [];
    for (var i = 0; i < networkImageModels.length; i++) {
      Map networkImageMap = networkImageModels[i];

      String networkUrl = networkImageMap['networkUrl'];
      ImageProvider imageProvider_network =
          CachedNetworkImageProvider(networkUrl);
      imageProviders_network.add(imageProvider_network);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: appBar(),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: contentWidget(),
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
      child: AppBar(
        title: Text('测试 Image 缓存和大图切换白屏', style: TextStyle(fontSize: 17)),
      ),
      preferredSize: Size.fromHeight(44),
    );
  }

  /// 内容视图
  Widget contentWidget() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double loginIconBottom = screenHeight <= 667 ? 50 : 71;

    return new ListView(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: themeBGButtonsWidget(),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: themeBorderButtonsWidget(),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: themeStateButtonsWidget(),
        ),
      ],
    );
  }

  Widget themeBGButtonsWidget() {
    Map networkImageMap = networkImageModels[showImageIndex];

    String networkUrl = networkImageMap['networkUrl'];

    ImageProvider imageProvider_network =
        imageProviders_network[showImageIndex];

    return Column(
      children: <Widget>[
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.pink,
          title: '切换掉图片${networkImageMap['title']}',
          onPressed: () {
            showImageIndex++;
            if (showImageIndex >= networkImageModels.length) {
              showImageIndex = 0;
            }
            setState(() {});
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TolerantNetworkImage(
              imageUrl: networkUrl,
              width: 100,
              height: 300,
            ),
            Container(width: 10),
            Image(
              image: imageProvider_network,
              width: 100,
              height: 300,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ],
    );
  }

  Widget themeBorderButtonsWidget() {
    return Column(
      children: <Widget>[
        Text('占位图的占位图1'),
      ],
    );
  }

  Widget themeStateButtonsWidget() {
    return new Column(
      children: <Widget>[
        Text('占位图的占位图2'),
      ],
    );
  }
}
