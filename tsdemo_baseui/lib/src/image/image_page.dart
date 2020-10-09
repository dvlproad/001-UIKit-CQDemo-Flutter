import 'package:flutter/material.dart';

// [Flutter - 图片Image组件](https://www.jianshu.com/p/107b1fb6a1d3)

class TSImagePage extends StatefulWidget {
  TSImagePage({Key key}) : super(key: key);

  @override
  _TSImagePageState createState() => new _TSImagePageState();
}

class _TSImagePageState extends State<TSImagePage> {
  String assetName = 'assets/zhangjiajie.jpg';
  String networkUrl =
      'https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1600222338&di=caf255ee59c5f36cbf96c04aed8303dc&src=http://a4.att.hudong.com/22/59/19300001325156131228593878903.jpg';

  @override
  void initState() {
    super.initState();
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
        title: Text('测试 Image 显示', style: TextStyle(fontSize: 17)),
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
        Text('new Image 从ImageProvider获取图片'),
        Image(image: imageProviderAsset, height: 100, width: 100),
        Image(image: imageProviderNetwork, height: 100, width: 100),
      ],
    );
  }

  Widget themeBorderButtonsWidget() {
    return Column(
      children: <Widget>[
        Text('new Image.asset 加载asset项目资源中的文件'),
        Image.asset(
          assetName,
          package: "tsdemo_baseui",
          height: 100,
          width: 100,
        ),
        Text('new Image.network 从URL获取网络图片'),
        Image.network(networkUrl, height: 100, width: 100),
        Text('new Image.file 从File获取本地文件图片'),
        // Image.network(networkUrl, height: 100, width: 100),
        // Image image = Image.file(File(photoAlbumPath));
        Text('new Image.memory 加载Uint8List 的图片'),
        // Image.network(networkUrl, height: 100, width: 100),
      ],
    );
  }

  Widget themeStateButtonsWidget() {
    return new Column(
      children: <Widget>[
        Text('占位图的占位图'),
      ],
    );
  }
}
