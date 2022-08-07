/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2022-08-07 18:35:44
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_baseui/tsdemo_baseui.dart';
import './piechart/PieChartPage.dart';

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
