import 'package:flutter/material.dart';
import 'package:tsdemo_images_browser/tsdemo_images_browser.dart';

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
      home: TSImagesBrowserHomePage(),
      routes: ImagesBrowserRouters.routes,
    );
  }
}
