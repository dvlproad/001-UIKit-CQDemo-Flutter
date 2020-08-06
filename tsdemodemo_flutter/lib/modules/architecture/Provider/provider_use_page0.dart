/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_independent_notificater.dart';

class ProviderUsePage0 extends StatefulWidget {
  ProviderUsePage0({Key key}) : super(key: key);

  @override
  _ProviderUsePage0State createState() => _ProviderUsePage0State();
}

class _ProviderUsePage0State extends State<ProviderUsePage0> {
  ThemeIndependentChangeNotifier _globalChangeNotifier =
      ThemeIndependentChangeNotifier('Default2');

  @override
  void initState() {
    super.initState();
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
    // return ChangeNotifierProvider<ThemeChangeNotifier>.value(
    //   value: _globalThemeChangeNotifie = ThemeChangeNotifier('Default'),
    //   child: _pageWidget(),
    // );
    return _pageWidget();
  }

  Widget _pageWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Provider的使用方式(正确+错误)'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Consumer<ThemeChangeNotifier>(
            //     builder: (context, _cThemeChangeNotifier, child) {
            //   return Text('当前主题为' + _cThemeChangeNotifier.themeString);
            // }),
            // Text('当前主题为' + _currentThemeString),

            // Provider 使用局部变量的写法
            ChangeNotifierProvider<ThemeIndependentChangeNotifier>(
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
            //
            // Provider 使用全局变量的写法
            ChangeNotifierProvider<ThemeIndependentChangeNotifier>.value(
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

            // // Provider 使用全局变量的写法
            // ChangeNotifierProvider<ThemeChangeNotifier>.value(
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

            themeSettingButton(),
          ],
        ),
      ),
    );
  }

  // 进入修改主题页面的按钮
  FlatButton themeSettingButton() {
    // ThemeChangeNotifier _themeChangeNotifier =
    //     Provider.of<ThemeChangeNotifier>(context);
    return FlatButton(
      child: Text("进入修改主题"),
      textColor: Color(0xfff5b63c),
      onPressed: () {
        // _themeChangeNotifier.changeTheme('_currentThemeString');
        return;
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ThemeSettingPage2(themeString: _currentThemeString)),
        // ).then((value) {
        //   // 接收下一个页面返回回来的数据
        //   String themeString = value as String;
        //   print('修改后的主题为' + themeString);
        //   _currentThemeString = themeString;
        //   // setState(() {});

        //   Provider.of<ThemeChangeNotifier>(context, listen: false)
        //       .changeTheme(_currentThemeString);
        // });
      },
    );
  }
}
