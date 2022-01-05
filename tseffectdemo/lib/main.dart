import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tsdemo_effect/tsdemo_effect.dart';

import './ts_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Effect Demo',
      // builder: LoadingUtil.init(),
      builder: EasyLoading.init(), // 不适用LoadingUtil.init()
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSEffectHomePage(),
    );
  }
}
