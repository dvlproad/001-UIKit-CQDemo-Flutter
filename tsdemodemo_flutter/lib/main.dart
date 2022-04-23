import 'package:app_network/app_network.dart';

import 'package:flutter/material.dart';
import 'package:tsdemo_baseui/tsdemo_baseui.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_routes.dart';
import 'package:tsdemodemo_flutter/modules/demo/demo_routes.dart';
import 'package:tsdemo_environment_flutter/tsdemo_environment_flutter.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_routes.dart';
import 'package:tsdemo_guide/src/guide_routes.dart';
import 'package:tsdemo_images_browser/src/imagesbrowser_routes.dart';
import 'package:tsdemo_overlay_flutter/src/overlay_routes.dart';
import 'package:tsdemo_images_action/src/photoalbum_routes.dart';
import 'package:tsdemo_baseui/src/baseui_routes.dart';
import 'package:tsdemodemo_flutter/modules/util/util_routes.dart';

import 'package:tsdemodemo_flutter/router/router.dart';
import 'package:tsdemodemo_flutter/modules/main/main_page.dart';

GlobalKey<NavigatorState> globalKey = GlobalKey<NavigatorState>();

void main() {
  MainInit.initWithGlobalKey(globalKey, PackageType.develop1);

  Future.delayed(Duration(milliseconds: 0)).then((value) {
    AppNetworkKit.post('abc');
  });

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
    // 图片浏览 ImagesBrowser
    routes.addAll(ImagesBrowserRouters.routes);
    // 相册
    routes.addAll(PhotoAlbumRouters.routes);
    // 引导蒙层模块 guide
    routes.addAll(GuideRouters.routes);

    return MaterialApp(
      ///注意 一定要navigatorKey 才能在所有界面上显示
      navigatorKey: globalKey,
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
      // home: TSBaseUIHomePage(),
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
