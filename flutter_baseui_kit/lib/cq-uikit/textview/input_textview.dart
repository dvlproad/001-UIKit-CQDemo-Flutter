import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef TextChangeCallback = void Function(String text);

class CQInputTextView extends StatefulWidget {
  final String text;
  final String placeholder;
  final int maxLength;
  final int Function(String) maxLengthAlgorithm;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final double minHeight; // 文本框的最小高度
  final double maxHeight; // 文本框的最大高度
  final TextChangeCallback textChangeCallback;
  final bool autofocus;

  CQInputTextView({
    Key key,
    this.text,
    this.placeholder,
    this.maxLength,
    this.maxLengthAlgorithm, // 最大长度的算法
    this.inputFormatters,
    this.maxLines,
    this.minHeight,
    this.maxHeight,
    @required this.textChangeCallback,
    this.autofocus, // 如朋友圈文本页面需要直接弹出键盘
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CQInputTextViewState();
  }
}

class _CQInputTextViewState extends State<CQInputTextView> {
  TextEditingController _inputTextViewController = new TextEditingController();

  String countText = '';

  @override
  void initState() {
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   setState(() {
    //     // 当前键盘高度：大于零，键盘弹出，否则，键盘隐藏
    //     double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    //   });
    // });

    _inputTextViewController =
        new TextEditingController(text: widget.text ?? '');
    //_inputTextViewController.text = widget.text ?? '';
    _updateCountTextWidget();

    _inputTextViewController.addListener(() {
      _updateCountTextWidget();

      if (null != widget.textChangeCallback) {
        widget.textChangeCallback(_inputTextViewController.text);
      }
    });
  }

  /// 更新文本长度计算
  _updateCountTextWidget() {
    if (widget.maxLength != null) {
      int showTextLength = _inputTextViewController.text.characters.length;
      if (widget.maxLengthAlgorithm != null) {
        // showTextLength = _inputTextViewController.text.runes.length;
        showTextLength =
            widget.maxLengthAlgorithm(_inputTextViewController.text);
        if (showTextLength > widget.maxLength) {
          showTextLength = widget.maxLength;
        }
      }

      setState(() {
        countText =
            showTextLength.toString() + '/' + widget.maxLength.toString();
      });
    }
  }

  List<TextInputFormatter> _inputFormatters() {
    if (widget.inputFormatters != null) {
      return widget.inputFormatters;
    } else {
      return <TextInputFormatter>[
        LengthLimitingTextInputFormatter(widget.maxLength), //限制最多 maxLength 位字符
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        minHeight: widget.minHeight ?? 0,
        // maxHeight: widget.maxHeight ?? 1000,
      ),
      color: Colors.black,
      margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
      // child: textField1(),
      child: textField2(),
    );
  }

  /// 文本框右下角最大长度显示的视图使用系统实现的Text
  Widget textField1() {
    return TextField(
      controller: _inputTextViewController,
      autofocus: widget.autofocus,
      maxLength: widget.maxLength, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串
      maxLines: widget.maxLines,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 14.0, color: Colors.white), //输入文本的样式
      decoration: InputDecoration(
        hintText: widget.placeholder,
        hintStyle: TextStyle(color: Color(0xFF7E7E7E)),
        enabledBorder: __reportTextFieldDecorationBorder(),
        focusedBorder: __reportTextFieldDecorationBorder(),
      ),
    );
  }

  /// 文本框右下角最大长度显示的视图使用自己实现的Text
  Widget textField2() {
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
        Column(
          children: [
            TextField(
              controller: _inputTextViewController,
              autofocus: widget.autofocus,
              // maxLength: widget.maxLength, //最大长度，设置此项会让TextField右下角有一个输入数量的统计字符串。现在改为自己写Text
              inputFormatters: _inputFormatters(),
              maxLines: widget.maxLines,
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 14.0, color: Colors.white), //输入文本的样式
              decoration: InputDecoration(
                hintText: widget.placeholder,
                hintStyle: TextStyle(color: Color(0xFF7E7E7E)),
                enabledBorder: __reportTextFieldDecorationBorder(),
                focusedBorder: __reportTextFieldDecorationBorder(),
              ),
            ),
            Container(
              height: 10,
              color: Colors.transparent,
            ),
          ],
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child:
              Text(countText ?? '', style: TextStyle(color: Color(0xFF7E7E7E))),
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
