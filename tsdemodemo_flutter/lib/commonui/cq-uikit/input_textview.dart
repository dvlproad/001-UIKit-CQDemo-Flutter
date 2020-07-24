import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef TextChangeCallback = void Function(String text);

class InputTextView extends StatefulWidget {
  final String placeholder;
  final int maxLength;
  final int maxLines;
  final TextChangeCallback textChangeCallback;

  InputTextView({Key key, this.placeholder, this.maxLength, this.maxLines, this.textChangeCallback}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _InputTextViewState();
  }
}

class _InputTextViewState extends State<InputTextView> {
  TextEditingController _inputTextViewController = new TextEditingController();

  String countText = '';

  @override
  void initState() {
    super.initState();

    _inputTextViewController.addListener(() {
      var currentTextLength = _inputTextViewController.text.length;
      setState(() {
        countText = currentTextLength.toString() + '/' + widget.maxLength.toString();
      });
      if(null != widget.textChangeCallback) {
        widget.textChangeCallback(_inputTextViewController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
//      child: textField1(),
      child: textField2(),
    );
  }

  Widget textField1(){
    return TextField(
      controller: _inputTextViewController,
      maxLength: widget.maxLength,  //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
      maxLines: widget.maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 14.0, color: Colors.white),//输入文本的样式
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: Color(0xFF7E7E7E)),
        enabledBorder: __reportTextFieldDecorationBorder(),
        focusedBorder: __reportTextFieldDecorationBorder(),
      ),
    );
  }

  Widget textField2(){
    return Stack(
      alignment: AlignmentDirectional.topStart,
      // alignment：子Widget的对其方式，默认情况是以左上角为开始点
      fit: StackFit.loose,
      // fit :用来决定没有Positioned方式时候子Widget的大小，
      // StackFit.loose 指的是子Widget 多大就多大;
      // StackFit.expand 使子Widget的大小和父组件一样大
      overflow: Overflow.clip,
      // overflow :指子Widget 超出Stack时候如何显示
      // 默认值是Overflow.clip，子Widget超出Stack会被截断;
      // Overflow.visible 子Widget超出Stack部分还会显示的
      children: <Widget>[
        TextField(
          controller: _inputTextViewController,
//          maxLength: widget.maxLength,  //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
          maxLines: widget.maxLines,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14.0, color: Colors.white),//输入文本的样式
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: TextStyle(color: Color(0xFF7E7E7E)),
            enabledBorder: __reportTextFieldDecorationBorder(),
            focusedBorder: __reportTextFieldDecorationBorder(),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Text(countText??'', style: TextStyle(color: Color(0xFF7E7E7E))),
        )
      ],
    );
  }
}

/// 举报页面的文本框 border
InputBorder __reportTextFieldDecorationBorder() {
  return InputBorder.none;
//  return OutlineInputBorder(
//      borderSide: new BorderSide(
//          color: Colors.white, width: 0.6),
//      borderRadius: new BorderRadius.circular(6.0)
//  );
}