

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String text;
  EmptyView({Key key, this.text}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Image(
          image: AssetImage('lib/Resources/report/arrow_right.png'),
          height: 100,
        ),
        Text(this.text,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 14, color: Colors.white),)
      ],
    );
  }
}