import 'package:tsdemodemo_flutter/commonui/base-uikit/bg_border_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FullEmptyView extends StatelessWidget {
  final String text;
  const FullEmptyView({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Colors.transparent,
          height: 446,
          child: PartEmptyView(text: text),
        )
      ],
    );
  }
}

class PartEmptyView extends StatelessWidget {
  final String text;
  PartEmptyView({Key key, this.text = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CJBGImageWidget(
      backgroundImage:
          AssetImage('lib/commonui/cq-uikit/images/pic_搜索为空页面.png'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            this.text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
          SizedBox(height: 120),
        ],
      ),
    );
  }
}
