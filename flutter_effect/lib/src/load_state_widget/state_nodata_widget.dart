import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateNodataWidget extends StatefulWidget {
  final VoidCallback emptyRetry; //无数据事件处理

  StateNodataWidget({
    Key key,
    this.emptyRetry,
  }) : super(key: key);

  @override
  _StateNodataWidgetState createState() => _StateNodataWidgetState();
}

class _StateNodataWidgetState extends State<StateNodataWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 750,
      height: double.infinity,
      child: InkWell(
        onTap: widget.emptyRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 405,
              height: 281,
              child: Image.asset(
                'assets/empty_bg_empty.png',
                package: 'flutter_effect',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              '暂无相关数据,轻触重试~',
              style: TextStyle(color: Colors.red, fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
