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
      home: PieChartPage(),
      routes: BaseUIKitRouters.routes,
    );
  }
}
