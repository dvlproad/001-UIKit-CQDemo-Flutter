/// 测试 Consumer2 中 互相更新会不会导致死循环
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderUsePage4 extends StatefulWidget {
  ProviderUsePage4({Key key}) : super(key: key);

  @override
  _ProviderUsePage4State createState() => _ProviderUsePage4State();
}

class _ProviderUsePage4State extends State<ProviderUsePage4> {
  int testNumber = 0; // 测试的次数
  ThemeMoreChangeNotifier1 _themeMoreChangeNotifier1 =
      ThemeMoreChangeNotifier1();

  @override
  Widget build(BuildContext context) {
    // 创建 Provider
    return ChangeNotifierProvider<ThemeMoreChangeNotifier1>.value(
      value: _themeMoreChangeNotifier1,
      child: _pageWidget(),
    );
  }

  Widget _pageWidget() {
    return Scaffold(
      appBar: AppBar(
        title: Text('测试 Consumer2 中 互相更新会不会导致死循环'),
      ),
      body: Center(
        // Provider 使用 Consumer 的写法
        child: ChangeNotifierProvider<ThemeMoreChangeNotifier2>.value(
          value: ThemeMoreChangeNotifier2(),
          // child: Builder(
          //   builder: (context) {
          child: Consumer<ThemeMoreChangeNotifier2>(
            builder: (context, consumerNotifier2, child) {
              print('数据发生变化');

              // if (testNumber < 2) {
              //   testNumber++;
              //   consumerNotifier1.update(); //错误更新，会造成崩溃
              // }
              _themeMoreChangeNotifier1
                  .update(); // 不能使用 consumerNotifier1.update();

              return Column(
                children: <Widget>[
                  FlatButton(
                    child: Text("按钮1"),
                    textColor: Color(0xfff5b63c),
                    onPressed: () {
                      // consumerNotifier1.update();
                    },
                  ),
                  FlatButton(
                    child: Text("按钮2"),
                    textColor: Color(0xfff5b63c),
                    onPressed: () {
                      consumerNotifier2.update();
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ThemeMoreChangeNotifier1 extends ChangeNotifier {
  ThemeMoreChangeNotifier1();

  void update() {
    notifyListeners();
  }
}

class ThemeMoreChangeNotifier2 extends ChangeNotifier {
  ThemeMoreChangeNotifier2();

  void update() {
    notifyListeners();
  }
}
