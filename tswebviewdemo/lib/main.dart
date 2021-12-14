import 'package:flutter/material.dart';
import 'package:tsdemo_webview/tsdemo_webview.dart';

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
      home: TSWebViewHomePage(),
      routes: WebViewRouters.routes,
    );
  }
}
