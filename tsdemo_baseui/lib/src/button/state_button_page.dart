import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

class TSStateButtonPage extends StatefulWidget {
  TSStateButtonPage({Key key}) : super(key: key);

  @override
  _TSStateButtonPageState createState() => new _TSStateButtonPageState();
}

class _TSStateButtonPageState extends State<TSStateButtonPage> {
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
          title: Text('测试 State Button', style: TextStyle(fontSize: 17)),
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
          child: themeStateButtonsWidget(),
        ),
      ],
    );
  }

  Widget themeStateButtonsWidget() {
    return new Column(
      children: <Widget>[
        ThemeStateButton(
          width: 300, // 不设置会根据内容自适应
          height: 80, // 不设置会根据内容自适应
          normalBGColorType: ThemeBGType.pink,
          normalTitle: '修改',
          selectedTitle: '提交',
          titleStyle: ButtonBoldTextStyle(fontSize: 25.0),
          cornerRadius: 20,
          selected: false,
          enable: true, // 不设置,默认ture
          onPressed: () {},
        ),
        ThemeStateButton(
          normalBGColorType: ThemeBGType.pink,
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: false,
          enable: false,
          onPressed: () {},
        ),
        ThemeStateButton(
          normalBGColorType: ThemeBGType.pink,
          normalTitle: '修改',
          selectedTitle: '提交',
          selected: true,
          enable: true,
          onPressed: () {},
        ),
        ThemeStateButton(
          normalBGColorType: ThemeBGType.pink,
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
