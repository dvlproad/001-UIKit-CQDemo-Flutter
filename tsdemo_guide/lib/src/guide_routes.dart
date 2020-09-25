// 引导蒙层模块
import 'package:flutter/widgets.dart';
import './guide_overlay_test_home_page.dart';
import './guide_overlay_test_page1.dart';
import './guide_overlay_test_page2.dart';
import './guide_overlay_test_page3.dart';
import './guide_overlay_test_page4.dart';
import './guide_overlay_test_page5.dart';

class GuideRouters {
  static const guideHomePage = '/guide_home_page';
  static const guideOverlayTestPage1 = '/guide_page1';
  static const guideOverlayTestPage2 = '/guide_page2';
  static const guideOverlayTestPage3 = '/guide_page3';
  static const guideOverlayTestPage4 = '/guide_page4';
  static const guideOverlayTestPage5 = '/guide_page5';

  static Map<String, WidgetBuilder> routes = {
    GuideRouters.guideHomePage: (BuildContext context) =>
        GuideOverlayTestHomePage(),
    GuideRouters.guideOverlayTestPage1: (BuildContext context) =>
        GuideOverlayTestPage1(),
    GuideRouters.guideOverlayTestPage2: (BuildContext context) =>
        GuideOverlayTestPage2(),
    GuideRouters.guideOverlayTestPage3: (BuildContext context) =>
        GuideOverlayTestPage3(),
    GuideRouters.guideOverlayTestPage4: (BuildContext context) =>
        GuideOverlayTestPage4(),
    GuideRouters.guideOverlayTestPage5: (BuildContext context) =>
        GuideOverlayTestPage5(),
  };
}
