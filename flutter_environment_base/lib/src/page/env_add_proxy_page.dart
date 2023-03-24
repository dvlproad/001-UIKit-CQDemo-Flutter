import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import './prefixText_textField.dart';
import './env_button.dart';

class EnvironmentAddProxyPage extends StatefulWidget {
  final String? proxyName;
  final String? oldProxyIp;
  final Function({required String bProxyName, String? bProxyIp}) callBack;

  EnvironmentAddProxyPage({
    Key? key,
    this.proxyName,
    this.oldProxyIp,
    required this.callBack,
  }) : super(key: key);

  @override
  _EnvironmentAddProxyPageState createState() =>
      new _EnvironmentAddProxyPageState();
}

class _EnvironmentAddProxyPageState extends State<EnvironmentAddProxyPage> {
  bool userNameValid = false;
  bool phoneValid = false;

  String proxyName = "";
  String userName = "";
  String phone = "";

  //定义一个controller
  TextEditingController _proxyNameController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  // 控制文本框焦点
  FocusNode usernameFocusNode = new FocusNode();
  FocusNode phoneFocusNode = new FocusNode();
  FocusScopeNode? currentFocusNode;

  @override
  void initState() {
    super.initState();

    proxyName = widget.proxyName ?? '';

    if (widget.oldProxyIp != null && widget.oldProxyIp!.isNotEmpty) {
      List<String> proxyComponents = widget.oldProxyIp!.split(':');
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
          /// 代理名称
          proxyNameRowWidget(),

          /// 代理ip
          _separateLine(),
          proxyIpRowWidget(),

          /// 代理ip端口
          _separateLine(),
          proxyPortRowWidget(),

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

  /// 代理名称 的行视图
  Widget proxyNameRowWidget() {
    return TextTextFieldRowWidget(
      title: '代理名称',
      placeholder: '请输入代理名称',
      value: proxyName,
      keyboardType: TextInputType.name,
      autofocus: true,
      controller: _proxyNameController,
    );
  }

  /// 代理ip 的行视图
  Widget proxyIpRowWidget() {
    return TextTextFieldRowWidget(
      title: '代理ip',
      placeholder: '请输入代理ip,形如192.168.1.1',
      value: userName,
      keyboardType: TextInputType.url,
      autofocus: true,
      controller: _usernameController,
    );
  }

  /// 端口号 的行视图
  Widget proxyPortRowWidget() {
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
  TextButton _submitButton() {
    return EnvButtonFactory.submitButton(
      buttonText: '提交',
      onPressed: () {
        // 代理名称
        String proxyName = _proxyNameController.text;

        // 代理ip
        String userName = _usernameController.text;
        Runes runes = userName.runes;
        int leng = runes.length;
        print(leng);
        int userNameLength = userName.length;
        print(userNameLength);

        // 代理ip端口port
        String port = _phoneController.text;
        if (port.length == 0) {
          port = '8888';
        }

        String proxyIp = '$userName:$port';
        if (IsIPAddress(proxyIp) == false) {
          ToastUtil.showMessage('代理ip格式出错,请先修改成形如192.168.1.1');
        } else {
          Navigator.pop(context);
          widget.callBack(bProxyName: proxyName, bProxyIp: proxyIp);
        }
      },
    );
  }

  static bool IsIPAddress(String ipString) {
    // if (ipString == null) {
    //   return false;
    // }

    final reg = RegExp(r'^\d{1,3}[\.]\d{1,3}[\.]\d{1,3}[\.]\d{1,3}');

    bool isMatch = reg.hasMatch(ipString);
    return isMatch;
  }
}
