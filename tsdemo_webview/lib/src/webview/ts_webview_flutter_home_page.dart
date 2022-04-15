import 'package:flutter/material.dart';
import 'package:flutter_webview/flutter_webview.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TSWebViewFlutterHomePage extends StatefulWidget {
  TSWebViewFlutterHomePage({Key key}) : super(key: key);

  @override
  _TSWebViewFlutterHomePageState createState() =>
      new _TSWebViewFlutterHomePageState();
}

class _TSWebViewFlutterHomePageState extends State<TSWebViewFlutterHomePage> {
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
          title: Text('测试 Test', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 内容视图
  Widget contentWidget() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double loginIconBottom = screenHeight <= 667 ? 50 : 71;

    return new Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeBGButton(
            title: 'webview_flutter 的 demo(暂无)',
            onPressed: () {
              // Route route =
              //     MaterialPageRoute(builder: (context) => TSWebViewDemoPage());
              // Navigator.push(context, route);
            },
          ),
        ),
        /*
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeBGButton(
            title: 'webview_flutter 的 二次封装(无效网络地址)',
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (context) => BaseWebPage(
                  // Url: 'https://www.baidu.com',
                  Url:
                      'http://dev.game.h5.xxx.com/id=1470575934695165952&top=20.0&bottom=0.0',
                ),
              );
              Navigator.push(context, route);
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeBGButton(
            title: 'WebPage本地地址(暂无)',
            onPressed: () {
              // Route route = MaterialPageRoute(
              //   builder: (context) => BaseWebPage(
              //     Url: '../test_oa_h5js.html',
              //   ),
              // );
              // Navigator.push(context, route);
            },
          ),
        ),
        */
      ],
    );
  }
}
