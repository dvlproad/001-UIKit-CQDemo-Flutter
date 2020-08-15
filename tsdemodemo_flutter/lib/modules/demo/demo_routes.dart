import 'package:flutter/widgets.dart';
import 'package:tsdemodemo_flutter/modules/demo/TSSectionTableViewPage.dart';

// 测试分组列表的实现方式
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList1.dart';
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList2.dart';

class DemoRouters {
  // 组件模块
  static const demoHomePage = '/demo_home_page';
  static const sectionTableViewMethod1Page = '/section_table_view_method1_page';
  static const sectionTableViewMethod2Page = '/section_table_view_method2_page';

  static Map<String, WidgetBuilder> routes = {
    // 组件 components
    DemoRouters.demoHomePage: (BuildContext context) =>
        TSSectionTableViewPage(),
    DemoRouters.sectionTableViewMethod1Page: (BuildContext context) =>
        CreateSectionList1(),
    DemoRouters.sectionTableViewMethod2Page: (BuildContext context) =>
        CreateSectionList2(),
  };
}
