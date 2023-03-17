/*
 * @Author: dvlproad
 * @Date: 2023-03-17 15:22:47
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 16:37:26
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_versioncheck/tsdemo_versioncheck.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSVersionCheckMainPage(),
      routes: VersionCheckAllRouters.routes,
    );
  }
}
