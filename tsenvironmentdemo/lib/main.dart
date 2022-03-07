import 'package:flutter/material.dart';
import 'package:tsdemo_environment_flutter/tsdemo_environment_flutter.dart';
import 'package:tsdemo_environment_flutter/src/overlay_page2.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() {
  MainInit.initWithGlobalKey(globalKey, PackageType.develop1);
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
