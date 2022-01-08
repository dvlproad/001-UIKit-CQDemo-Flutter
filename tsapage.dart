import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';

class TSPage extends StatefulWidget {
  TSPage({Key key}) : super(key: key);

  @override
  _TSPageState createState() => new _TSPageState();
}

class _TSPageState extends State<TSPage> {
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
            bgColorType: CQTSThemeBGType.pink,
            title: '1',
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeBGButton(
            bgColorType: CQTSThemeBGType.pink,
            title: '2',
            onPressed: () {},
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: CQTSThemeBGButton(
            bgColorType: CQTSThemeBGType.pink,
            title: '3',
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}
