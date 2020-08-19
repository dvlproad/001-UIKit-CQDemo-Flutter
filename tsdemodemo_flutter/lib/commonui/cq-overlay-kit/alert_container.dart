/*  基础的 MessageAlert 部分 */
import 'package:flutter/material.dart';

class CQAlertContainer extends StatelessWidget {
  final Widget contentWidget;
  final Widget buttonsWidget;

  CQAlertContainer({
    Key key,
    this.contentWidget,
    this.buttonsWidget,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width - 100,
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffeeeeee),
      ),
      child: Column(
        children: <Widget>[
          // Flexible(
          Expanded(
            child: this.contentWidget,
          ),
          this.buttonsWidget,
        ],
      ),
    );
  }
}
