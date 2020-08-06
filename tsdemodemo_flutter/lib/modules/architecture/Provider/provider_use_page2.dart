/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_independent_notificater.dart';

class ProviderUsePage2 extends StatefulWidget {
  ProviderUsePage2({Key key}) : super(key: key);

  @override
  _ProviderUsePage2State createState() => _ProviderUsePage2State();
}

class _ProviderUsePage2State extends State<ProviderUsePage2> {
  ThemeIndependentChangeNotifier _globalChangeNotifier =
      ThemeIndependentChangeNotifier('Default2');

  @override
  Widget build(BuildContext context) {
    // 创建 Provider
    // return ChangeNotifierProvider<ThemeChangeNotifier>.value(
    //   value: _globalThemeChangeNotifie = ThemeChangeNotifier('Default'),
    //   child: _pageWidget(),
    // );
    // return ChangeNotifierProvider<ThemeChangeNotifier>.value(
    //   value: _globalChangeNotifier,
    //   child: _pageWidget(),
    // );
    return _pageWidget();
  }

  Widget _pageWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider的使用方式2(错误)'),
      ),
      body: Center(
        // Provider 使用全局变量的写法
        child: ChangeNotifierProvider<ThemeIndependentChangeNotifier>.value(
          value: _globalChangeNotifier,
          child: Builder(
            builder: (context) {
              print('[全局方式]获取到的主题为:' + _globalChangeNotifier.themeString);
              return FlatButton(
                child: Text("[全局方式]修改主题(Provider 使用方式2):" +
                    _globalChangeNotifier.themeString),
                textColor: Color(0xfff5b63c),
                onPressed: () {
                  _globalChangeNotifier.changeTheme('yyy');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
