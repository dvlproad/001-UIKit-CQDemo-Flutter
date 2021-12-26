import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_overlay_kit/flutter_overlay_kit.dart';

class TSToastHomePage extends StatefulWidget {
  @override
  _TSToastHomePageState createState() => _TSToastHomePageState();
}

class _TSToastHomePageState extends State<TSToastHomePage> {
  int selectedSexIndex1;
  int selectedSexIndex2;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Toast'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            _chooseSexRow1,
          ],
        ),
      ),
    );
  }

  Widget get _chooseSexRow1 {
    return ListTile(
      title: Text('toast'),
      onTap: () {
        ToastUtil.showMessage('提示信息');
      },
    );
  }
}
