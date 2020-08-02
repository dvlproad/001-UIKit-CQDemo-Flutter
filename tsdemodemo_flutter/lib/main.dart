import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_home_page.dart';
import 'package:tsdemodemo_flutter/modules/search/search_page.dart';

import 'package:tsdemodemo_flutter/router/router.dart';
import 'package:tsdemodemo_flutter/modules/home/home_page.dart';

// 测试分组列表的实现方式
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList1.dart';
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList2.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      onGenerateRoute: (settings) {
        return Routers().generator(settings);
      },
      routes: <String, WidgetBuilder>{
        Routers.architectureHomePage: (BuildContext context) => TSArcHomePage(),
        Routers.sectionTableViewMethod1Page: (BuildContext context) =>
            CreateSectionList1(),
        Routers.sectionTableViewMethod2Page: (BuildContext context) =>
            CreateSectionList2(),
        Routers.searchPage: (BuildContext context) => SearchPage(),
      },
    );
  }
}
