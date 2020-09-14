import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textview/input_textview.dart';
// [Dart学习--之Runes与Symbols相关方法总结](https://www.cnblogs.com/lxlx1798/p/11371285.html)
// 在Dart中，Runes代表字符串的UTF-32字符集, 另一种Strings
// Unicode为每一个字符、标点符号、表情符号等都定义了 一个唯一的数值
// 由于Dart字符串是UTF-16的字符序列，所以在字符串中表达32的字符序列就需要新的语法了
// 通常使用\uXXXX的方式来表示, 这里的XXXX是4个16进制的数, 如，心形符号(♥)是\u2665
// 对于非4个数值的情况，把编码值放到大括号中即可, 如，笑脸emoji (😆) 是\u{1f600}

class TSTextViewPage extends StatefulWidget {
  TSTextViewPage({Key key}) : super(key: key);

  @override
  _TSTextViewPageState createState() => new _TSTextViewPageState();
}

class _TSTextViewPageState extends State<TSTextViewPage> {
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
          _textView('\u2665'),
          SizedBox(height: 4),
          _textView('\u{1f605}'),
          SizedBox(height: 4),
          _textView('✋🏼'),
          SizedBox(height: 4),
          _textView('🤘🏼'),
          SizedBox(height: 4),
          _textView('🤘'),
          SizedBox(height: 4),
          _textView('👪'),
          SizedBox(height: 4),
          _textView('👨‍👩‍👧'),
        ],
      )
    ];
  }

  Widget _textView(text) {
    int maxLength = 250;
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
}
