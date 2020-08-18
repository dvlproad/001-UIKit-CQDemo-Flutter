import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_home_page.dart';
import 'package:tsdemodemo_flutter/modules/gesture/gesture_listener_page.dart';

class GestureRouters {
  // 组件模块
  static const gestureHomePage = '/gesture_home_page';
  static const listenerPage = '/listener_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    GestureRouters.gestureHomePage: (BuildContext context) =>
        TSGestureHomePage(),
    GestureRouters.listenerPage: (BuildContext context) =>
        GestureListenerPage(),
  };
}
