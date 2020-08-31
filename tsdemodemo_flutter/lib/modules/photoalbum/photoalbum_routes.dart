import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/photoalbum/photoalbum_home_page.dart';
import 'package:tsdemodemo_flutter/modules/photoalbum/photoalbum_selected_page.dart';

class PhotoAlbumRouters {
  // 组件模块
  static const photoAlbumHomePage = '/photoAlbum_home_page';
  static const photoAlbumPage = '/photoAlbum_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    PhotoAlbumRouters.photoAlbumHomePage: (BuildContext context) =>
        TSPhotoAlbumHomePage(),

    PhotoAlbumRouters.photoAlbumPage: (BuildContext context) {
      return TSPhotoAlbumSelectPage();
    }

    // ImagesBrowserRouters.imagesCarouselPage: (BuildContext context) =>
    //     TSImagesBrowserPage(),
    // ImagesBrowserRouters.imagesZoomablePage: (BuildContext context) =>
    //     TSImagesBrowserPage(),
  };
}
