import 'package:flutter/material.dart';
import 'package:flutter_demo_kit/flutter_demo_kit.dart';
// import 'package:flutter_cache_kit/flutter_cache_kit.dart';

class TSCacheHomePage extends StatefulWidget {
  @override
  _TSCacheHomePageState createState() => _TSCacheHomePageState();
}

class _TSCacheHomePageState extends State<TSCacheHomePage> {
  void dispose() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cache'),
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.topCenter,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text('1'),
              onTap: () {},
            ),
            ListTile(
              title: Text('2'),
              onTap: () {},
            ),
            ListTile(
              title: Text('3'),
              onTap: () {},
            ),
            ListTile(
              title: Text('4'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
