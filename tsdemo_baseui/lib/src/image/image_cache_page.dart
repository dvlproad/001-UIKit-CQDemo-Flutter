import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_image_kit/flutter_image_kit.dart';

class TSImageCachePage extends StatefulWidget {
  TSImageCachePage({Key key}) : super(key: key);

  @override
  _TSImageCachePageState createState() => new _TSImageCachePageState();
}

class _TSImageCachePageState extends State<TSImageCachePage> {
  String assetName = 'assets/zhangjiajie.jpg';

  String netImagePrefix =
      'https://bojuehui-1302324914.cos.ap-guangzhou.myqcloud.com/image/tag_bg';

  String networkUrl;

  @override
  void initState() {
    super.initState();

    networkUrl = '$netImagePrefix/shuma_bg%403xz.png';
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
    ImageProvider imageProviderAsset =
        AssetImage(assetName, package: "tsdemo_baseui");
    ImageProvider imageProviderNetwork = NetworkImage(networkUrl);
    return Column(
      children: <Widget>[
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.pink,
          title: '切换图片到节日',
          onPressed: () {
            networkUrl = '$netImagePrefix/jieri_bg2%403xz.png';
            setState(() {});
          },
        ),
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.pink,
          title: '切换图片到美妆',
          onPressed: () {
            networkUrl = '$netImagePrefix/meizhuang_bg%403xz.png';
            setState(() {});
          },
        ),
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.pink,
          title: '切换图片到潮玩',
          onPressed: () {
            networkUrl = '$netImagePrefix/chaowan_bg%403xz.png';
            setState(() {});
          },
        ),
        CQTSThemeBGButton(
          bgColorType: CQTSThemeBGType.pink,
          title: '切换图片到数码',
          onPressed: () {
            networkUrl = '$netImagePrefix/shuma_bg%403xz.png';
            setState(() {});
          },
        ),
        TolerantNetworkImage(
          imageUrl: networkUrl,
          width: 100,
          height: 300,
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
