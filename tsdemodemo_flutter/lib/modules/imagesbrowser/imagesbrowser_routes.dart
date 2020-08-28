import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_home_page.dart';
import 'package:tsdemodemo_flutter/modules/imagesbrowser/imagesbrowser_page.dart';

class ImagesBrowserRouters {
  // 组件模块
  static const imagesbrowserHomePage = '/imagesbrowser_home_page';
  static const imagesBrowserPage = '/imagesBrowser_page'; // 图片浏览器(浏览+缩放)
  // static const imagesCarouselPage = '/images_carousel_page';
  // static const imagesZoomablePage = '/images_zoomable_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    ImagesBrowserRouters.imagesbrowserHomePage: (BuildContext context) =>
        TSImagesBrowserHomePage(),

    ImagesBrowserRouters.imagesBrowserPage: (BuildContext context) {
      List<String> egImages = <String>[
        'http://pic1.win4000.com/pic/f/04/4f085d0c9b.gif',
        'https://photo.tuchong.com/14649482/f/601672690.jpg',
        'https://photo.tuchong.com/17325605/f/641585173.jpg',
        'https://photo.tuchong.com/3541468/f/256561232.jpg',
        'http://pic1.win4000.com/pic/c/c1/25cbd37070.gif',
        'https://photo.tuchong.com/16709139/f/278778447.jpg',
        'https://photo.tuchong.com/15195571/f/233361383.jpg',
        'https://photo.tuchong.com/5040418/f/43305517.jpg',
        'https://photo.tuchong.com/3019649/f/302699092.jpg',
        'http://z.aisaiya.com/gif/202006/ea08c82cfcc6501f0edec03a3c7b241f.gif',
      ];
      int currentIndex = 1;
      return TSImagesBrowserPage(
        images: egImages,
        currentIndex: currentIndex,
      );
    }

    // ImagesBrowserRouters.imagesCarouselPage: (BuildContext context) =>
    //     TSImagesBrowserPage(),
    // ImagesBrowserRouters.imagesZoomablePage: (BuildContext context) =>
    //     TSImagesBrowserPage(),
  };
}
