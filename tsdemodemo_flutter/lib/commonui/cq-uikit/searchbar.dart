/*
 * searchbar.dart
 *
 * @Description: 搜索框
 *
 * @author      ciyouzen
 * @email       dvlproad@163.com
 * @date        2020/7/31 13:33
 *
 * Copyright (c) dvlproad. All rights reserved.
 */
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final String searchText;
  final String searchPlaceholder;
  final ValueChanged<String> onSearchTextChanged;
  final ValueChanged<String> onSubmitted;

  SearchBar({
    Key key,
    this.searchPlaceholder,
    this.searchText,
    this.onSearchTextChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Color(0xff323334), borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      child: SearchBarTextField(
        placeholder: this.searchPlaceholder,
        text: this.searchText,
        controller: this.controller,
        onChanged: onSearchTextChanged,
        onSubmitted: this.onSubmitted,
      ),
    );
  }
}

/// 搜索框中的文本框(常用于：搜索框)
class SearchBarTextField extends StatefulWidget {
  final String text;

  final String placeholder;

  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  SearchBarTextField({
    Key key,
    this.text,
    this.placeholder = '请输入',
    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarTextFieldState();
  }
}

class _SearchBarTextFieldState extends State<SearchBarTextField> {
  bool _curShowClear = false;
  bool _oldShowClear = false;

  @override
  void initState() {
    super.initState();
    print('initState');

    _oldShowClear = widget.text.length > 0;
    _curShowClear = widget.text.length > 0;
    widget.controller.text = widget.text;

    widget.controller.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
//          maxHeight: 44,
          ),
      child: TextField(
        autofocus: true,
        obscureText: false,
        style: TextStyle(color: Colors.white, fontSize: 17.0),
        textAlign: TextAlign.left,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.white,
        cursorWidth: 0.5,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0, bottom: 10),
          hintText: widget.placeholder,
          hintStyle: TextStyle(fontSize: 14, color: Color(0xFF7E7E7E)),
          prefixIcon: Icon(Icons.search, color: Colors.white, size: 14),
          suffixIcon: !_curShowClear
              ? null
              : IconButton(
                  icon: new Icon(Icons.clear, color: Colors.white, size: 14),
                  onPressed: widget.controller.clear),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
        keyboardType: widget.keyboardType,
        controller: widget.controller,

        // 当输入框内的文本发生改变时回调的函数
        onChanged: (String currentText) {
          _curShowClear = currentText.length > 0;

          if (_curShowClear != _oldShowClear) {
            _oldShowClear = _curShowClear;
            setState(() {
              // 调用以更新文本框删除键
              //print('setState');
            });
          }

          print('searchText change $currentText');
          widget.onChanged(currentText);
        },
        textInputAction: widget.textInputAction, //TextInputType.search
        focusNode: widget.focusNode,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}

// class TextFieldWidget extends StatelessWidget {
//   Widget buildTextField() {
// // theme设置局部主题
//     return Theme(
//         data: new ThemeData(primaryColor: Colors.grey),
//         child: Container(
//           padding: EdgeInsets.only(top: 5.0, left: 5.0),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               border: Border(
//                 bottom: BorderSide(width: 1.0, color: Colors.black12),
//                 top: BorderSide(width: 1.0, color: Colors.black12),
//                 right: BorderSide(width: 1.0, color: Colors.black12),
//                 left: BorderSide(width: 1.0, color: Colors.black12),
//               )),
//           child: TextField(
//             cursorColor: Colors.grey, // 光标颜色

// // 默认设置

//             decoration: InputDecoration(
//                 contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
//                 border: InputBorder.none,
//                 icon: Icon(Icons.search),
//                 hintText: "搜索文件",
//                 hintStyle: new TextStyle(
//                     fontSize: 14, color: Color.fromARGB(50, 0, 0, 0))),

//             style: new TextStyle(fontSize: 14, color: Colors.black),
//           ),
//         ));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
// // 修饰搜索框, 白色背景与圆角

//       decoration: new BoxDecoration(
//         color: Colors.white,
//         borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
//       ),

//       alignment: Alignment.center,

//       height: ScreenUtil().setHeight(120),

//       padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),

//       child: buildTextField(),
//     );
//   }
// }
