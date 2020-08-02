/// 正常以 setState 来更新主题的方式
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bean.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bloc.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bloc_provider.dart';

class ThemeResultPage4 extends StatefulWidget {
  ThemeResultPage4({Key key}) : super(key: key);

  @override
  _ThemeResultPage4State createState() => _ThemeResultPage4State();
}

class _ThemeResultPage4State extends State<ThemeResultPage4> {
  String _currentThemeString;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();

    _currentThemeString = 'Default';
    // _themeBloc = ThemeBloc();
    _themeBloc = ThemeBlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('设计模式-BloC'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: _themeBloc.getStream(),
                initialData: _themeBloc.getValue(_currentThemeString),
                builder:
                    (BuildContext context, AsyncSnapshot<ThemeBean> snapshot) {
                  // if (snapshot.data != null && snapshot.data.themeString != null) {
                  ThemeBean _themeBean = snapshot.data;
                  _currentThemeString = _themeBean.themeString ?? '';
                  //   _currentThemeString = snapshot.data.themeString;
                  // }

                  return Text('当前主题为' + _currentThemeString);
                }),
            // Text('当前主题为' + _currentThemeString),
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
        _themeBloc.goChangeTheme(context, 1, _currentThemeString);
        return;

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) =>
        //           ThemeSettingPage4(themeString: _currentThemeString)),
        // ).then((value) {
        //   // // 接收下一个页面返回回来的数据
        //   // String themeString = value as String;
        //   // print('修改后的主题为' + themeString);
        //   // _currentThemeString = themeString;
        //   // setState(() {});
        // });
      },
    );
  }
}
