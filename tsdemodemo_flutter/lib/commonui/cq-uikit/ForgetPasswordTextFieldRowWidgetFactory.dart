import 'package:flutter/material.dart';

/// 忘记密码页面的文本框(常用于：用户名、手机号、验证码、新密码、确认新密码文本框)
class ForgetPasswordTextFieldRowWidget extends Container {
  ForgetPasswordTextFieldRowWidget({
    Key key,

    String title,
    String placeholder,
    String value,

    bool autofocus = false,
//    bool obscureText = false,
    TextInputType keyboardType,
    TextEditingController controller,
//    bool showClear = false,
//    TextInputAction textInputAction,
//    FocusNode focusNode,
//    ValueChanged<String> onSubmitted,
  }) : super(
    key: key,

    color: const Color(0xFFffffff),
    child: Row(
      children: <Widget>[
        prefixWidget(title),
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

Widget prefixWidget(text) {
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
