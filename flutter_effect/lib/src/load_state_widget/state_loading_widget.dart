import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StateLoadingWidget extends StatefulWidget {
  StateLoadingWidget({
    Key key,
  }) : super(key: key);

  @override
  _StateLoadingWidgetState createState() => _StateLoadingWidgetState();
}

class _StateLoadingWidgetState extends State<StateLoadingWidget> {
  @override
  Widget build(BuildContext context) {
    return _loadingView;
  }

  ///加载中视图
  Widget get _loadingView {
    return Container(
      width: double.infinity,
      height: double.infinity,
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        height: 200,
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 150,
              height: 150,
              child: Image.asset('images/cargo_loading.gif'),
            ),
            Text(
              '拼命加载中...',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
