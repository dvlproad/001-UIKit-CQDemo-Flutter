import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-photo-add-delete-list/images_add_delete_pick_list.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textview/input_textview.dart';

class TSTextViewMaxLengthPage extends StatefulWidget {
  TSTextViewMaxLengthPage({Key key}) : super(key: key);

  @override
  _TSTextViewMaxLengthPageState createState() =>
      new _TSTextViewMaxLengthPageState();
}

class _TSTextViewMaxLengthPageState extends State<TSTextViewMaxLengthPage> {
  String _currentText = '我是初始文本';

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
    _currentText = '';
    return <Widget>[
      new Column(
        children: <Widget>[
          SizedBox(height: 4),
          _textView(_currentText),
          FlatButton(
            onPressed: () {
              _currentText = _longNormalTextString();
              setState(() {});
            },
            child: Text('使用正常的文本'),
          ),
          FlatButton(
            onPressed: () {
              _currentText = _longEmojiString();
              setState(() {});
            },
            child: Text('使用特殊的emoji'),
          ),
          _pageList(),
        ],
      )
    ];
  }

  String _longNormalTextString() {
    String longString = '';
    for (var i = 0; i < 499; i++) {
      longString += '正常的文本';
    }
    return longString;
  }

  String _longEmojiString() {
    String longString = '';
    for (var i = 0; i < 499; i++) {
      longString += '👨‍👩‍👧';
    }
    return longString;
  }

  Widget _textView(text) {
    int maxLength = 10;
    return CQInputTextView(
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
    return CQImageDeleteAddPickList(
      // imageOrPhotoModels: _imageOrPhotoModels,
      imageOrPhotoModelsChangeBlock: (List<dynamic> imageOrPhotoModels) {},
    );
  }
}
