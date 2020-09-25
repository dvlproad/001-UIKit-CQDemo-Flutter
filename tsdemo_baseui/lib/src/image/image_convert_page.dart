import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/base-uikit/bg_border_widget.dart';

// [Flutter - 图片Image组件](https://www.jianshu.com/p/107b1fb6a1d3)

class TSImageConvertPage extends StatefulWidget {
  TSImageConvertPage({Key key}) : super(key: key);

  @override
  _TSImageConvertPageState createState() => new _TSImageConvertPageState();
}

class _TSImageConvertPageState extends State<TSImageConvertPage> {
  String assetName = 'lib/Resources/zhangjiajie.jpg';
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
          title: Text('测试 Image 转换', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 内容视图
  Widget contentWidget() {
    Image image = Image.network(networkUrl, height: 100, width: 100);
    ImageProvider imageProviderFromImage = image.image;

    // ImageProvider imageProviderAsset = AssetImage(assetName);
    // ImageProvider imageProviderNetwork = NetworkImage(networkUrl);

    return new Column(
      children: <Widget>[
        Text('Image 转 ImageProvider2'),
        Image(image: imageProviderFromImage, height: 100, width: 100),
        Container(
          height: 100,
          child: CJBGImageWidget(
            backgroundImage: imageProviderFromImage,
            child: Container(
              color: Colors.red,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }
}
