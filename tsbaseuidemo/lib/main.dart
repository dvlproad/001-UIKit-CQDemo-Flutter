/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-17 11:35:47
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_baseui/tsdemo_baseui.dart';

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
      home: TSBaseUIHomePage(),
      // home: PieChartPage(),
      routes: BaseUIKitRouters.routes,
    );
  }
}
