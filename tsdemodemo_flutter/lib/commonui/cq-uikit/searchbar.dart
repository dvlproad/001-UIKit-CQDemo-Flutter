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
import 'package:tsdemodemo_flutter/commonui/base-uikit/textfield.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller = TextEditingController();
  final String searchText;
  final String searchPlaceholder;
  final ValueChanged<String> onSearchTextChanged; // 当输入框内的文本发生改变时回调的函数
  final ValueChanged<String> onSubmitted;

  SearchBar({
    Key key,
    this.searchPlaceholder = '请输入',
    this.searchText,
    this.onSearchTextChanged,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      // margin: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
      child: CJTextField(
        height: 40,
        backgroundColor: Color(0xff323334),
        cornerRadius: 16,
        prefixWidget: Row(
          children: <Widget>[
            SizedBox(width: 5),
            Icon(Icons.search, color: Colors.white, size: 14),
            SizedBox(width: 5),
          ],
        ),
        placeholder: this.searchPlaceholder,
        text: this.searchText,
        textColor: Colors.white,
        textInputAction: TextInputAction.search,
        controller: this.controller,
        onChanged: this.onSearchTextChanged,
        onSubmitted: this.onSubmitted,
      ),
    );
  }
}
