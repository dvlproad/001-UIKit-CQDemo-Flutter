import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
import 'package:flutter_network/flutter_network.dart';

import 'dart:convert';

class TSNetworkHomePage extends StatefulWidget {
  @override
  _TSNetworkHomePageState createState() => _TSNetworkHomePageState();
}

class _TSNetworkHomePageState extends State<TSNetworkHomePage> {
  int selectedSexIndex1;
  int selectedSexIndex2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Network'),
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
      title: Text('Get请求'),
      onTap: () {},
    );
  }
}
