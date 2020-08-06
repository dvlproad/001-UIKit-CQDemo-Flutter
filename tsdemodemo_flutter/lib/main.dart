import 'package:flutter/material.dart';
import 'package:tsdemodemo_flutter/modules/architecture/0setState/theme_result_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page0.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page1.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/provider_use_page3.dart';
import 'package:tsdemodemo_flutter/modules/architecture/Provider/theme_result_page2.dart';
import 'package:tsdemodemo_flutter/modules/architecture/arc_home_page.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc/theme_result_page3.dart';
import 'package:tsdemodemo_flutter/modules/architecture/bloc_provider/theme_result_page4.dart';
import 'package:tsdemodemo_flutter/modules/architecture/redux/theme_result_page5.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_home_page.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page1.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page2.dart';
import 'package:tsdemodemo_flutter/modules/guide/guide_overlay_test_page3.dart';
import 'package:tsdemodemo_flutter/modules/search/search_page.dart';
import 'package:tsdemodemo_flutter/modules/util/device_info_page.dart';

import 'package:tsdemodemo_flutter/router/router.dart';
import 'package:tsdemodemo_flutter/modules/main/main_page.dart';

// 测试分组列表的实现方式
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList1.dart';
import 'package:tsdemodemo_flutter/modules/demo/CreateSectionList2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      // home: GuideOverlayTestHomePage(), // 首页
      initialRoute: Routers.guideHomePage, // 设置首页
      onGenerateRoute: (settings) {
        return Routers().generator(settings);
      },
      routes: <String, WidgetBuilder>{
        // 引导蒙层 guide
        Routers.guideHomePage: (BuildContext context) =>
            GuideOverlayTestHomePage(),
        Routers.guideOverlayTestPage1: (BuildContext context) =>
            GuideOverlayTestPage1(),
        Routers.guideOverlayTestPage2: (BuildContext context) =>
            GuideOverlayTestPage2(),
        Routers.guideOverlayTestPage3: (BuildContext context) =>
            GuideOverlayTestPage3(),
        // 工具 util
        Routers.utilHomePage: (BuildContext context) => TSDeviceInfoPage(),
        // 设计模式 architecture
        Routers.architectureHomePage: (BuildContext context) => TSArcHomePage(),
        Routers.arcProviderUsePage0: (BuildContext context) =>
            ProviderUsePage0(),
        Routers.arcProviderUsePage1: (BuildContext context) =>
            ProviderUsePage1(),
        Routers.arcProviderUsePage2: (BuildContext context) =>
            ProviderUsePage2(),
        Routers.arcProviderUsePage3: (BuildContext context) =>
            ProviderUsePage3(),
        Routers.arc0SetStatePage: (BuildContext context) => ThemeResultPage1(),
        Routers.arc1ProviderPage: (BuildContext context) => ThemeResultPage2(),
        // Routers.arc1ProviderSharePage: (BuildContext context) => ThemeResultPage2(),
        Routers.arc2BlockPage: (BuildContext context) => ThemeResultPage3(),
        Routers.arc2BlockProviderPage: (BuildContext context) =>
            ThemeResultPage4(),
        Routers.arc3ReduxPage: (BuildContext context) => ThemeResultPage5(),
        // 组件 components
        Routers.sectionTableViewMethod1Page: (BuildContext context) =>
            CreateSectionList1(),
        Routers.sectionTableViewMethod2Page: (BuildContext context) =>
            CreateSectionList2(),
        Routers.searchPage: (BuildContext context) => SearchPage(),
      },
    );
  }
}
