import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/cq-uikit/textfield/prefixIcon_textField.dart';

class TSIconTextFieldPage extends StatefulWidget {
  final String? title;
  final String? username;
  TSIconTextFieldPage({
    Key? key,
    this.title,
    this.username,
  }) : super(key: key);

  @override
  _TSIconTextFieldPageState createState() => new _TSIconTextFieldPageState();
}

class _TSIconTextFieldPageState extends State<TSIconTextFieldPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: appBar(),
      body: Stack(
        alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
              children: iconTextFieldWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('含Icon头的文本框(常用于登录)', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 忘记密码页的整体视图
  List<Widget> iconTextFieldWidgets() {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double screenHeight = mediaQuery.size.height;
    double loginIconBottom = screenHeight <= 667 ? 50 : 71;

    return <Widget>[
      new Column(
        children: <Widget>[
          /// 用户名
          Padding(
            padding: EdgeInsets.only(top: loginIconBottom, left: 25, right: 25),
            child: userNameRowWidget(),
          ),
          // 密码
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
            child: passwordRowWidget(),
          ),
        ],
      )
    ];
  }

  /// 用户名 的行视图
  Widget userNameRowWidget() {
    return IconTextField(
      placeholder: "用户名",
      text: '张三',
      prefixIconSelectedCallback: (String currentText) {
        bool userNameValid = currentText.length > 0;
        return userNameValid;
      },
      prefixIconNormalImageName: 'assets/login_username_gray.png',
      prefixIconSelectedImageName: 'assets/login_username_blue.png',
      package: 'tsdemo_baseui',
    );
  }

  /// 密码 的行视图
  Widget passwordRowWidget() {
    return IconTextField(
      placeholder: "密码",
      prefixIconSelectedCallback: (String currentText) {
        bool passwordValid = currentText.length > 0;
        return passwordValid;
      },
      prefixIconNormalImageName: 'assets/login_password_gray.png',
      prefixIconSelectedImageName: 'assets/login_password_blue.png',
      package: 'tsdemo_baseui',
    );
  }
}
