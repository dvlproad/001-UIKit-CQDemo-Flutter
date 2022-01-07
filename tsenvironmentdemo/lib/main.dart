import 'package:flutter/material.dart';
import 'package:tsdemo_environment_flutter/tsdemo_environment_flutter.dart';
import 'package:flutter_environment/flutter_environment.dart';

void main() {
  GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();
  ApplicationDraggableManager.globalKey = globalKey;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      ///注意 一定要navigatorKey 才能在所有界面上显示
      navigatorKey: ApplicationDraggableManager.globalKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSDevToolHomePage(),
      routes: DevToolRouters.routes,
    );
  }
}
