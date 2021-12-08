import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateErrorWidget extends StatefulWidget {
  final VoidCallback errorRetry; //错误事件处理

  StateErrorWidget({
    Key key,
    this.errorRetry,
  }) : super(key: key);

  @override
  _StateErrorWidgetState createState() => _StateErrorWidgetState();
}

class _StateErrorWidgetState extends State<StateErrorWidget> {
  @override
  Widget build(BuildContext context) {
    return _errorView;
  }

  ///错误视图
  Widget get _errorView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: InkWell(
        onTap: widget.errorRetry,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 405,
              height: 317,
              child: Image.asset(
                'assets/empty_bg_empty.png',
                package: 'flutter_effect',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              "加载失败，请轻触重试!",
              style: TextStyle(
                color: Colors.green,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
