import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/demo/TSSectionTableViewPage.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            uikitHomeButton(),
            moduleHomeButton(),
          ],
        ),
      ),
    );
  }

  // 进入UIKit主页的按钮
  FlatButton uikitHomeButton() {
    return FlatButton(
      child: Text("忘记密码?"),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TSSectionTableViewPage(),
//          settings: RouteSettings(arguments: userName),
          ),
        );
      },
    );
  }

  // 进入举报模块测试主页的按钮
  FlatButton moduleHomeButton() {
    return FlatButton(
      child: Text("举报+排行榜"),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        Navigator.pushNamed(context, Routers.moduleHomePage);
      },
    );
  }
}
