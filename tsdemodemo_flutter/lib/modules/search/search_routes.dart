import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/search/search_home_page.dart';
import 'package:tsdemodemo_flutter/modules/search/search_page.dart';

class SearchRouters {
  // 组件模块
  static const searchHomePage = '/search_home_page';

  // 搜索模块
  static const searchPage = '/search_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    SearchRouters.searchHomePage: (BuildContext context) => TSSearchHomePage(),
    SearchRouters.searchPage: (BuildContext context) => SearchPage(),
  };
}
