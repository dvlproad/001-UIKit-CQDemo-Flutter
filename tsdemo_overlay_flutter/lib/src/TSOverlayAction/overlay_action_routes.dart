// overlay 的 action 测试
import 'package:flutter/widgets.dart';
import './overlay_action_home_page.dart';

class OverlayActionRouters {
  static const overlayActionHomePage = '/overlay_action_home_page';

  static Map<String, WidgetBuilder> routes = {
    OverlayActionRouters.overlayActionHomePage: (BuildContext context) =>
        TSOverlayActionHomePage(),
  };
}
