import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

class TSThemeButtonPage extends StatefulWidget {
  TSThemeButtonPage({Key key}) : super(key: key);

  @override
  _TSThemeButtonPageState createState() => new _TSThemeButtonPageState();
}

class _TSThemeButtonPageState extends State<TSThemeButtonPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
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
          title: Text('测试 Theme Button', style: TextStyle(fontSize: 17)),
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
          child: themeBGButtonsWidget(),
        ),
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: themeBorderButtonsWidget(),
        ),
      ],
    );
  }

  Widget themeBGButtonsWidget() {
    return Column(
      children: <Widget>[
        PinkThemeBGButton(
          title: '以主题色为背景的按钮',
          titleStyle: PingFang_Bold_FontSize(15.0),
          cornerRadius: 20,
          enable: true,
          onPressed: () {},
        ),
        PinkThemeBGButton(
          title: '以主题色为背景的按钮',
          enable: false,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget themeBorderButtonsWidget() {
    return Column(
      children: <Widget>[
        PinkThemeBorderButton(
          title: '以主题色为边框的按钮',
          titleStyle: TextStyle(
            fontFamily: 'PingFang SC',
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
          enable: true,
          onPressed: () {},
        ),
        PinkThemeBorderButton(
          title: '以主题色为边框的按钮',
          enable: false,
          onPressed: () {},
        ),
        BlackThemeBorderButton(
          title: '以主题色(黑色)为边框的按钮',
          enable: true,
          onPressed: () {},
        ),
        BlackThemeBorderButton(
          title: '以主题色(黑色)为边框的按钮',
          enable: false,
          onPressed: () {},
        ),
      ],
    );
  }

  TextStyle PingFang_Bold_FontSize(double fontSize) {
    return TextStyle(
      fontFamily: 'PingFang SC',
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );
  }
}
