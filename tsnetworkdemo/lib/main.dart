/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 01:22:00
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_network/tsdemo_network.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() {
  runApp(MyApp());

  APP_Network_And_AllEnvironmentUtil.initNetworkAndProxy_demo(
    globalKey: globalKey,
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      ///注意 一定要navigatorKey 才能在所有界面上显示
      navigatorKey: globalKey,
      title: 'Flutter Demo',
      builder: EasyLoading.init(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSNetworkMainPage(),
      routes: NetworkAllRouters.routes,
    );
  }
}
