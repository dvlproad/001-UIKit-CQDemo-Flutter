/*  基础的 MessageAlert 部分 */
import 'package:flutter/material.dart';

class CQAlertContainer extends StatelessWidget {
  final Widget contentWidget;
  final double buttonsWidgetHeight;
  final Widget buttonsWidget;

  CQAlertContainer({
    Key key,
    this.contentWidget,
    this.buttonsWidgetHeight,
    this.buttonsWidget,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double containerWidth = width - 100;
    return Container(
      width: containerWidth,
      constraints: BoxConstraints(
        //minWidth: double.infinity,
        minHeight: 160,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xffeeeeee),
      ),
      child: Stack(
        alignment: Alignment.topCenter, //指定未定位或部分定位widget的对齐方式
        children: [
          Container(
            margin: EdgeInsets.only(bottom: this.buttonsWidgetHeight ?? 80),
            child: Column(
              children: <Widget>[
                this.contentWidget,
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              // color: Colors.red,
              width: containerWidth,
              child: this.buttonsWidget,
            ),
          ),
        ],
      ),
    );
  }
}
