import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/ForgetPasswordTextFieldRowWidgetFactory.dart';

class TSTextFieldPage extends StatefulWidget {
  TSTextFieldPage({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  _TSTextFieldPageState createState() => new _TSTextFieldPageState();
}

class _TSTextFieldPageState extends State<TSTextFieldPage> {
  bool userNameValid = false;
  bool phoneValid = false;

  String userName = "";
  String phone = "";

  //定义一个controller
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  // 控制文本框焦点
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusScopeNode currentFocusNode;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              children: forgetPasswordWidgets(),
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
          title: Text('忘记密码', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 忘记密码页的整体视图
  List<Widget> forgetPasswordWidgets() {
    return <Widget>[
      new Column(
        children: <Widget>[
          userNameRowWidget(),

          /// 用户名
          _separateLine(),
          phoneRowWidget(),

          /// 密码提示语
          submitButtonRowWidget(),

          /// 提交按钮
        ],
      )
    ];
  }

  /// 下划分割线
  static Widget _separateLine() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0),
      width: double.infinity,
      height: 0.5,
      color: Colors.grey,
    );
  }

  /// 用户名 的行视图
  Widget userNameRowWidget() {
    return ForgetPasswordTextFieldRowWidget(
      title: '用户名',
      placeholder: '请输入本人登陆用户名',
      value: userName,
      keyboardType: TextInputType.text,
      autofocus: true,
      controller: _usernameController,
    );
  }

  /// 手机号 的行视图
  Widget phoneRowWidget() {
    return ForgetPasswordTextFieldRowWidget(
      title: '手机号',
      placeholder: '请输入本人手机号',
      value: '',
      keyboardType: TextInputType.number,
      autofocus: true,
      controller: _phoneController,
    );
  }

  /// 提交按钮 的行视图
  Row submitButtonRowWidget() {
    return Row(children: <Widget>[
      Expanded(
          child: Padding(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
        child: _submitButton(),
      ))
    ]);
  }

  // 提交按钮
  FlatButton _submitButton() {
    return FlatButton(
        child: Padding(
          padding: EdgeInsets.fromLTRB(10.0, 15.0, 0.0, 15.0),
          child: Text("提交"),
        ),
        color: Color(0xff01adfe),
        textColor: Colors.white,
        highlightColor: Color(0xff1393d7),
        disabledColor: Color(0xffd3d3d5),
        //colorBrightness: Brightness.dark, //按钮主题，默认是浅色主题
        //splashColor: Colors.grey, //点击时，水波动画中水波的颜色
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        onPressed: () {
          String userName = _usernameController.text;
          Runes runes = userName.runes;
          int leng = runes.length;
          print(leng);
          int userNameLength = userName.length;
          print(userNameLength);
        });
  }
}
