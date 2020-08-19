import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/base-uikit/textfield.dart';

/// 文本框(常用于：登录用户名、密码文本框，在原本基础上增加了 图片 选中状态的判断)
class IconTextField extends StatefulWidget {
  final String text;
  final String placeholder;

  /// prefix icon
  final bool Function(String currentText) prefixIconSelectedCallback;
  final String prefixIconNormalImageName;
  final String prefixIconSelectedImageName;

  final bool autofocus;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final bool showClear;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  IconTextField({
    Key key,
    this.text,
    this.placeholder,

    /// prefix icon
    this.prefixIconSelectedCallback,
    this.prefixIconNormalImageName,
    this.prefixIconSelectedImageName,
    this.autofocus = false,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.showClear = false,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
  }) : super(
          key: key,
        );

  @override
  State<StatefulWidget> createState() {
    return IconTextFieldState();
  }
}

class IconTextFieldState extends State<IconTextField> {
  bool _prefixIconSelected;
  String _text;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    _text = widget.text ?? '';
    _controller = widget.controller ?? TextEditingController();

    _prefixIconSelected = false;
    if (widget.prefixIconSelectedCallback != null) {
      _prefixIconSelected = widget.prefixIconSelectedCallback(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: CJTextField(
        prefixWidget: _prefixIcon(),
        suffixWidget: SizedBox(width: 5),
        borderColor: Color(0xff323334),
        borderWidth: 0.6,
        cornerRadius: 16,
        placeholder: widget.placeholder,
        text: widget.text,
//        textInputAction: TextInputAction.search,
        controller: widget.controller,
        onChanged: (String string) {
          if (widget.prefixIconSelectedCallback != null) {
            _prefixIconSelected = widget.prefixIconSelectedCallback(string);
          }
          setState(() {});
        },
        onSubmitted: widget.onSubmitted,
      ),
    );
  }

  Widget _prefixIcon() {
    String assetName = !_prefixIconSelected
        ? widget.prefixIconNormalImageName
        : widget.prefixIconSelectedImageName;
    return Row(
      children: <Widget>[
        SizedBox(width: 5),
        Image.asset(assetName, width: 14.0, height: 15.0),
        SizedBox(width: 5),
      ],
    );
  }
}
