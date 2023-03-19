/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-19 14:21:08
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_environment_flutter/tsdemo_environment_flutter.dart';
import 'package:tsdemo_environment_flutter/src/overlay_page2.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  MainInit.initWithGlobalKey(
    globalKey,
    PackageNetworkType.test1,
    PackageTargetType.formal,
  );
  OverlayPage2.globalKey = globalKey;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      ///注意 一定要navigatorKey 才能在所有界面上显示
      navigatorKey: globalKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSDevToolHomePage(),
      routes: DevToolRouters.routes,
    );
  }
}
