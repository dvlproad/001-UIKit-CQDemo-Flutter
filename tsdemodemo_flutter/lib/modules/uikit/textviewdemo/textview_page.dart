import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textview/input_textview.dart';

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
