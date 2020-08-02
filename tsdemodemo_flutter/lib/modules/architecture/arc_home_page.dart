import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_result_page4.dart';
import 'package:tsdemodemo_flutter/modules/architecture/normal/theme_result_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_result_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc/theme_result_page3.dart';

class TSArcHomePage extends StatefulWidget {
  TSArcHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TSArcHomePageState createState() => _TSArcHomePageState();
}

class _TSArcHomePageState extends State<TSArcHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设计模式首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            tsButton('正常设计模式', ThemeResultPage1()),
            tsButton('Provider设计模式', ThemeResultPage2()),
            tsButton('Provider设计模式2', ThemeResultPage2PP().myAppWidget()),
            tsButton('BloC设计模式', ThemeResultPage3()),
            tsButton('BloC_Provider设计模式', ThemeResultPage4()),
            // moduleHomeButton(),
          ],
        ),
      ),
    );
  }

  // 按钮
  FlatButton tsButton(title, Widget pageWidget) {
    return FlatButton(
      child: Text(title),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => pageWidget));
      },
    );
  }
}
