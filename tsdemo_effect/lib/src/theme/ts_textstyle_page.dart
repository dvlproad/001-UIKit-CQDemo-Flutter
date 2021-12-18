import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSTextStylePage extends StatefulWidget {
  TSTextStylePage({Key key}) : super(key: key);

  @override
  _TSTextStylePageState createState() => new _TSTextStylePageState();
}

class _TSTextStylePageState extends State<TSTextStylePage> {
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
          child: Text(
            'Bold',
            style: BoldTextStyle(fontSize: 17, color: Colors.red),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: Text(
            'Medium',
            style: MediumTextStyle(fontSize: 17, color: Colors.red),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: Text(
            'Medium',
            style: MediumTextStyle(fontSize: 17, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
