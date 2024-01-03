/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-01-03 16:21:57
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/cq-uikit/textview/emoji_input_textview.dart';
// import 'package:tsdemodemo_flutter/commonui/cq-photo-add-delete-list/images_add_delete_pick_list.dart';

class TSTextViewEmojiMaxLengthPage extends StatefulWidget {
  TSTextViewEmojiMaxLengthPage({Key? key}) : super(key: key);

  @override
  _TSTextViewEmojiMaxLengthPageState createState() =>
      new _TSTextViewEmojiMaxLengthPageState();
}

class _TSTextViewEmojiMaxLengthPageState
    extends State<TSTextViewEmojiMaxLengthPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Stack(
        alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
        children: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: ListView(
              children: textViewWidgets(),
            ),
          ),
        ],
      ),
    );
  }

  /// 导航栏
  PreferredSize appBar() {
    return PreferredSize(
        child: AppBar(
          title: Text('TextView', style: TextStyle(fontSize: 17)),
        ),
        preferredSize: Size.fromHeight(44));
  }

  /// textView Widgets
  List<Widget> textViewWidgets() {
    return <Widget>[
      new Column(
        children: <Widget>[
          SizedBox(height: 4),
          _textView('👨‍👩‍👧1234'),
          _pageList(),
        ],
      )
    ];
  }

  Widget _textView(text) {
    int maxLength = 10;
    return CQEmojiInputTextView(
      minHeight: 40,
      maxLength: maxLength,
      placeholder: '请输入你想说的话，最多可输入$maxLength个字',
      text: text,
      textChangeCallback: (String text) {
        print('text = $text');
        setState(() {});
      },
    );
  }

  Widget _pageList() {
    return Text(
      'CQImageDeleteAddPickList',
      style: TextStyle(color: Colors.red),
    );
    // return CQImageDeleteAddPickList(
    //   // imageOrPhotoModels: _imageOrPhotoModels,
    //   imageOrPhotoModelsChangeBlock: (List<dynamic> imageOrPhotoModels) {},
    // );
  }
}
