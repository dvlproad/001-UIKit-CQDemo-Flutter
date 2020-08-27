import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_home_page.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_page.dart';

class ImagesBrowserRouters {
  // 组件模块
  static const imagesbrowserHomePage = '/imagesbrowser_home_page';
  static const imagesBrowserPage = '/imagesBrowser_page'; // 图片浏览器(浏览+缩放)
  static const imagesCarouselPage = '/images_carousel_page';
  static const imagesZoomablePage = '/images_zoomable_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    ImagesBrowserRouters.imagesbrowserHomePage: (BuildContext context) =>
        TSImagesBrowserHomePage(),
    ImagesBrowserRouters.imagesBrowserPage: (BuildContext context) =>
        TSImagesBrowserPage(),
    ImagesBrowserRouters.imagesCarouselPage: (BuildContext context) =>
        TSImagesBrowserPage(),
    ImagesBrowserRouters.imagesZoomablePage: (BuildContext context) =>
        TSImagesBrowserPage(),
  };
}
