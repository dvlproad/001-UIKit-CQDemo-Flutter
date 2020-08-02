/// 主页
import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bean.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bloc.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_bloc_provider.dart';

class ThemeSettingPage4 extends StatefulWidget {
  final String themeString;

  ThemeSettingPage4({
    Key key,
    @required this.themeString,
  }) : super(key: key);

  @override
  _ThemeSettingPage4State createState() => _ThemeSettingPage4State();
}

class _ThemeSettingPage4State extends State<ThemeSettingPage4> {
  String _currentThemeString;
  ThemeBloc _themeBloc;

  @override
  void initState() {
    super.initState();
    _currentThemeString = widget.themeString;

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
            // Text('当前选择的主题是' + _currentThemeString),
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

                  return Text('当前选择的主题是' + _currentThemeString);
                }),
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
        // Navigator.pop(context, _currentThemeString); //返回上一页并携带参数
        _themeBloc.changeTheme(context, 1, _currentThemeString);
        Navigator.pop(context); //返回上一页并携带参数
      },
    );
  }
}
