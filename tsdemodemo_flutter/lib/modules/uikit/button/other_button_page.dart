import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/button/other_textbutton.dart';

class TSOtherButtonsPage extends StatefulWidget {
  TSOtherButtonsPage({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  _TSOtherButtonsPageState createState() => new _TSOtherButtonsPageState();
}

class _TSOtherButtonsPageState extends State<TSOtherButtonsPage> {
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
          title: Text('测试 Other Button', style: TextStyle(fontSize: 17)),
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
          child: otherButtonsWidget(),
        ),
      ],
    );
  }

  Widget otherButtonsWidget() {
    return Column(
      children: <Widget>[
        CQWhiteThemeBGButton(
          text: "我知道了",
          onPressed: () {},
        ),
      ],
    );
  }
}
