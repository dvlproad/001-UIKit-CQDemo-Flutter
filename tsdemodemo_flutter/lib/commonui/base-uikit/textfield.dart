import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 文本框(默认包含 clearButton 的文本框)
class CJTextField extends StatefulWidget {
  final double height; // 文本框的高度
  final Color backgroundColor; // 文本框的背景颜色
  final Color tfThemeColor;

  final Widget prefixIcon;
  final String text;
  final String placeholder;
  final Color placeholderColor;

  final double cornerRadius; // 边的圆角
  final double borderWidth; // 边宽
  final Color borderColor; // 边的颜色

  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  CJTextField({
    Key key,
    this.height = 40,
    this.backgroundColor,
    this.tfThemeColor = Colors.black,
    this.prefixIcon,
    this.text = '',
    this.placeholder = '请输入',
    this.placeholderColor,
    this.cornerRadius,
    this.borderWidth,
    this.borderColor,
    this.obscureText,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CJTextFieldState();
  }
}

class _CJTextFieldState extends State<CJTextField> {
  Color _tfThemeColor;
  // bool _isFirstResponse; // 是否是第一响应者，即是否有焦点
  bool _curShowClear = false;
  bool _oldShowClear = false;

  String _text;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    print('initState CJTextField');

    _tfThemeColor = widget.tfThemeColor;

    _text = widget.text ?? "";
    _controller = widget.controller ?? TextEditingController();

    _oldShowClear = _text.isNotEmpty;
    _curShowClear = _text.isNotEmpty;
    _controller.text = _text;

    // 注意不使用 addListener，而使用 onChanged，会造成执行 _controller.clear 进行文本清空的事件无法监听到
    _controller.addListener(() {
      print('CJTextField.text addListener: $_controller.text');
      this._changeText(_controller.text);
    });
  }

  /// 文本框内容发生改变的事件
  void _changeText(String mText) {
    _text = mText;

    // 是否已经编辑结束
    // if (_isFirstResponse == false) {
    //   _curShowClear = false;
    // } else {
    _curShowClear = _text.length > 0;
    // }

    if (_curShowClear != _oldShowClear) {
      _oldShowClear = _curShowClear;
      setState(() {
        // 调用以更新文本框删除键
        //print('setState');
      });
    }

    if (widget.onChanged != null) {
      widget.onChanged(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    double cornerRadius = widget.cornerRadius != null ? widget.cornerRadius : 0;
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: _textField(),
    );
  }

  Widget _textField() {
    Widget suffixIcon;
    if (_curShowClear == true) {
      suffixIcon = IconButton(
        icon: new Icon(Icons.clear, color: _tfThemeColor, size: 14),
        onPressed: _controller.clear,
      );
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
//          maxHeight: 44,
          ),
      child: TextField(
        autofocus: false,
        obscureText: false,
        style: TextStyle(color: _tfThemeColor, fontSize: 17.0),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: _tfThemeColor,
        cursorWidth: 0.5,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0, bottom: 10),
          hintText: widget.placeholder,
          hintStyle: TextStyle(fontSize: 14, color: widget.placeholderColor),
          prefixIcon: widget.prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: textFieldDecorationBorder(),
          focusedBorder: textFieldDecorationBorder(),
        ),
        keyboardType: widget.keyboardType,
        controller: _controller,

        // // 当输入框内的文本发生改变时回调的函数
        // onChanged: (String currentText) {
        //   print('CJTextField.text onChanged  : $currentText');
        //   this._changeText(currentText);
        // },
        textInputAction: widget.textInputAction, //TextInputType.search
        focusNode: widget.focusNode,
        onSubmitted: (String currentText) {
          // _isFirstResponse = false;
          if (widget.onSubmitted != null) {
            widget.onSubmitted(currentText);
          }
        },
      ),
    );
  }

  /// 文本框border
  InputBorder textFieldDecorationBorder() {
    double borderWidth = widget.borderWidth != null ? widget.borderWidth : 0;
    if (borderWidth > 0) {
      Color borderColor =
          widget.borderColor != null ? widget.borderColor : Color(0xffd2d2d2);
      // double cornerRadius =
      //     widget.cornerRadius != null ? widget.cornerRadius : 6.0;
      return new OutlineInputBorder(
        borderSide: new BorderSide(color: borderColor, width: borderWidth),
        // borderRadius: new BorderRadius.circular(cornerRadius),
      );
    } else {
      return InputBorder.none;
    }
  }
}
