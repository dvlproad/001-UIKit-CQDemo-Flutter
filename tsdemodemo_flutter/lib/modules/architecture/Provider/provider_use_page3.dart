/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_independent_notificater.dart';

class ProviderUsePage3 extends StatefulWidget {
  ProviderUsePage3({Key key}) : super(key: key);

  @override
  _ProviderUsePage3State createState() => _ProviderUsePage3State();
}

class _ProviderUsePage3State extends State<ProviderUsePage3> {
  @override
  Widget build(BuildContext context) {
    // 创建 Provider
    // return ChangeNotifierProvider<ThemeChangeNotifier>.value(
    //   value: _globalThemeChangeNotifie = ThemeChangeNotifier('Default'),
    //   child: _pageWidget(),
    // );
    return _pageWidget();
  }

  Widget _pageWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider的使用方式3(正确)'),
      ),
      body: Center(
        // Provider 使用 Consumer 的写法
        child: // ChangeNotifierProvider<ThemeChangeNotifier>.value(
            //   value: ThemeChangeNotifier('Default3'),
            ChangeNotifierProvider<ThemeIndependentChangeNotifier>(
          create: (context) => ThemeIndependentChangeNotifier('Default3'),
          // child: Builder(
          //   builder: (context) {
          child: Consumer<ThemeIndependentChangeNotifier>(
            builder: (context, consumerNotifier, child) {
              print('[全局方式]获取到的主题为:' + consumerNotifier.themeString);
              return FlatButton(
                child: Text("[全局方式]修改主题(Provider 使用方式3):" +
                    consumerNotifier.themeString),
                textColor: Color(0xfff5b63c),
                onPressed: () {
                  consumerNotifier.changeTheme('zzz');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
