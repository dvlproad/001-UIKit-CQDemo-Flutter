/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_independent_notificater.dart';

class ProviderUsePage1 extends StatefulWidget {
  ProviderUsePage1({Key key}) : super(key: key);

  @override
  _ProviderUsePage1State createState() => _ProviderUsePage1State();
}

class _ProviderUsePage1State extends State<ProviderUsePage1> {
  @override
  void initState() {
    super.initState();
  }

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
        title: Text('Provider的使用方式1(正确)'),
      ),
      body: Center(
        // Provider 使用局部变量的写法
        child: ChangeNotifierProvider<ThemeIndependentChangeNotifier>(
          create: (context) => ThemeIndependentChangeNotifier('Default1'),
          // ChangeNotifierProvider<ThemeChangeNotifier>.value(
          //   value: ThemeChangeNotifier('Default1'),
          child: Builder(
            builder: (context) {
              // 注意点1：必须在 Builder 中才能使用 Provider.of(context) 获取到
              ThemeIndependentChangeNotifier _localChangeNotifier =
                  Provider.of<ThemeIndependentChangeNotifier>(context);
              print('[局部方式]获取到的主题为:' + _localChangeNotifier.themeString);
              return FlatButton(
                child: Text("[局部方式]修改主题(Provider 使用方式1):" +
                    _localChangeNotifier.themeString),
                textColor: Color(0xfff5b63c),
                onPressed: () {
                  // 注意点2：因为树不一样，所以无法在按钮的 onPressed 中进行 Provider.of(context) 的获取。所以相当于我们肯定得去创建一个局部 Provider 变量。
                  // 在综合的考虑下，为了不在每个 Builder 中都重新获取一次，所以，一般我们会考虑弄成本 page 的全局变量。
                  _localChangeNotifier.changeTheme('xxx');
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
