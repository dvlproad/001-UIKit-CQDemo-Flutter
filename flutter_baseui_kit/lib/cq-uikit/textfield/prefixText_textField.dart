/*
 * @Author: dvlproad
 * @Date: 2022-04-24 00:40:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-07-05 14:48:25
 * @Description: 忘记密码页面的文本框(常用于：用户名、手机号、验证码、新密码、确认新密码文本框)
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextTextFieldRowWidget extends StatelessWidget {
  final String? title;
  final String? placeholder;
  final String? value;
  final TextStyle? style;
  final bool autofocus;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  TextTextFieldRowWidget({
    Key? key,
    this.title,
    this.placeholder,
    this.value,
    this.style,
    this.autofocus = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.controller,
  }) : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFffffff),
      child: Row(
        children: <Widget>[
          _prefixWidget(title),
          Expanded(
            child: TextField(
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              controller: controller,
              style: style,
              autofocus: autofocus,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: placeholder,
              ),
              inputFormatters: this.inputFormatters,
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
      ),
    );
  }
}
