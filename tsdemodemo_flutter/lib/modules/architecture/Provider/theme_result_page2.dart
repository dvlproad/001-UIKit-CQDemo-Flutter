/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_independent_notificater.dart';
// import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_result_page2_widget.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_setting_page2.dart';

class ThemeResultPage2 extends StatefulWidget {
  ThemeResultPage2({Key key}) : super(key: key);

  @override
  _ThemeResultPage2State createState() => _ThemeResultPage2State();
}

class _ThemeResultPage2State extends State<ThemeResultPage2> {
  String _currentThemeString;

  ThemeIndependentChangeNotifier _themeChangeNotifier =
      ThemeIndependentChangeNotifier('Default2');

  @override
  void initState() {
    super.initState();

    _currentThemeString = 'Default';
  }

  // @override
  // Widget build(BuildContext context) {
  //   return MultiProvider(
  //     providers: [
  //       ChangeNotifierProvider<ThemeChangeNotifier>.value(
  //           value: ThemeChangeNotifier('Default'))
  //     ],
  //     builder: (context, child) {
  //       // 将获取方式由【原本的从导航栏返回的】改成【Provider】
  //       ThemeChangeNotifier _themeChangeNotifier =
  //           Provider.of<ThemeChangeNotifier>(context);
  //       _currentThemeString = _themeChangeNotifier.themeString;

  //       return _pageWidget();
  //     },
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    // 创建 Provider
    return ChangeNotifierProvider<ThemeIndependentChangeNotifier>.value(
      value: _themeChangeNotifier,
      child: _pageWidget(),
    );
    // return _pageWidget();
  }

  Widget _pageWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('设计模式-Provider'),
      ),
      body: Center(
        child: Consumer<ThemeIndependentChangeNotifier>(
          builder: (context, consumerNotifier, child) {
            // ThemeChangeNotifier _lastUsedNotifier =
            //     Provider.of<ThemeChangeNotifier>(context); // 需要在这里获取
            // ThemeChangeNotifier _lastUsedNotifier = consumerNotifier;
            print('[全局方式]获取到的主题为:' + consumerNotifier.themeString);

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('当前主题为' + consumerNotifier.themeString),
                  themeSettingButton(consumerNotifier),
                ]);
          },
        ),
      ),
    );
  }

  // 进入修改主题页面的按钮
  FlatButton themeSettingButton(
      ThemeIndependentChangeNotifier mThemeChangeNotifier) {
    // ThemeChangeNotifier _lastUsedNotifier = mThemeChangeNotifier;
    ThemeIndependentChangeNotifier _lastUsedNotifier = _themeChangeNotifier;
    return FlatButton(
      child:
          Text("[全局方式]修改主题(Provider 使用方式3):" + _lastUsedNotifier.themeString),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        // _lastUsedNotifier.changeTheme('abc');
        // return;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ThemeSettingPage2(themeString: _currentThemeString),
          ),
        ).then((value) {
          // 接收下一个页面返回回来的数据
          String themeString = value as String;
          print('修改后的主题为' + themeString);
          _currentThemeString = themeString;
          // setState(() {});

          _lastUsedNotifier.changeTheme(_currentThemeString);
        });
      },
    );
  }
}
