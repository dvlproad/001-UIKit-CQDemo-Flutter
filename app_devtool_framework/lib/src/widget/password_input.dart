import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';
import 'package:flutter_theme_helper/flutter_theme_helper.dart';
import 'package:flutter_baseui_kit/flutter_baseui_kit_adapt.dart';

class PasswordInput extends StatefulWidget {
  final Function(String value, bool enable)? onChanged;
  final FocusNode? focusNode;
  final bool enable;
  final Function() passwordCorrectBlock;

  const PasswordInput({
    Key? key,
    this.onChanged,
    this.focusNode,
    this.enable = true,
    required this.passwordCorrectBlock,
  }) : super(key: key);

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final TextEditingController _controller = TextEditingController();
  // ignore: unused_field
  String? _codeErrorStr;
  Timer? _timer;

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer!.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    String codeStr = "进入页面";
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w_pt_cj),
      height: 45.h_pt_cj,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFDDDDDD), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              focusNode: widget.focusNode,
              maxLength: 6,
              controller: _controller,
              obscureText: false,
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.number,
              style: MediumTextStyle(
                fontSize: 14.f_pt_cj,
                color: const Color(0xff404040),
              ),
              decoration: InputDecoration(
                counterText: '',
                hintText: '请输入验证码',
                hintStyle: RegularTextStyle(
                  fontSize: 14.f_pt_cj,
                  color: const Color(0xFF8B8B8B),
                ),
                isCollapsed: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                bool enable = true;
                if (widget.onChanged != null) {
                  widget.onChanged!(value, enable);
                }

                if (enable) {
                  _codeErrorStr = null;
                } else {
                  _codeErrorStr = '*验证码格式不正确';
                }

                setState(() {});
              },
            ),
          ),
          InkWell(
            onTap: () {
              String currentText = _controller.text;
              if (currentText == "13579") {
                widget.passwordCorrectBlock();
              } else {
                ToastUtil.showMessage("密码错误");
              }
            },
            child: Text(
              codeStr,
              style: RegularTextStyle(
                fontSize: 14.f_pt_cj,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
