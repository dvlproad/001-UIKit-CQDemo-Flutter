import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 忘记密码页面的文本框(常用于：用户名、手机号、验证码、新密码、确认新密码文本框)
class TextTextFieldRowWidget extends StatelessWidget {
  final String title;
  final String placeholder;
  final String value;
  bool autofocus;
  TextInputType keyboardType;
  TextEditingController controller;

  TextTextFieldRowWidget({
    Key key,

    this.title,
    this.placeholder,
    this.value,

    this.autofocus = false,
    this.keyboardType,
    this.controller,
  }) : super(
    key: key,
  );



  @override
  Widget build(BuildContext context) {
    return Container (
      color: const Color(0xFFffffff),
      child: Row(
        children: <Widget>[
          _prefixWidget(title),
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              controller: controller,
              autofocus: autofocus,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
              ),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }


  Widget _prefixWidget(text) {
    return Container(
        width: 100,
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(left: 15, top: 0, right: 15, bottom: 0),
          child: Text(
            text,
            textAlign: TextAlign.left,
            style: new TextStyle(fontSize: 14),
          ),
        )
    );
  }
}




class YSTextfiled extends StatelessWidget {
  final double height;

  final TextEditingController controller;

  final Widget leading;
  final Widget trailing;
  final bool autofocus;
  final bool obscureText;
  final String hintText;
  final TextInputType keyboardType;
  final TextAlign textAlign;
  final List<TextInputFormatter> inputFormatters;
  final Color color;

  const YSTextfiled({
    Key key,
    this.height,
    this.controller,
    this.leading,
    this.trailing,
    this.autofocus = false,
    this.obscureText = false,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.textAlign = TextAlign.start,
    this.color = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> list = [];

    if (leading != null) {
      list.add(leading);
    }
    list.add(Expanded(
        child: TextField(
          textAlign: textAlign,
          autofocus: autofocus,
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: TextStyle(
            color: color,
            fontSize: 15.0,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
          ),
        )));

    if (trailing != null) {
      list.add(trailing);
    }

    return Container(
      height: height ?? 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: list,
      ),
    );
  }
}
