/*
 * @Author: dvlproad
 * @Date: 2022-04-18 03:24:17
 * @LastEditors: dvlproad
 * @LastEditTime: 2024-11-18 20:51:50
 * @Description: 
 */
import 'package:flutter/material.dart';

import './ts_env_network_util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  TSEnvNetworkUtil.initEnv(PackageNetworkType.develop1);

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
      home: const EnvPage(),
    );
  }
}
