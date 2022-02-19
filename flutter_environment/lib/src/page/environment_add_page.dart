import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import './prefixText_textField.dart';

class EnvironmentAddPage extends StatefulWidget {
  final String oldProxyIp;
  final Function(String bProxyIp) callBack;

  EnvironmentAddPage({
    Key key,
    this.oldProxyIp,
    this.callBack,
  }) : super(key: key);

  @override
  _EnvironmentAddPageState createState() => new _EnvironmentAddPageState();
}

class _EnvironmentAddPageState extends State<EnvironmentAddPage> {
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

    if (widget.oldProxyIp != null && widget.oldProxyIp.isNotEmpty) {
      List<String> proxyComponents = widget.oldProxyIp.split(':');
      userName = proxyComponents[0];
      phone = proxyComponents[1];
    } else {
      userName = "";
      phone = "";
    }
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
          title: Text('添加代理', style: TextStyle(fontSize: 17)),
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
      title: '代理ip',
      placeholder: '请输入代理ip',
      value: userName,
      keyboardType: TextInputType.url,
      autofocus: true,
      controller: _usernameController,
    );
  }

  /// 手机号 的行视图
  Widget phoneRowWidget() {
    return TextTextFieldRowWidget(
      title: '端口号',
      placeholder: '请输入端口号,默认8888',
      value: phone,
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

        String port = _phoneController.text;
        if (port == null || port.length == 0) {
          port = '8888';
        }

        String proxyIp = '$userName:$port';
        if (IsIPAddress(proxyIp) == false) {
          showMessage('代理ip格式出错,请先修改');
        } else {
          Navigator.pop(context);
          if (widget.callBack != null) {
            widget.callBack(proxyIp);
          }
        }
      },
    );
  }

  static bool IsIPAddress(String ipString) {
    if (ipString == null) {
      return false;
    }

    final reg = RegExp(r'^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}');

    bool isMatch = reg.hasMatch(ipString);
    return isMatch;
  }

  static showMessage(String message) {
    if (message != null && message is String && message.isNotEmpty) {
      print(message);
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color(0xAA000000),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
