/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2023-03-18 22:29:42
 * @Description: 
 */
import 'package:flutter/material.dart';
import 'package:tsdemo_images_action/tsdemo_images_action.dart';
import 'package:flutter_images_picker/flutter_images_picker.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() {
  PermissionsManager.globalKey = globalKey;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: globalKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TSPhotoAlbumHomePage(),
      routes: PhotoAlbumRouters.routes,
    );
  }
}
