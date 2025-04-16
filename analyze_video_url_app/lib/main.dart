/*
 * @Author: dvlproad
 * @Date: 2025-03-31 15:27:36
 * @LastEditors: dvlproad
 * @LastEditTime: 2025-04-16 22:08:13
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
