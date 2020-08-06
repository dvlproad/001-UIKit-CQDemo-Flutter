/// 主页
import 'package:flutter/material.dart';

class ThemeSettingPage1 extends StatefulWidget {
  final String themeString;

  ThemeSettingPage1({
    Key key,
    @required this.themeString,
  }) : super(key: key);

  @override
  _ThemeSettingPage1State createState() => _ThemeSettingPage1State();
}

class _ThemeSettingPage1State extends State<ThemeSettingPage1> {
  String _currentThemeString;

  @override
  void initState() {
    super.initState();
    _currentThemeString = widget.themeString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设计模式-普通'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              child: Text("主题修改成 Default"),
              textColor: Color(0xfff5b63c),
              onPressed: () {
                _currentThemeString = 'Default';
                setState(() {});
              },
            ),
            FlatButton(
              child: Text("主题修改成 Theme2"),
              textColor: Color(0xfff5b63c),
              onPressed: () {
                _currentThemeString = 'Theme2';
                setState(() {});
              },
            ),
            Text('当前选择的主题是' + _currentThemeString),
            _themeChangeButton(),
          ],
        ),
      ),
    );
  }

  // 确认修改主题的按钮
  FlatButton _themeChangeButton() {
    return FlatButton(
      child: Text("确认修改成" + _currentThemeString),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        Navigator.pop(context, _currentThemeString); //返回上一页并携带参数
      },
    );
  }
}
