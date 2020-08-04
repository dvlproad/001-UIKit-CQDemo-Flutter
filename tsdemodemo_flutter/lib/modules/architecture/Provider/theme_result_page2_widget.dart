/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_notificater.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_setting_page2.dart';

class ThemeResultPage2Widget extends StatefulWidget {
  ThemeResultPage2Widget({Key key}) : super(key: key);

  @override
  _ThemeResultPage2WidgetState createState() => _ThemeResultPage2WidgetState();
}

class _ThemeResultPage2WidgetState extends State<ThemeResultPage2Widget> {
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
        title: Text('设计模式-Provider'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Consumer<ThemeChangeNotifier>(
            //     builder: (context, _cThemeChangeNotifier, child) {
            //   return Text('当前主题为' + _cThemeChangeNotifier.themeString);
            // }),
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
        Provider.of<ThemeChangeNotifier>(context)
            .changeTheme('_currentThemeString');
        return;
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  ThemeSettingPage2(themeString: _currentThemeString)),
        ).then((value) {
          // 接收下一个页面返回回来的数据
          String themeString = value as String;
          print('修改后的主题为' + themeString);
          _currentThemeString = themeString;
          // setState(() {});

          Provider.of<ThemeChangeNotifier>(context, listen: false)
              .changeTheme(_currentThemeString);
        });
      },
    );
  }
}
