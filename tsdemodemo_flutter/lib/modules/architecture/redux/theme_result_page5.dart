/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/redux/theme_setting_page5.dart';

class ThemeResultPage5 extends StatefulWidget {
  ThemeResultPage5({Key key}) : super(key: key);

  @override
  _ThemeResultPage5State createState() => _ThemeResultPage5State();
}

class _ThemeResultPage5State extends State<ThemeResultPage5> {
  String _currentThemeString;

  @override
  void initState() {
    super.initState();

    _currentThemeString = 'Default';
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
            Text('当前主题为' + _currentThemeString),
            themeSettingButton(),
          ],
        ),
      ),
    );
  }

  // 进入修改主题页面的按钮
  FlatButton themeSettingButton() {
    return FlatButton(
      child: Text("进入修改主题"),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ThemeSettingPage5(themeString: _currentThemeString)),
        ).then((value) {
          // 接收下一个页面返回回来的数据
          String themeString = value as String;
          print('修改后的主题为' + themeString);
          _currentThemeString = themeString;
          setState(() {});
        });
      },
    );
  }
}
