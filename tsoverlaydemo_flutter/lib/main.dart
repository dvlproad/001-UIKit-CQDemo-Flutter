import 'package:flutter/material.dart';
import 'package:tsdemo_overlay_flutter/tsdemo_overlay_flutter.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // builder: EasyLoading.init(),
      builder: OverlayActionUtil.init_flutter_easyloading(),
      // builder: (context, Widget child) {
      //   return child;
      // },
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSOverlayMainPage(),
      routes: OverlayAllRouters.routes,
    );
  }
}
