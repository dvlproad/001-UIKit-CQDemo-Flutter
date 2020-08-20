import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/button/textbutton.dart';

class TSThemeButtonPage extends StatefulWidget {
  TSThemeButtonPage({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

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
        Padding(
          padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
          child: themeStateButtonsWidget(),
        ),
      ],
    );
  }

  Widget themeBGButtonsWidget() {
    return Column(
      children: <Widget>[
        CQPinkThemeBGButton(
          title: '以主题色为背景的按钮',
          enable: true,
          onPressed: () {},
        ),
        CQPinkThemeBGButton(
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
        CQPinkThemeBorderButton(
          title: '以主题色为边框的按钮',
          enable: true,
          onPressed: () {},
        ),
        CQPinkThemeBorderButton(
          title: '以主题色为边框的按钮',
          enable: false,
          onPressed: () {},
        ),
      ],
    );
  }

  Widget themeStateButtonsWidget() {
    return new Column(
      children: <Widget>[
        CQPinkThemeStateButton(
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: false,
          enable: true,
          onPressed: () {},
        ),
        CQPinkThemeStateButton(
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: false,
          enable: false,
          onPressed: () {},
        ),
        CQPinkThemeStateButton(
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: true,
          enable: true,
          onPressed: () {},
        ),
        CQPinkThemeStateButton(
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: true,
          enable: false,
          onPressed: () {},
        ),
      ],
    );
  }
}
