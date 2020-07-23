import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReportTextView extends StatefulWidget {
  final String placeholder;
  final int maxLength;
  final int maxLines;

  final TextEditingController controller;

  ReportTextView({Key key, this.controller, this.placeholder, this.maxLength, this.maxLines}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ReportTextViewState();
  }
}

class _ReportTextViewState extends State<ReportTextView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
      child: textField1(),
//      child: textField2(),
    );
  }

  Widget textField1(){
    return TextField(
      controller: widget.controller,
      maxLength: widget.maxLength,  //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
      maxLines: widget.maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 14.0, color: Colors.white),//输入文本的样式
      decoration: InputDecoration(
        hintText: widget.placeholder,
        enabledBorder: __reportTextFieldDecorationBorder(),
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
          controller: widget.controller,
          maxLength: widget.maxLength,  //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
          maxLines: widget.maxLines,
          textAlign: TextAlign.left,
          style: TextStyle(fontSize: 14.0, color: Colors.white),//输入文本的样式
          decoration: InputDecoration(
            hintText: widget.placeholder,
            enabledBorder: __reportTextFieldDecorationBorder(),
          ),
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: Text('1/200'),
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