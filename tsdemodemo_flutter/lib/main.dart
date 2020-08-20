import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_routes.dart';
import 'package:tsdemodemo_flutter/modules/demo/demo_routes.dart';
import 'package:tsdemodemo_flutter/modules/devtool/devtool_routes.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_routes.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_home_page.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page1.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page2.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page3.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page4.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page5.dart';
import 'package:tsdemodemo_flutter/modules/overlay/TSOverlayView/overlay_view_routes.dart';
import 'package:tsdemodemo_flutter/modules/overlay/overlay_routes.dart';
import 'package:tsdemodemo_flutter/modules/search/search_routes.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_routes.dart';
import 'package:tsdemodemo_flutter/modules/util/util_routes.dart';

import 'package:tsdemodemo_flutter/router/router.dart';
import 'package:tsdemodemo_flutter/modules/main/main_page.dart';

void main() {
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this); //销毁监听
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 添加监听
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    print("lifeChanged:$state");
    switch (state) {
      case AppLifecycleState
          .inactive: // inactive界面退到后台或弹出对话框情况下， 即失去了焦点但仍可以执行drawframe回调；同安卓的onPause；
        {
          break;
        }
      case AppLifecycleState.resumed: // 应用程序可见，前台
        {
          break;
        }
      case AppLifecycleState.paused: // 应用程序不可见，后台
        {
          break;
        }
      case AppLifecycleState.detached: // detached
        {
          break;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll({
      // 引导蒙层 guide
      Routers.guideHomePage: (BuildContext context) =>
          GuideOverlayTestHomePage(),
      Routers.guideOverlayTestPage1: (BuildContext context) =>
          GuideOverlayTestPage1(),
      Routers.guideOverlayTestPage2: (BuildContext context) =>
          GuideOverlayTestPage2(),
      Routers.guideOverlayTestPage3: (BuildContext context) =>
          GuideOverlayTestPage3(),
      Routers.guideOverlayTestPage4: (BuildContext context) =>
          GuideOverlayTestPage4(),
      Routers.guideOverlayTestPage5: (BuildContext context) =>
          GuideOverlayTestPage5(),
    });
    // Demo
    routes.addAll(DemoRouters.routes);
    // devTool
    routes.addAll(DevToolRouters.routes);
    // BaseUI
    routes.addAll(BaseUIKitRouters.routes);
    // overlay
    routes.addAll(OverlayAllRouters.routes);
    // 工具 util
    routes.addAll(UtilRouters.routes);
    // 设计模式 architecture
    routes.addAll(ArcRouters.routes);
    // 手势 Gesture
    routes.addAll(GestureRouters.routes);
    // 搜索 Search
    routes.addAll(SearchRouters.routes);

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
      // home: GuideOverlayTestHomePage(), // 首页
      // initialRoute: Routers.guideHomePage, // 设置首页
//      initialRoute: OverlayViewRouters.textInputAlertViewPage, // 设置首页
      onGenerateRoute: (settings) {
        return Routers().generator(settings);
      },
      routes: routes,
    );
  }
}
