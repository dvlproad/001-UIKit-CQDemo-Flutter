import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './base-uikit/bg_border_widget.dart';

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
          AssetImage('assets/empty_bg_empty.png', package: 'flutter_effect'),
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
