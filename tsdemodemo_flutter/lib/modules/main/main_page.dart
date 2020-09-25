import 'package:flutter/material.dart';
import 'package:flutter_baseui_kit/cq-uikit/button/textbutton.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_routes.dart';
import 'package:tsdemodemo_flutter/modules/demo/demo_routes.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_routes.dart';
import 'package:tsdemo_overlay_flutter/src/overlay_routes.dart';
import 'package:tsdemo_images_browser/src/imagesbrowser_routes.dart';
import 'package:tsdemo_environment_flutter/src/devtool_routes.dart';
import 'package:tsdemodemo_flutter/modules/photoalbum/photoalbum_routes.dart';
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
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            showLogButton(),
            demoHomeButton(),
            devtoolHomeButton(),
            baseuiHomeButton(),
            overlayHomeButton(),
            moduleHomeButton(),
            utilHomeButton(),
            architectureHomeButton(),
            gestureHomeButton(),
            imagesbrowserHomeButton(),
            photoAlbumHomeButton(),
          ],
        ),
      ),
    );
  }

  // 进入Demo主页的按钮
  Widget demoHomeButton() {
    return CQPinkThemeBGButton(
      title: "Demo",
      onPressed: () {
        Navigator.pushNamed(context, DemoRouters.demoHomePage);
      },
    );
  }

  // 显示 Log 窗口的按钮
  Widget showLogButton() {
    return CQPinkThemeBGButton(
      title: "LogWindow",
      onPressed: () {
        // showLogWindow();
      },
    );
  }

  // 进入 DevTool 主页的按钮
  Widget devtoolHomeButton() {
    return CQPinkThemeBGButton(
      title: "DevTool(调试工具)",
      onPressed: () {
        Navigator.pushNamed(context, DevToolRouters.devtoolHomePage);
      },
    );
  }

  // 进入BaseUI测试主页的按钮
  Widget baseuiHomeButton() {
    return CQPinkThemeBGButton(
      title: "BaseUI",
      onPressed: () {
        Navigator.pushNamed(context, BaseUIKitRouters.uikitHomePage);
      },
    );
  }

  // 进入架构测试主页的按钮
  Widget overlayHomeButton() {
    return CQPinkThemeBGButton(
      title: "Overlay",
      onPressed: () {
        Navigator.pushNamed(context, OverlayAllRouters.overlayMainPage);
      },
    );
  }

  // 进入举报模块测试主页的按钮
  Widget moduleHomeButton() {
    return CQPinkThemeBGButton(
      title: "功能模块(举报+排行榜+搜索+引导蒙层)",
      onPressed: () {
        Navigator.pushNamed(context, Routers.moduleHomePage);
      },
    );
  }

  // 进入工具测试主页的按钮
  Widget utilHomeButton() {
    return CQPinkThemeBGButton(
      title: "Util",
      onPressed: () {
        Navigator.pushNamed(context, UtilRouters.utilHomePage);
      },
    );
  }

  // 进入架构测试主页的按钮
  Widget architectureHomeButton() {
    return CQPinkThemeBGButton(
      title: "架构、设计模式",
      onPressed: () {
        Navigator.pushNamed(context, ArcRouters.architectureHomePage);
      },
    );
  }

  // 进入手势测试主页的按钮
  Widget gestureHomeButton() {
    return CQPinkThemeBGButton(
      title: "手势 Gesture2",
      onPressed: () {
        Navigator.pushNamed(context, GestureRouters.gestureHomePage);
      },
    );
  }

  // 进入图片浏览测试主页的按钮
  Widget imagesbrowserHomeButton() {
    return CQPinkThemeBGButton(
      title: "图片浏览 ImagesBrowser",
      onPressed: () {
        Navigator.pushNamed(
            context, ImagesBrowserRouters.imagesbrowserHomePage);
      },
    );
  }

  // 进入相册测试主页的按钮
  Widget photoAlbumHomeButton() {
    return CQPinkThemeBGButton(
      title: "相册 photoAlbum",
      onPressed: () {
        Navigator.pushNamed(context, PhotoAlbumRouters.photoAlbumHomePage);
      },
    );
  }
}
