import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/TextField/TextTextField.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textfield/textInputFormatter/textinputformatter_util.dart';

class TSTextInputFormmaterPage extends StatefulWidget {
  TSTextInputFormmaterPage({Key key}) : super(key: key);

  @override
  _TSTextInputFormmaterPageState createState() =>
      new _TSTextInputFormmaterPageState();
}

class _TSTextInputFormmaterPageState extends State<TSTextInputFormmaterPage> {
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
              children: textfieldWidgets(),
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
          title: Text('TextInputFormter', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// 忘记密码页的整体视图
  List<Widget> textfieldWidgets() {
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
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
            child: phoneRowWidget(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
            child: nicknameRowWidget(),
          ),
        ],
      )
    ];
  }

  /// 用户名 的行视图
  Widget userNameRowWidget() {
    return TextTextFieldRowWidget(
      title: '用户名',
      placeholder: '只允许字符+数字',
      value: '',
      keyboardType: TextInputType.text,
      inputFormatters: CQTextInputFormatterUtil.usernameInputFormatters(),
    );
  }

  /// 手机号 的行视图
  Widget phoneRowWidget() {
    return TextTextFieldRowWidget(
      title: '手机号',
      placeholder: '只允许数字',
      value: '',
      keyboardType: TextInputType.text,
      inputFormatters: CQTextInputFormatterUtil.phoneInputFormatters(),
    );
  }

  /// 昵称 的行视图
  Widget nicknameRowWidget() {
    return TextTextFieldRowWidget(
      title: '昵称',
      placeholder: '限制最多15位字符',
      value: '',
      keyboardType: TextInputType.number,
      inputFormatters: CQTextInputFormatterUtil.nicknameInputFormatters(),
    );
  }
}
