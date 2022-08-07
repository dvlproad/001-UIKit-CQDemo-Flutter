import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 文本框(默认包含 clearButton 的文本框)
class CJClearButtonTextField extends StatefulWidget {
  final String? text;
  final TextStyle? style;
  final Color? textColor;
  final String? placeholder;
  final Color? placeholderColor;

  final bool? allowShowClear; // 是否允许有删除键(默认false)

  final bool? obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  CJClearButtonTextField({
    Key? key,
    this.text,
    this.style,
    this.textColor = Colors.black,
    this.placeholder = '请输入',
    this.placeholderColor,
    this.allowShowClear = false,
    this.obscureText,
    this.inputFormatters,
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CJClearButtonTextFieldState();
  }
}

class _CJClearButtonTextFieldState extends State<CJClearButtonTextField> {
  Color? _textColor;
  // bool _isFirstResponse; // 是否是第一响应者，即是否有焦点
  bool _allowShowClear = false;
  bool _curShowClear = false;
  bool _oldShowClear = false;

  late String _text;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    print('initState CJTextField');

    _textColor = widget.textColor;

    _text = widget.text ?? "";
    _controller = widget.controller ?? TextEditingController();

    _allowShowClear = widget.allowShowClear ?? false;
    _oldShowClear = _text.isNotEmpty;
    _curShowClear = _text.isNotEmpty;
    _controller.text = _text;

    // 注意不使用 addListener，而使用 onChanged，会造成执行 _controller.clear 进行文本清空的事件无法监听到
    _controller.addListener(() {
      print('CJTextField.text addListener: ${_controller.text}');
      this._changeText(_controller.text);
    });
  }

  /// 文本框内容发生改变的事件
  void _changeText(String mText) {
    _text = mText;

    if (_allowShowClear) {
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
    }

    if (widget.onChanged != null) {
      widget.onChanged!(_text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return Text('吃啥');
    Widget? suffixIcon;
    if (_allowShowClear == true && _curShowClear == true) {
      suffixIcon = IconButton(
        icon: new Icon(Icons.clear, color: _textColor, size: 14),
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
        style: widget.style ?? TextStyle(color: _textColor, fontSize: 17.0),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        // cursorColor: _textColor,
        inputFormatters: widget.inputFormatters,
        cursorWidth: 1,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 12),
          hintText: widget.placeholder,
          hintStyle: TextStyle(fontSize: 17, color: widget.placeholderColor),
          // prefixIcon: widget.prefixWidget,
          suffixIcon: suffixIcon,
          enabledBorder: textFieldDecorationBorder(),
          focusedBorder: textFieldDecorationBorder(),
        ),
        keyboardType: widget.keyboardType,
        controller: _controller,

        // // 当输入框内的文本发生改变时回调的函数
        // onChanged: (String currentText) {
        //   print('CJClearButtonTextField.text onChanged  : $currentText');
        //   this._changeText(currentText);
        // },
        textInputAction: widget.textInputAction, //TextInputType.search
        focusNode: widget.focusNode,
        onSubmitted: (String currentText) {
          // _isFirstResponse = false;
          if (widget.onSubmitted != null) {
            widget.onSubmitted!(currentText);
          }
        },
      ),
    );
  }

  /// 文本框border
  InputBorder textFieldDecorationBorder() {
    return InputBorder.none;
    // double borderWidth = widget.borderWidth != null ? widget.borderWidth : 0;
    // if (borderWidth > 0) {
    //   Color borderColor =
    //       widget.borderColor != null ? widget.borderColor : Color(0xffd2d2d2);
    //   // double cornerRadius =
    //   //     widget.cornerRadius != null ? widget.cornerRadius : 6.0;
    //   return new OutlineInputBorder(
    //     borderSide: new BorderSide(color: borderColor, width: borderWidth),
    //     // borderRadius: new BorderRadius.circular(cornerRadius),
    //   );
    // } else {
    //   return InputBorder.none;
    // }
  }
}
