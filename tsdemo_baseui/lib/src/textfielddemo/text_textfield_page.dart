import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit.dart';

class TSTextTextFieldPage extends StatefulWidget {
  TSTextTextFieldPage({Key key, this.title, this.username}) : super(key: key);

  final String title;
  final String username;

  @override
  _TSTextTextFieldPageState createState() => new _TSTextTextFieldPageState();
}

class _TSTextTextFieldPageState extends State<TSTextTextFieldPage> {
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
              children: textTextFieldWidgets(),
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

  /// textTextField Widgets
  List<Widget> textTextFieldWidgets() {
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
    return TextTextFieldRowWidget(
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
    return TextTextFieldRowWidget(
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
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
            child: _submitButton(),
          ),
        )
      ],
    );
  }

  // 提交按钮
  Widget _submitButton() {
    return ThemeBGButton(
      bgColorType: ThemeBGType.theme,
      title: "提交",
      onPressed: () {
        String userName = _usernameController.text;
        Runes runes = userName.runes;
        int leng = runes.length;
        print(leng);
        int userNameLength = userName.length;
        print(userNameLength);
      },
    );
  }
}
