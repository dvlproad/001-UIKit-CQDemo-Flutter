import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/commonui/cq-uikit/textbutton.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_routes.dart';
import 'package:tsdemodemo_flutter/modules/demo/demo_routes.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_routes.dart';
import 'package:tsdemodemo_flutter/modules/overlay/overlay_routes.dart';
import 'package:tsdemodemo_flutter/modules/uikit/baseui_routes.dart';
import 'package:tsdemodemo_flutter/modules/util/util_routes.dart';
import 'package:tsdemodemo_flutter/router/router.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            demoHomeButton(),
            baseuiHomeButton(),
            overlayHomeButton(),
            moduleHomeButton(),
            utilHomeButton(),
            architectureHomeButton(),
            gestureHomeButton(),
          ],
        ),
      ),
    );
  }

  // 进入Demo主页的按钮
  Widget demoHomeButton() {
    return ThemeBGButton(
      text: "Demo",
      onPressed: () {
        Navigator.pushNamed(context, DemoRouters.demoHomePage);
      },
    );
  }

  // 进入BaseUI测试主页的按钮
  Widget baseuiHomeButton() {
    return ThemeBGButton(
      text: "BaseUI",
      onPressed: () {
        Navigator.pushNamed(context, BaseUIKitRouters.uikitHomePage);
      },
    );
  }

  // 进入架构测试主页的按钮
  Widget overlayHomeButton() {
    return ThemeBGButton(
      text: "Overlay",
      onPressed: () {
        Navigator.pushNamed(context, OverlayAllRouters.overlayMainPage);
      },
    );
  }

  // 进入举报模块测试主页的按钮
  Widget moduleHomeButton() {
    return ThemeBGButton(
      text: "功能模块(举报+排行榜+搜索+引导蒙层)",
      onPressed: () {
        Navigator.pushNamed(context, Routers.moduleHomePage);
      },
    );
  }

  // 进入工具测试主页的按钮
  Widget utilHomeButton() {
    return ThemeBGButton(
      text: "Util",
      onPressed: () {
        Navigator.pushNamed(context, UtilRouters.utilHomePage);
      },
    );
  }

  // 进入架构测试主页的按钮
  Widget architectureHomeButton() {
    return ThemeBGButton(
      text: "架构、设计模式",
      onPressed: () {
        Navigator.pushNamed(context, ArcRouters.architectureHomePage);
      },
    );
  }

  // 进入手势测试主页的按钮
  Widget gestureHomeButton() {
    return ThemeBGButton(
      text: "手势 Gesture2",
      onPressed: () {
        Navigator.pushNamed(context, GestureRouters.gestureHomePage);
      },
    );
  }
}
