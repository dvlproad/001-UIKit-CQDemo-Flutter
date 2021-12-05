import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';

class TSLoadingPage extends StatefulWidget {
  TSLoadingPage({
    Key key,
  }) : super(key: key);

  @override
  _TSLoadingPageState createState() => _TSLoadingPageState();
}

class _TSLoadingPageState extends State<TSLoadingPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Loading(加载中)"),
      ),
      body: Center(
        child: Container(
          //宽高都充满屏幕剩余空间
          width: double.infinity,
          height: double.infinity,
          color: Colors.red,
          child: _buildWidget,
        ),
      ),
    );
  }

  Widget get _buildWidget {
    return StateLoadingWidget();
  }
}
