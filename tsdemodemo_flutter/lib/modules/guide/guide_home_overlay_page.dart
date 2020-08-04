import 'package:flutter/material.dart';

class GuideOverlayPage extends StatefulWidget {
  GuideOverlayPage({Key key}) : super(key: key);

  @override
  _GuideOverlayPageState createState() => _GuideOverlayPageState();
}

class _GuideOverlayPageState extends State<GuideOverlayPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _pageWidget(),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text('搜索模块'),
    );
  }

  Widget _pageWidget() {
    // return Image(image: AssetImage('lib/Resources/report/arrow_right.png'));
    return Image(
      image: NetworkImage(
          'https://mbd.baidu.com/newspage/data/landingsuper?context=%7B%22nid%22%3A%22news_9617871027890325579%22%7D&n_type=0&p_from=1'),
    );
  }
}
