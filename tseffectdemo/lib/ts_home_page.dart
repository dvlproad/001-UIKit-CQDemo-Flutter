import 'package:flutter/material.dart';
import './ts_page.dart';
import './ts_layout_page.dart';

class TSHomePage extends StatefulWidget {
  TSHomePage({
    Key key,
  }) : super(key: key);

  @override
  _TSHomePageState createState() => _TSHomePageState();
}

class _TSHomePageState extends State<TSHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AppBar(导航栏)"),
      ),
      body: Container(
        //宽高都充满屏幕剩余空间
        width: double.infinity,
        height: double.infinity,
        color: Colors.red,
        child: _buildWidget,
      ),
    );
  }

  Widget get _buildWidget {
    return Column(
      children: [
        TextButton(
          child: Text('导航栏'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TSAppBarPage()));
          },
        ),
        TextButton(
          child: Text('布局测试'),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => TSLayoutPage()));
          },
        ),
      ],
    );
  }
}
