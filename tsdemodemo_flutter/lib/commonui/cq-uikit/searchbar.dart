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
  final ValueChanged<String> onSubmitted;

  SearchBar({
    Key key,
    this.searchPlaceholder,
    this.searchText,
    this.onSubmitted,
  }) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Color(0xff323334),
          borderRadius: BorderRadius.circular(16)
      ),
      margin: EdgeInsets.only(left: 20, right: 20, top: 6, bottom: 6),
      child: SearchBarTextField2(
        placeholder: this.searchPlaceholder,
        text : this.searchText,
        controller: this.controller,
        onSubmitted: this.onSubmitted,
        // onChanged: onSearchTextChanged,
      ),
    );
  }
}


/// 搜索框中的文本框(常用于：搜索框)
class SearchBarTextField2 extends StatefulWidget {
  final String text;

  final String placeholder;

  final TextInputType keyboardType;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final FocusNode focusNode;
  final ValueChanged<String> onSubmitted;

  SearchBarTextField2({
    Key key,
    this.text,
    this.placeholder = '请输入',

    this.keyboardType,
    this.controller,
    this.textInputAction,
    this.focusNode,
    this.onSubmitted,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchBarTextField2State();
  }
}

class _SearchBarTextField2State extends State<SearchBarTextField2> {
  bool _curShowClear = false;
  bool _oldShowClear = false;

  @override
  void initState() {
    super.initState();
    print('initState');

    _oldShowClear = widget.text.length > 0;
    _curShowClear = widget.text.length > 0;
    widget.controller.text = widget.text;
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
            suffixIcon: !_curShowClear ? null : IconButton(
                icon: new Icon(Icons.clear, color: Colors.white, size: 14),
                onPressed: widget.controller.clear
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          keyboardType: widget.keyboardType,
          controller: widget.controller,
          onChanged: (String currentText) {
            //print('text change $currentText');
            _curShowClear = currentText.length > 0;

            if (_curShowClear != _oldShowClear) {
              _oldShowClear = _curShowClear;
              setState(() { // 调用以更新文本框删除键
                //print('setState');
              });
            }
          },
          textInputAction: widget.textInputAction,
          focusNode: widget.focusNode,
          onSubmitted: widget.onSubmitted
      ),
    );
  }
}