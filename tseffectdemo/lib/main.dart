import 'package:flutter/material.dart';
import 'package:flutter_effect/flutter_effect.dart';
import 'package:tsdemo_effect/tsdemo_effect.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Effect Demo',
      builder: LoadingUtil.init(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSEffectHomePage(),
    );
  }
}
